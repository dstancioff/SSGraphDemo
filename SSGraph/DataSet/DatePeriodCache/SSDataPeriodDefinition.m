//
//  SSDataResolutionLevel.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/5/10.
//  Copyright 2010 Spritely Software.
//

#import "SSDataPeriodDefinition.h"

@implementation SSDataPeriodDefinition
@synthesize level = level;
@synthesize interval = interval;
@synthesize name = name;
@synthesize minPeriods = minPeriods;

- (void)dealloc
{
    name = nil;
}
@end
