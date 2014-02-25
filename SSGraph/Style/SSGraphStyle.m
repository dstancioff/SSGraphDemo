//
//  SSGraphStyle.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/1/10.
//  Copyright 2010 Spritely Software.
//

#import "SSGraphStyle.h"

@implementation SSGraphStyle
@synthesize maxVerticalLines;
@synthesize selectedLineColor;

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		maxVerticalLines = 10;
		self.selectedLineColor = [UIColor orangeColor];
	}
	return self;
}

@end
