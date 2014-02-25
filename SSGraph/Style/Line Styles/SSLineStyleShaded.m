//
//  SSLineStyleShaded.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/1/10.
//  Copyright 2010 Spritely Software.
//

#import "SSLineStyleShaded.h"
#import "SSGraphView.h"
#import "SSGraphicHelpers.h"

@implementation SSLineStyleShaded
@synthesize positiveGradientTopColor;
@synthesize positiveGradientBottomColor;
@synthesize negativeGradientTopColor;
@synthesize negativeGradientBottomColor;
@synthesize shadePositiveAndNegativeSeparately;

- (id)initWithColor:(UIColor *)color
{
	self = [super init];
	if (self != nil)
	{
		self.lineColor = [UIColor whiteColor];
		self.positiveGradientTopColor = color;
		self.positiveGradientBottomColor = [UIColor whiteColor];
		self.shadePositiveAndNegativeSeparately = NO;
		self.negativeGradientTopColor = color;
		self.negativeGradientBottomColor = [UIColor whiteColor];
	}
	return self;
}

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		self.lineColor = [UIColor whiteColor];
		self.positiveGradientTopColor = [UIColor greenColor];
		self.positiveGradientBottomColor = [UIColor colorWithName:@"darkgreen"];
		self.shadePositiveAndNegativeSeparately = NO;
		self.negativeGradientTopColor = [UIColor redColor];
		self.negativeGradientBottomColor = [UIColor colorWithName:@"darkred"];
	}
	return self;
}

- (void)fillAndTextureBelowPath:(CGPathRef)path onGraph:(SSGraphView *)graph
{
	CGContextRef c = UIGraphicsGetCurrentContext();
	// CREATE THE FILL PATH
	CGContextSaveGState(c);
	CGMutablePathRef fillPath = CGPathCreateMutableCopy(path);
	CGContextRestoreGState(c);
	CGRect pathBounds = CGPathGetBoundingBox(path);

	//Add the base of the graph
	CGPathAddLineToPoint(fillPath, NULL, pathBounds.size.width + pathBounds.origin.x, graph.bounds.size.height);//bottom right
	CGPathAddLineToPoint(fillPath, NULL, pathBounds.origin.x, graph.bounds.size.height); //bottom left


	CGContextBeginPath(c);
	CGContextAddPath(c, fillPath);
	CGContextClosePath(c);

	CGContextSaveGState(c);
	CGContextClip(c);
	CGContextSetAlpha(c, .6);

	if (self.shadePositiveAndNegativeSeparately)
	{
		double zeroPoint = [graph yForValue:0];

		drawLinearGradient(c, CGPointMake(0, graph.bounds.origin.y), [self.positiveGradientTopColor fourComponentCGColor], CGPointMake(0, (CGFloat) zeroPoint), [self.positiveGradientBottomColor fourComponentCGColor]);
		drawLinearGradient(c, CGPointMake(0, (CGFloat) zeroPoint), [self.negativeGradientTopColor fourComponentCGColor], CGPointMake(0, graph.bounds.size.height), [self.negativeGradientBottomColor fourComponentCGColor]);
	}
	else
	{
		drawLinearGradient(c, CGPointMake(0, graph.bounds.origin.y), [self.positiveGradientTopColor fourComponentCGColor], CGPointMake(0, graph.bounds.size.height), [self.positiveGradientBottomColor fourComponentCGColor]);
	}

	CGContextRestoreGState(c);

	coloredPatternPainting(c, fillPath);
	CFRelease(fillPath);
}

- (void)drawOnGraph:(SSGraphView *)graph forSet:(SSDataSet *)set inRect:(CGRect)rect
{
	//for now
	NSArray *points = [set fetchDataBeginningOn:graph.startDate endingOn:graph.endDate];
    if([points count] == 0)
    {
        return;
    }
	//TODO: make this called less. It only needs to be called once per graph, not once per set. It does need to happen after the subsetting takes place though...
	[graph calculateDrawnMaxAndMin];

	CGPathRef linePath = [self pathForPoints:points onGraph:graph];
	if (!linePath)
	{
		return;
	}
	if (!graph.isMoving || shadeWhileMoving)
	{
		[self fillAndTextureBelowPath:linePath onGraph:graph];
	}
	[self strokePath:linePath];
}

- (void)dealloc
{
	positiveGradientTopColor = nil;
	positiveGradientBottomColor = nil;
}

@end
