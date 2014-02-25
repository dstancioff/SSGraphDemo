//
//  GraphView.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 2/26/10.
//  Copyright 2010 Spritely Software.
//

#import "SSGraphView.h"
#import "SSHorizontalAxisPoint.h"
#import "SSVerticalAxisPoint.h"

#import "SSFormatters.h"

static void *modifiedContext = &modifiedContext;

@interface SSGraphView ()
- (CGPoint)validCenterForValueLabelWithX:(double)x;
@end

@implementation SSGraphView
@dynamic selectedPoints;
@dynamic useLogarithmicScale;
@dynamic usePercentScale;
@dynamic dataSets;
@synthesize style;
@synthesize latestDate;
@synthesize earliestDate;
@synthesize allowSelection;
@synthesize isMoving;
@synthesize reusableAnnotationViews = reusableAnnotationViews;
@synthesize activeAnnotationViews = activeAnnotationViews;

- (NSArray *)dataSets
{
    return dataSets;
}

- (void)setDataSets:(NSArray *)aDataSets
{
    if (dataSets != aDataSets) {
        [self unwatchDataSets];
        dataSets = aDataSets;
        self.selectedPoints = nil;
        //self.annotations = [NSMutableSet set];
        [self stopMoving];
        [self watchDataSets];
        [self refresh];

        //Todo: correct this
        self.earliestDate = [NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24 * 365 * 25];
        self.latestDate = [[NSDate alloc] init];
    }
}

- (void)watchDataSets
{
    for (SSDataSet *set in dataSets) {
        [set addObserver:self forKeyPath:@"lastUpdated" options:NSKeyValueObservingOptionNew context:modifiedContext];
    }
}

- (void)unwatchDataSets
{
    for (SSDataSet *set in dataSets) {
        [set removeObserver:self forKeyPath:@"lastUpdated"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == modifiedContext) {
        [self refresh];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (BOOL)usePercentScale
{
    return usePercentScale;
}

- (void)setUsePercentScale:(BOOL)flag
{
    usePercentScale = flag;
    [self refresh];
}

- (BOOL)useLogarithmicScale
{
    return useLogarithmicScale;
}

- (void)setUseLogarithmicScale:(BOOL)flag
{
    useLogarithmicScale = flag;
    [self refresh];
}

- (NSArray *)selectedPoints
{
    if (allowSelection)
        return selectedPoints;
    else {
        return nil;
    }
}

- (void)setSelectedPoints:(NSArray *)theSelectedPoints
{
    if (selectedPoints != theSelectedPoints) {
        if (!allowSelection)
            theSelectedPoints = nil;
        selectedPoints = theSelectedPoints;
        [self updateSelectedLabel];
    }
}

- (void)setEndDate:(NSDate *)endDate
{
    if (_endDate != endDate) {
        if ([endDate isAfterDate:latestDate]) {
            return;
        }
        _endDate = endDate;
    }
}

- (void)setStartDate:(NSDate *)startDate
{
    if (_startDate != startDate) {
        if ([startDate isBeforeDate:earliestDate]) {
            return;
        }
        _startDate = startDate;
    }
}

- (double)adjustValue:(double)value inSet:(SSDataSet *)set
{
    if (usePercentScale) {
        return [set percentageChangeForValue:value];
    }
    else {
        return value;
    }
}

#pragma mark init

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        reusableAnnotationViews = [[NSMutableDictionary alloc] init];
        activeAnnotationViews = [[NSMutableDictionary alloc] init];
        //annotations = [[NSMutableSet alloc] init];

        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin];
        self.allowSelection = YES;
        self.contentMode = UIViewContentModeRedraw;
        self.multipleTouchEnabled = YES;
        self.opaque = YES;
        useLogarithmicScale = NO;
        usePercentScale = NO;
        self.style = [[SSGraphStyle alloc] init];

        axisProvider = [[SSAxisProvider alloc] initWithGraphStyle:self.style];

        valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 40)];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.backgroundColor = [UIColor clearColor];
        valueLabel.font = [UIFont boldSystemFontOfSize:18];
        valueLabel.lineBreakMode = NSLineBreakByWordWrapping;
        valueLabel.numberOfLines = 0;
        valueLabel.textColor = style.selectedLineColor;
        valueLabel.hidden = YES;
        [self addSubview:valueLabel];
        [self addGestureRecognizers];
    }
    return self;
}

