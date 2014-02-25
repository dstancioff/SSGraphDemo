//
//  DataResolution.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/5/10.
//  Copyright 2010 Spritely Software.
//

#import <Foundation/Foundation.h>
#import "SSDataPeriodDefinition.h"

@interface SSDataPeriod : NSObject
{
    NSMutableArray *points;
    NSDate *startDate;
    NSDate *endDate;
    int resolution;
    BOOL isFault;
}
@property(nonatomic, readonly) NSMutableArray *points;
@property(nonatomic) NSDate *startDate;
@property(nonatomic) NSDate *endDate;
@property(nonatomic, assign) int resolution;
@property(nonatomic, assign) BOOL isFault;
@end
