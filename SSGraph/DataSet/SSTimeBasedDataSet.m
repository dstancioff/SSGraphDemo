//
//  ChartDataFetch.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 2/25/10.
//  Copyright 2010 Spritely Software.
//

#import "SSTimeBasedDataSet.h"

@implementation SSTimeBasedDataSet

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.style = [[SSLineStyle alloc] init];
    }
    return self;
}

- (SSGraphPoint *)earliestPoint
{
    if ([days count] > 0)
        return [days objectAtIndex:0];
    else {
        return nil;
    }
}

- (SSGraphPoint *)latestPoint
{
    if ([days count] > 0)
        return [days objectAtIndex:[days count] - 1];
    else {
        return nil;
    }
}

- (SSGraphPoint *)earliestPointInSubset
{
    if ([self.subSet count] > 0)
        return [self.subSet objectAtIndex:0];
    else {
        return nil;
    }
}

- (SSGraphPoint *)latestPointInSubset
{
    if ([self.subSet count] > 0)
        return [self.subSet objectAtIndex:[self.subSet count] - 1];
    else {
        return nil;
    }
}

- (void)calculateMaxAndMin
{
    self.minValue = DBL_MAX;
    self.maxValue = 0;
    for (int i = 0; i < [self.subSet count]; i++) {

        SSGraphPoint *point = [self.subSet objectAtIndex:i];
        if (point.value > self.maxValue) {
            self.maxValue = point.value;
        }
        if (point.value < self.minValue) {
            self.minValue = point.value;
        }
    }
}

- (NSArray *)fetchDataBeginningOn:(NSDate *)startDate endingOn:(NSDate *)endDate
{
    int startIndex = -1;
    int endIndex = -1;
    NSArray *data = nil;
    NSTimeInterval timeRange = [endDate timeIntervalSinceDate:startDate];
    NSTimeInterval oneYear = 365 * 24 * 60 * 60;
    NSTimeInterval oneMonth = 26 * 24 * 60 * 60;
    NSTimeInterval oneDay = 24 * 60 * 60;
    if (timeRange > 5 * oneYear) { //minimum: 60 points
        data = months;
        self.timeInterval = oneMonth;
    }
    else if (timeRange > oneYear) {// min: 52, max: 260
        data = weeks;
        self.timeInterval = oneDay * 7;
    }
    else { //max 365
        data = days;
        self.timeInterval = oneDay;
    }

    int fetchAheadPoints = 1;
    int fetchAfterPoints = 2;

    for (int i = 0; i < [data count]; i++) {
        SSGraphPoint *point = [data objectAtIndex:i];
        if ([point.date isAfterDate:startDate]) {
            startIndex = i - fetchAheadPoints >= 0 ? i - fetchAheadPoints : 0;
            break;
        }
    }
    for (int i = [data count] - 1; i >= 0; i--) {
        SSGraphPoint *point = [data objectAtIndex:i];
        if ([point.date isBeforeDate:endDate]) {
            endIndex = i + fetchAfterPoints <= [data count] - 1 ? i + fetchAfterPoints : [data count] - 1;
            break;
        }
    }
    if (startIndex >= 0 && endIndex >= 0) {

        int numItems = endIndex - startIndex;
        if (numItems > 0) {
            self.subSet = [data subarrayWithRange:NSMakeRange(startIndex, numItems)];
            [self calculateMaxAndMin];
            return self.subSet;
        }
    }
    else {
        NSLog(@"Invalid start and end indexes");
    }

    return nil;
}

- (void)feedMe:(NSArray *)data
{
    //sort the data
    NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortedData = [data sortedArrayUsingDescriptors:[NSArray arrayWithObject:dateSort]];
    double previousWeek = 0;
    double previousMonth = 0;
    NSMutableArray *newDays = [NSMutableArray arrayWithCapacity:[sortedData count]];
    NSMutableArray *newWeeks = [NSMutableArray array];
    NSMutableArray *newMonths = [NSMutableArray array];
    for (SSGraphPoint *point in sortedData) {
        point.parentSet = self;
        NSCalendar *gregorian = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [gregorian components:(NSWeekCalendarUnit | NSMonthCalendarUnit) fromDate:point.date];
        if (previousWeek != [dateComponents week]) {
            previousWeek = [dateComponents week];
            [newWeeks addObject:point];
        }
        if (previousMonth != [dateComponents month]) {
            previousMonth = [dateComponents month];
            [newMonths addObject:point];
        }
        [newDays addObject:point];
    }

    days = newDays;
    weeks = newWeeks;
    months = newMonths;
}

- (double)percentageChangeForValue:(double)value
{
    SSGraphPoint *earliestPoint = [self earliestPointInSubset];
    return (value / earliestPoint.value - 1) * 100;
}
@end
