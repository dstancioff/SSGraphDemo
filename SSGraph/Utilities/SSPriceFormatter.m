//
//  SSNumberFormatter.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/1/10.
//  Copyright 2010 Spritely Software.
//

#import "SSPriceFormatter.h"

@implementation SSPriceFormatter
static SSPriceFormatter *twoDecimal = nil;
static SSPriceFormatter *anyDecimal = nil;

+ (SSPriceFormatter *)twoDecimalForce
{
    if (twoDecimal == nil) {
        twoDecimal = [[super allocWithZone:NULL] init];
        [twoDecimal setPositiveFormat:@"#0.00"];
        [twoDecimal setNegativeFormat:@"(#0.00)"];
    }
    return twoDecimal;
}

+ (SSPriceFormatter *)anyDecimal
{
    if (anyDecimal == nil) {
        anyDecimal = [[super allocWithZone:NULL] init];
        [anyDecimal setPositiveFormat:@"#0.##"];
        [anyDecimal setNegativeFormat:@"(#0.##)"];
    }
    return anyDecimal;
}
@end