- (void)clearAnnotationCache
{
    reusableAnnotationViews = [[NSMutableDictionary alloc] init];
}

#pragma mark Gesture Recognizers

- (void)addGestureRecognizers
{
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:pinchGesture];
    [self addGestureRecognizer:tapGesture];
    [self addGestureRecognizer:panGesture];
}

- (IBAction)handlePinch:(UIGestureRecognizer *)sender
{
    CGFloat factor = [(UIPinchGestureRecognizer *) sender scale];

    if ([sender state] == UIGestureRecognizerStateBegan) {
        //self.selectedPoints = nil;
        previousEndDate = [self.endDate copy];
        previousStartDate = [self.startDate copy];
        [self startMoving];
    }
    else if ([sender state] == UIGestureRecognizerStateEnded) {
        [self stopMoving];
    }

    CGPoint centerLocation = [(UIPinchGestureRecognizer *) sender locationInView:self];
    double centerLocationPercent = centerLocation.x / self.bounds.size.width;
    NSTimeInterval totalInterval = [previousEndDate timeIntervalSinceDate:previousStartDate];
    NSTimeInterval centerLocationInterval = totalInterval * centerLocationPercent;
    NSTimeInterval newInterval = totalInterval * 1 / factor;
    if (newInterval < 60 * 60 * 24 * 6)//maxZoomLevel
        return;
    NSDate *centerTime = [previousStartDate dateByAddingTimeInterval:centerLocationInterval];
    self.endDate = [centerTime dateByAddingTimeInterval:newInterval / 2];
    self.startDate = [centerTime dateByAddingTimeInterval:-1 * newInterval / 2];

    [self refresh];
}

- (IBAction)handleTap:(UITapGestureRecognizer *)sender
{

    CGPoint location = [sender locationInView:self];
    NSDate *date = [self dateForX:location.x];
    NSArray *points = [self pointsForDate:date];

    self.selectedPoints = points;
    [self refresh];
}

- (void)shiftGraphByTimeInterval:(NSTimeInterval)interval
{
    NSDate *newStartDate = [previousStartDate dateByAddingTimeInterval:interval];
    NSDate *newEndDate = [previousEndDate dateByAddingTimeInterval:interval];
    if (interval > 0 && [latestDate isBeforeDate:newEndDate]) {
        //should not shift
        return;
    }
    else if (interval < 0 && [earliestDate isAfterDate:newStartDate]) {
        return;
    }
    else {
        self.endDate = newEndDate;
        self.startDate = newStartDate;
    }
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)sender
{
    CGPoint translate = [sender translationInView:self];

    if ([sender state] == UIGestureRecognizerStateBegan) {
        //self.selectedPoints = nil;
        previousEndDate = [_endDate copy];
        previousStartDate = [self.startDate copy];
        [self startMoving];
    }
    else if ([sender state] == UIGestureRecognizerStateEnded) {
        [self stopMoving];
    }
    else if ([sender state] != UIGestureRecognizerStateEnded) {
        double proportion = -1 * translate.x / self.bounds.size.width;
        NSTimeInterval totalInterval = [previousEndDate timeIntervalSinceDate:previousStartDate];
        NSTimeInterval proportionalInterval = proportion * totalInterval;
        [self shiftGraphByTimeInterval:proportionalInterval];
    }

    [self refresh];
}

- (void)startMoving
{
    isMoving = YES;
    //[self setAnnotationsHidden:YES];
}

- (void)stopMoving
{
    isMoving = NO;
    [self updateAnnotations];
    for (SSDataSet *set in dataSets) {
        [set requestFromDataSourceFrom:self.startDate to:self.endDate];
    }
    //[self setAnnotationsHidden:NO];
}

