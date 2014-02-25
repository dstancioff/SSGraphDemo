//
//  ChartDataFetch.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 2/25/10.
//  Copyright 2010 Spritely Software.
//

#import "SSDataSet.h"
#import "SSDataPeriod.h"
#import "SSDatePeriodCache.h"

@implementation SSDataSet
@synthesize maxValue = maxValue;
@synthesize minValue = minValue;
@synthesize name = name;
@synthesize style = style;
@synthesize subSet;
@synthesize timeInterval = timeInterval;
@synthesize periodDefinitions = periodDefinitions;
@synthesize periodCache = periodCache;
@synthesize lastUpdated;
@synthesize dataSource;

- (id)init
{
    self = [super init];
    if (self != nil) {
        subSet = nil;
        style = [[SSLineStyle alloc] init];

        SSDataPeriodDefinition *years = [[SSDataPeriodDefinition alloc] init];
        years.level = 0;
        years.name = @"Years";
        years.interval = 60 * 60 * 24 * 365;
        years.minPeriods = 10;

        SSDataPeriodDefinition *months = [[SSDataPeriodDefinition alloc] init];
        months.level = 1;
        months.name = @"Months";
        months.interval = 60 * 60 * 24 * 30;
        months.minPeriods = 10;

        SSDataPeriodDefinition *days = [[SSDataPeriodDefinition alloc] init];
        days.level = 2;
        days.name = @"Days";
        days.interval = 60 * 60 * 24;
        days.minPeriods = 10;

        periodDefinitions = [[NSArray alloc] initWithObjects:years, months, days, nil];

        NSMutableArray *periodBuild = [NSMutableArray arrayWithCapacity:[periodDefinitions count]];
        for (int i = 0; i < [periodDefinitions count]; i++) {
            SSDatePeriodCache *cache = [[SSDatePeriodCache alloc] init];
            cache.resolutionLevel = i;
            [periodBuild addObject:cache];
        }
        periodCache = [[NSArray alloc] initWithArray:periodBuild];
    }
    return self;
}

- (SSGraphPoint *)earliestPointInSubset
{
    if ([subSet count] > 0)
        return [subSet objectAtIndex:0];
    else {
        return nil;
    }
}

- (SSGraphPoint *)latestPointInSubset
{
    if ([subSet count] > 0)
        return [subSet objectAtIndex:[subSet count] - 1];
    else {
        return nil;
    }
}

- (void)calculateMaxAndMin
{
    minValue = DBL_MAX;
    maxValue = 0;
    for (int i = 0; i < [subSet count]; i++) {

        SSGraphPoint *point = [subSet objectAtIndex:i];
        if (point.value > maxValue) {
            maxValue = point.value;
        }
        if (point.value < minValue) {
            minValue = point.value;
        }
    }
}

- (void)dealloc
{
    periodDefinitions = nil;
    periodCache = nil;
    lastUpdated = nil;
    name = nil;
    subSet = nil;
    style = nil;
}

- (void)requestFromDataSourceFrom:(NSDate *)startDate to:(NSDate *)endDate
{
    int currentResolution = [self resolutionForValueWidth:[endDate timeIntervalSinceDate:startDate]];
    SSDatePeriodCache *cache = [self.periodCache objectAtIndex:currentResolution];
    NSArray *periods = [cache periodsFrom:startDate to:endDate];
    for (SSDataPeriod *period in periods) {
        if (period.isFault)
            [dataSource requestDataForSet:self from:period.startDate to:period.endDate withResolution:period.resolution];
    }
}

- (NSArray *)fetchDataBeginningOn:(NSDate *)startDate endingOn:(NSDate *)endDate withMaxPoints:(int)maxItems
{
    //TODO: honor maxItems?
    return [self fetchDataBeginningOn:startDate endingOn:endDate];
}

- (NSArray *)fetchDataBeginningOn:(NSDate *)startDate endingOn:(NSDate *)endDate
{
    //	NSLog(@"Fetching data for set:%@ from:%@ to %@",self.name,startDate,_endDate);
    int currentResolution = [self resolutionForValueWidth:[endDate timeIntervalSinceDate:startDate]];
    SSDatePeriodCache *cache = [self.periodCache objectAtIndex:currentResolution];
    NSMutableArray *points = [NSMutableArray array];
    int nextResolution = currentResolution - 1;
    SSDatePeriodCache *higherLevelCache = nil;
    if (nextResolution >= 0) {
        higherLevelCache = [self.periodCache objectAtIndex:nextResolution];
    }
    NSArray *periods = [cache periodsFrom:startDate to:endDate];
    for (SSDataPeriod *period in periods) {
        if (!period.isFault) {
            NSArray *periodPoints = [cache pointsForPeriod:period from:period.startDate to:period.endDate];
            [points addObjectsFromArray:periodPoints];
        }
        else if (higherLevelCache) {
            NSArray *periodPoints = [higherLevelCache pointsForPeriod:period from:period.startDate to:period.endDate];
            if ([periodPoints count] > 0)
                [points addObjectsFromArray:periodPoints];
        }
    }

    NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    [points sortUsingDescriptors:[NSArray arrayWithObject:dateSort]];

    NSArray *immutableSubSet = [NSArray arrayWithArray:points];
    subSet = immutableSubSet;
    [self calculateMaxAndMin];
    return immutableSubSet;
}

- (int)resolutionForValueWidth:(double)width
{
    //TODO: determine which resolution we are at, based on range
    int resolution = 0;

    if (3 * 30 * 60 * 60 * 24 > width) {
        resolution = 2;
    }
    else if (6 * 365 * 1 * 60 * 60 * 24 > width) {
        resolution = 1;
    }
    return resolution;
}

- (SSGraphPoint *)pointForDate:(NSDate *)date
{
    SSGraphPoint *previousPoint = nil;
    for (SSGraphPoint *point in self.subSet) {
        if (previousPoint && [point.date isAfterDate:date]) {
            //determine which is closer
            double previousPointDistance = [date timeIntervalSinceDate:previousPoint.date];
            double thisPointDistance = [point.date timeIntervalSinceDate:date];
            return previousPointDistance > thisPointDistance ? point : previousPoint;
        }
        previousPoint = point;
    }
    return nil;
}

- (void)feedMe:(NSArray *)data forResolution:(int)resolutionLevel from:(NSDate *)startDate to:(NSDate *)endDate
{
    SSDatePeriodCache *cache = [self.periodCache objectAtIndex:resolutionLevel];
    [cache addToCache:data from:startDate to:endDate];
    self.lastUpdated = [NSDate date];
    for (SSGraphPoint *point in data) {
        point.parentSet = self;
    }
    
}

- (double)percentageChangeForValue:(double)value
{
    SSGraphPoint *earliestPoint = [self earliestPointInSubset];
    return (value / earliestPoint.value - 1) * 100;
}
@end
