//
//  VerticalAxisPoint.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 2/27/10.
//  Copyright 2010 Spritely Software.
//

#import "SSVerticalAxisPoint.h"

@implementation SSVerticalAxisPoint
@synthesize value;
@synthesize text;
@synthesize weight;

- (id)initWithValue:(double)aValue text:(NSString *)aText
{
    if (self = [super init]) {
        [self setValue:aValue];
        [self setText:aText];
        weight = 1;
    }
    return self;
}

- (void)dealloc
{
    text = nil;
}
@end
