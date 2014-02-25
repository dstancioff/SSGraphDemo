//
//  GraphPoint.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 2/25/10.
//  Copyright 2010 Spritely Software.
//

#import "SSGraphPoint.h"
#import "SSDataSet.h"

@implementation SSGraphPoint
@synthesize date;
@synthesize value;
@synthesize parentSet;

- (void)dealloc
{
    date = nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %f", [date formatDate], value];
}

- (double)percentValue
{
    return [self.parentSet percentageChangeForValue:self.value];
}
@end