- (void)calculateDrawnMaxAndMin
{
    //Figure out which of the data sets have the highest highs and lowest lows:
    double highestMaxValue = 0;
    double lowestMinValue = 9999999;
    for (SSDataSet *set in dataSets) {
        if ([self adjustValue:set.maxValue inSet:set] > highestMaxValue) {
            highestMaxValue = [self adjustValue:set.maxValue inSet:set];
        }
        if ([self adjustValue:set.minValue inSet:set] < lowestMinValue) {
            lowestMinValue = [self adjustValue:set.minValue inSet:set];
        }
    }

    double calculatedMinValue = 0;
    double calculatedMaxValue = 0;
    if (useLogarithmicScale) {
        calculatedMinValue = log10(lowestMinValue);
        calculatedMaxValue = log10(highestMaxValue);
        double range = calculatedMaxValue - calculatedMinValue;
        _maxDrawnValue = powf(10, calculatedMaxValue + range * .10);
        _minDrawnValue = powf(10, calculatedMinValue - range * .10);
    }
    else {
        calculatedMinValue = lowestMinValue;
        calculatedMaxValue = highestMaxValue;
        double range = calculatedMaxValue - calculatedMinValue;
        _maxDrawnValue = calculatedMaxValue + range * .10;
        _minDrawnValue = calculatedMinValue - range * .10;
    }

    if (!usePercentScale && _minDrawnValue < 0)
        _minDrawnValue = 0;
}

#pragma mark -
#pragma mark Annotations
- (void)updateAnnotations
{
    if (self.annotationDataSource) {
        NSSet *newAnnotations = [self.annotationDataSource annotationsfromDate:self.startDate toDate:self.endDate];
        NSSet *annotations = [NSSet setWithArray:[activeAnnotationViews allKeys]];
        NSMutableSet *outOfSightAnnotations = [NSMutableSet setWithSet:annotations];
        [outOfSightAnnotations minusSet:newAnnotations];

        for (SSAnnotation *outOfSightAnnotation in outOfSightAnnotations) {
            [self recycleViewForAnnotation:outOfSightAnnotation];
        }

        //update all locations (note, does it make sense to spin through all here? Perhaps better to spin through all here, and add views as we go?
        for (SSAnnotationView *annotationView in [activeAnnotationViews allValues]) {
            annotationView.center = CGPointMake([self xForDate:annotationView.annotation.date], 30);
        }

        NSMutableSet *addedAnnotations = [NSMutableSet setWithSet:newAnnotations];
        [addedAnnotations minusSet:annotations];

        for (SSAnnotation *newAnnotation in addedAnnotations) {
            SSAnnotationView *view = [self.annotationDataSource viewForAnnotation:newAnnotation];
            [activeAnnotationViews setObject:view forKey:newAnnotation];
            view.center = CGPointMake([self xForDate:view.annotation.date], 30);
            [self addSubview:view];
        }
    }
}

- (void)recycleViewForAnnotation:(SSAnnotation *)annotation
{

    SSAnnotationView *viewToRecycle = [activeAnnotationViews objectForKey:annotation];
    if (!viewToRecycle)
        return;

    NSMutableArray *recycleBin = [reusableAnnotationViews objectForKey:viewToRecycle.reuseIdentifier];
    if (!recycleBin) {
        [reusableAnnotationViews setObject:[NSMutableArray array] forKey:viewToRecycle.reuseIdentifier];
    }
    [recycleBin addObject:viewToRecycle];
    [activeAnnotationViews removeObjectForKey:annotation];
    [viewToRecycle removeFromSuperview];
}

