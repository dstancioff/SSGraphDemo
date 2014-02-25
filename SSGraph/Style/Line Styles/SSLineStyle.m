//
//  SSLineStyle.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/1/10.
//  Copyright 2010 Spritely Software.
//

#import "SSLineStyle.h"
#import "SSGraphView.h"

@implementation SSLineStyle

@synthesize lineColor;
@synthesize lineThickness;

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		self.lineColor = [UIColor whiteColor];
		self.lineThickness = 4.0;
	}
	return self;
}

- (SSGraphType)graphType
{
	return SSGraphTypeLine;
}

- (void)drawOnGraph:(SSGraphView *)graph forSet:(SSDataSet *)set inRect:(CGRect)rect
{
	//for now
	NSArray *points = [set fetchDataBeginningOn:graph.startDate endingOn:graph.endDate];

	//TODO: make this called less. It only needs to be called once per graph, not once per set. It does need to happen after the subsetting takes place though...
	[graph calculateDrawnMaxAndMin];

	CGPathRef linePath = [self pathForPoints:points onGraph:graph];
	[self strokePath:linePath];
}

- (void)strokePath:(CGPathRef)path
{

	CGContextRef c = UIGraphicsGetCurrentContext();
	//Stroke path
	CGContextAddPath(c, path);
	CGContextSetLineWidth(c, self.lineThickness);
	CGContextSetLineJoin(c, kCGLineJoinRound);
	CGContextSetStrokeColorWithColor(c, [self.lineColor fourComponentCGColor]);
	CGContextStrokePath(c);

}

- (CGPathRef)pathForPoints:(NSArray *)points onGraph:(SSGraphView *)graph
{
	//CREATE THE LINE PATH
	CGMutablePathRef justLinePath = CGPathCreateMutable();
	{

		if ([points count] <= 0)
		{
			return justLinePath;
		}
		for (int i = 0; i < [points count]; i++)
		{
			SSGraphPoint *point = [points objectAtIndex:i];
			double x = [graph xForDate:point.date];

			//TODO: REMOVE
//			CGPoint prevX = CGPathGetCurrentPoint(justLinePath);
//			if (prevX.x > 0 && x<prevX.x) {
//				NSLog(@"Error! Moving backwards on path!");
//			}

			double adjustedPointValue = [graph adjustValue:point.value inSet:point.parentSet];
			double y = [graph yForValue:adjustedPointValue];

			if (i == 0)
			{
				CGPathMoveToPoint(justLinePath, NULL, x, y);
			}
			else
			{
				CGPathAddLineToPoint(justLinePath, NULL, x, y);
			}
		}
	}
	return justLinePath;
}

- (void)dealloc
{

	lineColor = nil;
}

@end
