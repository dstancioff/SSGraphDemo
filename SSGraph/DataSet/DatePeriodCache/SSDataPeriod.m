//
//  DataResolution.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/5/10.
//  Copyright 2010 Spritely Software.
//

#import "SSDataPeriod.h"

@implementation SSDataPeriod
@synthesize points = points;
@synthesize startDate, endDate, resolution, isFault;

- (id)init
{
    self = [super init];
    if (self != nil) {
        points = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    startDate = nil;
    endDate = nil;
    points = nil;
}
@end