- (SSAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier
{
    SSAnnotationView *view = nil;
    NSMutableArray *recycleBin = [reusableAnnotationViews objectForKey:identifier];
    if (recycleBin && [recycleBin count] > 0) {
        view = [recycleBin objectAtIndex:0];
        [recycleBin removeObjectAtIndex:0];
    }
    return view;
}

- (void)setAnnotationsHidden:(BOOL)hidden
{
    for (SSAnnotationView *view in [activeAnnotationViews allValues]) {
        [view setHidden:hidden];
    }
}

- (void)moveAnnotations
{
    for (SSAnnotationView *view in [activeAnnotationViews allValues]) {
        view.center = CGPointMake([self xForDate:view.annotation.date], 30);
    }
}

//-(void)drawAnnotations
//{
//	CGContextRef c = UIGraphicsGetCurrentContext();
//	for (SSAnnotation *annotation in annotations) {
//		
//		if([annotation.date isBeforeDate:self.startDate] || [annotation.date isAfterDate:self._endDate])
//			return;
//		double x = [self xForDate:annotation.date];
//		double y = 0;
//		
//		double rectWidth = 40;
//		double rectHeight = 18;
//		SSAnnotationStyle *annotationStyle = nil;
//		if([self.annotationDataSource respondsToSelector:@selector(styleForAnnotation:)])
//			annotationStyle = [self.annotationDataSource styleForAnnotation:annotation];
//		else
//			annotationStyle = [SSAnnotationStyle defaultStyle];
//		switch (annotationStyle.location) {
//			case SSAnnotationLocationTop:
//				y = 0;
//				break;
//			case SSAnnotationLocationOnLine:
//				//TODO: fix this. Perhaps I can do it with path logic?
//			{
//				NSDate *dateForX = [self dateForX:x];
//				NSArray *pointsForDate = [self pointsForDate:dateForX];
//				SSGraphPoint *nearestPoint = [pointsForDate objectAtIndex:0];
//				//SSGraphPoint *nearestPoint = [(NSArray*)[self pointsForDate:] objectAtIndex:0];
//				y = [self yForValue:nearestPoint.value];
//				break;	
//			}		
//			case SSAnnotationLocationBottom:
//				y = self.bounds.size.height-rectHeight;
//				break;
//			default:
//				break;
//		}
//		CGContextSetAlpha(c, .8);
//		CGContextSetFillColorWithColor(c, [[UIColor yellowColor] fourComponentCGColor]);
//		[[UIColor whiteColor] set];
//		CGRect textRect = CGRectMake(x-rectWidth/2, y, rectWidth, rectHeight);
//		///[annotation.text drawInRect:textRect withFont:[UIFont boldSystemFontOfSize:18]];
//		
//		
//		 //CGContextFillRect(c,);	
//	}
//}


- (void)drawRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextClearRect(c, rect);
    for (SSDataSet *s in self.dataSets) {
        [s.style drawOnGraph:self forSet:s inRect:rect];
    }
    [self drawAxes];
    [self drawSelectedMarker];
    [self moveAnnotations];
}

CGPoint topRect(CGRect rect) {
    return CGPointMake(rect.origin.x, rect.origin.y - rect.size.height);
}

- (void)refresh
{
    [self updateSelectedLabel];
    [super setNeedsDisplay];
}

#define PI 3.14159265358979323846

- (void)drawSelectedMarker
{
    if (selectedPoints == nil || [selectedPoints count] < 1) {
        return;
    }

    double radius = 6;
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSaveGState(c);
    //line
    SSGraphPoint *firstPoint = [selectedPoints objectAtIndex:0];
    double x = [self xForDate:firstPoint.date];

    for (SSGraphPoint *selectedPoint in selectedPoints) {
        x = [self xForDate:selectedPoint.date];
        double y = [self yForValue:[self adjustValue:selectedPoint.value inSet:selectedPoint.parentSet]];


        //circle fill
        CGContextBeginPath(c);
        CGContextAddArc(c, x, y, radius, 0, 2 * PI, 0);
        CGContextClosePath(c);

        CGContextSetFillColorWithColor(c, [style.selectedLineColor fourComponentCGColor]);
        CGContextFillPath(c);

    }
    CGContextSetStrokeColorWithColor(c, [style.selectedLineColor fourComponentCGColor]);
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, x, topRect(self.bounds).y);//top
    CGContextAddLineToPoint(c, x, self.bounds.size.height);//bottom
    CGContextClosePath(c);
    CGContextSetLineWidth(c, 2.0);
    CGContextStrokePath(c);

    CGContextRestoreGState(c);
}

- (void)updateSelectedLabel
{
    if (selectedPoints == nil || [selectedPoints count] <= 0) {
        valueLabel.hidden = YES;
    }
    else {
        SSGraphPoint *firstPoint = [selectedPoints objectAtIndex:0];
        double x = [self xForDate:firstPoint.date];
        if (x < 0 || x > self.bounds.size.width) {
            valueLabel.hidden = YES;
            return;
        }
        NSString *formattedNumber = nil;
        if ([selectedPoints count] > 1) {
            NSMutableArray *multiValueOutputs = [NSMutableArray array];
            for (SSGraphPoint *point in selectedPoints) {

                [multiValueOutputs addObject:[self formattedStringForPoint:point showSetLabel:YES]];
            }
            formattedNumber = [multiValueOutputs componentsJoinedByString:@"  "];
        }
        else {
            formattedNumber = [self formattedStringForPoint:firstPoint showSetLabel:NO];
        }
        valueLabel.hidden = NO;
        //TODO: don't use stringForMonthDay or year, create formatter instead.
        valueLabel.text = [NSString stringWithFormat:@"%@, %d\n%@", [firstPoint.date stringForMonthDay], [firstPoint.date year], formattedNumber];
        //valueLabel.size = [valueLabel.text sizeWithFont:valueLabel.font];
        valueLabel.center = [self validCenterForValueLabelWithX:x];
    }
}

