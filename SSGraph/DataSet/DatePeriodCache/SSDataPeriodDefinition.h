//
//  SSDataResolutionLevel.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/5/10.
//  Copyright 2010 Spritely Software.
//

#import <Foundation/Foundation.h>

@interface SSDataPeriodDefinition : NSObject
{
    int level;
    double interval;
    NSString *name;
    int minPeriods; //the minimum number of periods shown before the resolution increases
}
@property(nonatomic, assign) int level;
@property(nonatomic, assign) double interval;
@property(nonatomic) NSString *name;
@property(nonatomic, assign) int minPeriods;
@end
