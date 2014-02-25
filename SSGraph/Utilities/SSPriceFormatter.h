//
//  SSNumberFormatter.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/1/10.
//  Copyright 2010 Spritely Software.
//

#import <Foundation/Foundation.h>

@interface SSPriceFormatter : NSNumberFormatter
{
}
+ (SSPriceFormatter *)twoDecimalForce;
+ (SSPriceFormatter *)anyDecimal;
@end
