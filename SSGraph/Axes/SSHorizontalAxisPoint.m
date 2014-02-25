//
//  HorizontalAxisPoint.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 2/27/10.
//  Copyright 2010 Spritely Software.
//

#import "SSHorizontalAxisPoint.h"

@implementation SSHorizontalAxisPoint
@synthesize date;
@synthesize text;
@synthesize weight;

- (id)initWithDate:(NSDate *)aDate text:(NSString *)aText
{
    if (self = [super init]) {
        [self setDate:aDate];
        [self setText:aText];
        weight = 1;
    }
    return self;
}

- (void)dealloc
{

    date = nil;
    text = nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@ - %i", date, text, weight];
}
@end
