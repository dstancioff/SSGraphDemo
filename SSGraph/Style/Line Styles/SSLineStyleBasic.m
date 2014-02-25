//
//  SSLineStyleBasic.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/1/10.
//  Copyright 2010 Spritely Software.
//

#import "SSLineStyleBasic.h"

@implementation SSLineStyleBasic
- (id)initWithColor:(UIColor *)color
{
	self = [super init];
	if (self != nil)
	{
		self.lineColor = color;
	}
	return self;
}

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		self.lineColor = [UIColor whiteColor];
	}
	return self;
}

@end
