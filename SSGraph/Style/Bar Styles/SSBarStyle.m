//
//  SSBarStyle.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/1/10.
//  Copyright 2010 Spritely Software.
//

#import "SSBarStyle.h"
#import "SSGraphView.h"

@implementation SSBarStyle
@synthesize barColor = barColor;

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		barColor = [UIColor whiteColor];
	}
	return self;
}

- (void)drawOnGraph:(SSGraphView *)graph forSet:(SSDataSet *)set inRect:(CGRect)rect
{
	//for now
	int setNumber = [graph.dataSets indexOfObject:set];
	int totalSets = [graph.dataSets count];

	NSArray *points = [set fetchDataBeginningOn:graph.startDate endingOn:graph.endDate];
    //TODO: Calculate a real time interval
	NSTimeInterval timeInterval = 60*60*24;

	//TODO: make this called less. It only needs to be called once per graph, not once per set. It does need to happen after the subsetting takes place though
	[graph calculateDrawnMaxAndMin];

	CGContextRef c = UIGraphicsGetCurrentContext();
	{
		if ([points count] <= 0)
		{
			return;
		}
		for (int i = 0; i < [points count]; i++)
		{
			SSGraphPoint *point = [points objectAtIndex:i];
			double leftx = [graph xForDate:point.date];
			double rightx = [graph xForDate:[point.date dateByAddingTimeInterval:timeInterval]];
			double y = [graph yForValue:[graph adjustValue:point.value inSet:set]];
			//CGContextBeginPath(c);
			//CGContextAddRect(c, CGRectMake(leftx, 0, rightx-leftx, y));
			//CGContextClosePath(c);

			//CGContextMoveToPoint(c, x, self.bounds.size.height);//base
			//CGContextAddLineToPoint(c, x, y);
			//CGContextSetStrokeColorWithColor(c, [style.barColor fourComponentCGColor]);
			//CGContextSetLineWidth(c, 1.0);
			CGContextSetAlpha(c, .8);
			CGContextSetFillColorWithColor(c, [self.barColor fourComponentCGColor]);
			double barWidth = (rightx - leftx) / (double) totalSets;
			CGContextFillRect(c, CGRectMake(leftx + (barWidth * setNumber), y, barWidth, graph.bounds.size.height - y));
		}
	}
}

- (SSGraphType)graphType
{
	return SSGraphTypeBar;
}

- (void)dealloc
{
	barColor = nil;
}

@end