- (CGPoint)validCenterForValueLabelWithX:(double)x
{
    double halfWidth = valueLabel.bounds.size.width / 2;
    if (x - halfWidth < 0)
        return CGPointMake(halfWidth, -30);
    else if (x + halfWidth > self.bounds.size.width)
        return CGPointMake(self.bounds.size.width - halfWidth, -30);
    else {
        return CGPointMake(x, -30);
    }
}

- (NSString *)formattedStringForPoint:(SSGraphPoint *)point showSetLabel:(BOOL)showSetLabel
{
    NSString *stringToAppend = nil;
    NSString *startText = showSetLabel ? [NSString stringWithFormat:@"%@: ", point.parentSet.name] : @"";
    if (usePercentScale) {
        double percentage = [point percentValue];
        NSString *formattedNumber = [[SSPriceFormatter anyDecimal] stringFromNumber:[NSNumber numberWithDouble:percentage]];
        stringToAppend = [NSString stringWithFormat:@"%@%@%%", startText, formattedNumber];
    }
    else {
        NSString *formattedNumber = [[SSPriceFormatter twoDecimalForce] stringFromNumber:[NSNumber numberWithDouble:point.value]];
        stringToAppend = [NSString stringWithFormat:@"%@%@", startText, formattedNumber];
    }
    return stringToAppend;
}

- (double)yForValue:(double)value
{
    if (useLogarithmicScale) {
        double logOfValue = log10(value);
        double distance = log10(_maxDrawnValue) - log10(_minDrawnValue);
        double multiplier = self.bounds.size.height / distance;
        //double output = ((value*-1)* ratio)+(minValue*ratio)+self.bounds.size.height;
        double output = self.bounds.size.height - multiplier * (logOfValue - log10(_minDrawnValue));
        return output;
    }
    else {
        double range = _maxDrawnValue - _minDrawnValue;
        double ratio = self.bounds.size.height / range;
        double output = ((value * -1) * ratio) + (_minDrawnValue * ratio) + self.bounds.size.height;
        return output;
    }
}

- (double)xForDate:(NSDate *)date
{
    NSTimeInterval totalInterval = [self.endDate timeIntervalSinceDate:self.startDate];
    NSTimeInterval elapsedInterval = [date timeIntervalSinceDate:self.startDate];
    return elapsedInterval / totalInterval * self.bounds.size.width + self.bounds.origin.x;
}

- (NSDate *)dateForX:(double)x
{
    //we assume that the x values are spread out uniformly, even if the dates aren't.
    NSTimeInterval totalInterval = [_endDate timeIntervalSinceDate:self.startDate];
    double proportion = x / self.bounds.size.width;
    NSTimeInterval proportionalInterval = totalInterval * proportion;
    return [self.startDate dateByAddingTimeInterval:proportionalInterval];
}

- (NSArray *)pointsForDate:(NSDate *)date
{
    NSMutableArray *newPoints = [[NSMutableArray alloc] init];
    for (SSDataSet *set in dataSets) {
        SSGraphPoint *point = [set pointForDate:date];
        if (point)
            [newPoints addObject:point];
    }
    return newPoints;
}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//	
//	NSSet *allTouches = [event allTouches];
//	
//	switch ([allTouches count]) {
//		case 1: { //Single touch
//			
//			//Get the first touch.
//			UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
//			
//			switch ([touch tapCount])
//			{
//				case 1: //Single Tap.
//				{
//					//Start a timer for 2 seconds.
//					timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self 
//														   selector:@selector(timerFinished) userInfo:nil repeats:NO];
//					
//					[timer retain];
//				} break;
//				case 2: {//Double tap. 
//					
//					//Track the initial distance between two fingers.
//					UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
//					UITouch *touch2 = [[allTouches allObjects] objectAtIndex:1];
//					
//					initialDistance = [self distanceBetweenTwoPoints:[touch1 locationInView:self] 
//															 toPoint:[touch2 locationInView:self]];
//				} break;
//			}
//		} break;
//		case 2: { //Double Touch
//			
//		} break;
//		default:
//			break;
//	}
//	
//}

