//
//  SSDatePeriodCache.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/6/10.
//  Copyright 2010 Spritely Software.
//

#import <Foundation/Foundation.h>

#import "SSDataPeriod.h"

@interface SSDatePeriodCache : NSObject
{
    NSMutableDictionary *cache;
    int resolutionLevel;
    NSMutableArray *allPoints;
}

@property(nonatomic) NSMutableDictionary *cache;
@property(nonatomic, assign) int resolutionLevel;
@property(nonatomic) NSMutableArray *allPoints;
//-(NSArray*) pointsForPeriodsFrom:(NSDate*)startDate to:(NSDate*)_endDate;
- (void)addToCache:(NSArray *)data from:(NSDate *)startDate to:(NSDate *)endDate;
- (NSDate *)startDateForPeriodNumber:(int)periodNumber;
- (NSDate *)endDateForPeriodNumber:(int)periodNumber;
- (NSDate *)dateForPeriodNumber:(int)periodNumber;
- (int)periodNumberForDate:(NSDate *)date;
- (NSArray *)periodsFrom:(NSDate *)startDate to:(NSDate *)endDate;
- (NSArray *)pointsForPeriod:(SSDataPeriod *)period from:(NSDate *)startDate to:(NSDate *)endDate;
- (double)interpolatedValueForDate:(NSDate *)date;
@end
