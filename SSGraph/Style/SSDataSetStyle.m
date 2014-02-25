//
//  SSDataSetStyle.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/1/10.
//  Copyright 2010 Spritely Software.
//

#import "SSDataSetStyle.h"

@implementation SSDataSetStyle

- (void)drawOnGraph:(SSGraphView *)graph forSet:(SSDataSet *)set inRect:(CGRect)rect
{
	//this is intended to be overridden
}

- (SSGraphType)graphType
{
	return SSGraphTypeNone;
}
@end