//-(void)timerFinished
//{
//	
//}

- (CGFloat)distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{

    float x = toPoint.x - fromPoint.x;
    float y = toPoint.y - fromPoint.y;

    return sqrt(x * x + y * y);
}

//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//	
//	if([timer isValid])
//		[timer invalidate];
//	
//	NSSet *allTouches = [event allTouches];
//	
//	switch ([allTouches count])
//	{
//		case 1: {
//			
//		} break;
//		case 2: {
//			//The image is being zoomed in or out.
//			
//			UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
//			UITouch *touch2 = [[allTouches allObjects] objectAtIndex:1];
//			
//			//Calculate the distance between the two fingers.
//			CGFloat finalDistance = [self distanceBetweenTwoPoints:[touch1 locationInView:self]
//														   toPoint:[touch2 locationInView:self]];
//			
//			//Check if zoom in or zoom out.
//			if(initialDistance > finalDistance) {
//				NSLog(@"Zoom Out");
//			} 
//			else {
//				NSLog(@"Zoom In");
//			}
//			
//		} break;
//	}
//	
//}

- (void)drawAxes
{
    //TODO: FIx these
    [self drawHorizontalAxis];
    [self drawVerticalAxis];
}

- (void)drawVerticalAxis
{
    NSArray *axisPoints = [axisProvider verticalAxisPointsFromValue:_minDrawnValue toValue:_maxDrawnValue];
    CGContextRef c = UIGraphicsGetCurrentContext();
    //determine range of date values
    CGContextSaveGState(c);
    for (SSVerticalAxisPoint *axisPoint in axisPoints) {

        CGContextBeginPath(c);
        double y = [self yForValue:axisPoint.value];
        CGContextMoveToPoint(c, 0, y);

        CGContextAddLineToPoint(c, self.bounds.size.width, y);

        CGContextSetAlpha(c, 1.0);
        
        [[UIColor whiteColor] set];
        CGContextClosePath(c);
        CGContextSetAlpha(c, .3);
        CGContextSetLineWidth(c, axisPoint.weight * 1.5);
        CGContextStrokePath(c);
        
        NSString *textToDraw = usePercentScale ? [axisPoint.text stringByAppendingString:@"\%"] : axisPoint.text;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentRight;
        NSDictionary *attributes = @{ NSFontAttributeName : [UIFont boldSystemFontOfSize:12],
                                      NSParagraphStyleAttributeName : paragraphStyle,
                                      NSForegroundColorAttributeName : [UIColor whiteColor]};
        [textToDraw drawInRect:CGRectMake(self.bounds.size.width - 40, y - 1, 40 - 2, 14) withAttributes:attributes];
    }

    CGContextRestoreGState(c);
}

- (void)drawHorizontalAxis
{
    NSArray *axisPoints = [axisProvider horizontalAxisPointsFromDate:self.startDate toDate:self.endDate];
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSaveGState(c);
    //determine range of date values
    for (SSHorizontalAxisPoint *axisPoint in axisPoints) {

        CGContextBeginPath(c);
        double x = [self xForDate:axisPoint.date];
        CGContextMoveToPoint(c, x, 0);
        CGContextAddLineToPoint(c, x, self.bounds.size.height);

        [[UIColor whiteColor] set];

        CGContextSetAlpha(c, 1.0);

        CGContextClosePath(c);
        CGContextSetAlpha(c, .3 * axisPoint.weight);
        CGContextSetLineWidth(c, 1.5);
        CGContextStrokePath(c);
        
        NSDictionary *attributes = @{ NSFontAttributeName : [UIFont boldSystemFontOfSize:12],
                                      NSForegroundColorAttributeName : [UIColor whiteColor]};
        [axisPoint.text drawAtPoint:CGPointMake(x + 2, self.bounds.size.height - 13) withAttributes:attributes];
        
    }

    CGContextRestoreGState(c);
}

- (void)dealloc
{
    reusableAnnotationViews = nil;
    activeAnnotationViews = nil;
    style = nil;
    dataSets = nil;
    axisProvider = nil;
    dataSets = nil;
}
@end
