//
//  SSDatePeriodCache.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/6/10.
//  Copyright 2010 Spritely Software.
//

#import "SSDatePeriodCache.h"
#import "SSGraphPoint.h"
#import "NSDate+Utilities.h"

@implementation SSDatePeriodCache
@synthesize cache = cache;
@synthesize resolutionLevel = resolutionLevel;
@synthesize allPoints = allPoints;

- (id)init
{
    self = [super init];
    if (self != nil) {
        cache = [[NSMutableDictionary alloc] init];
        allPoints = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)periodsFrom:(NSDate *)startDate to:(NSDate *)endDate
{
    int startPeriodNum = [self periodNumberForDate:startDate];
    int endPeriodNum = [self periodNumberForDate:endDate];
    NSMutableArray *periods = [NSMutableArray array];
    for (int i = startPeriodNum; i <= endPeriodNum; i++) {
        SSDataPeriod *period = [cache objectForKey:[NSNumber numberWithInt:i]];
        if (period) {
            [periods addObject:period];
        }
        else {
            SSDataPeriod *period = [[SSDataPeriod alloc] init];
            period.startDate = [self startDateForPeriodNumber:i];
            period.endDate = [self endDateForPeriodNumber:i];
            period.resolution = resolutionLevel;
            period.isFault = YES;
            [periods addObject:period];
        }
    }
    return periods;
}

- (NSArray *)filterArray:(NSArray *)data from:(NSDate *)startDate to:(NSDate *)endDate
{
    int startIndex = -1;
    int endIndex = -1;

    //NSArray *data = [self allPoints];

    int fetchAheadPoints = 0;
    int fetchAfterPoints = 0;

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

        int numItems = endIndex - startIndex + 1;
        if (numItems > 0) {
            return [data subarrayWithRange:NSMakeRange(startIndex, numItems)];
        }
        else {
            //NSLog(@"0 or less items!");
        }
    }

    return [NSArray array];
}

- (NSArray *)pointsForPeriod:(SSDataPeriod *)period from:(NSDate *)startDate to:(NSDate *)endDate
{
    //int startPeriodNum = [self periodNumberForDate:startDate];
    //int endPeriodNum = [self periodNumberForDate:_endDate];
    NSMutableArray *pointsToReturn = [NSMutableArray array];
    //for (int i = startPeriodNum; i <= endPeriodNum; i++) {
    //	SSDataPeriod* period = [cache objectForKey:[NSNumber numberWithInt:i]];
    if (period) {
        NSArray *filteredPoints = nil;
        if (period.resolution != self.resolutionLevel)
            filteredPoints = [self filterArray:[self allPoints] from:startDate to:endDate];
        else
            filteredPoints = [self filterArray:period.points from:startDate to:endDate];
        if (filteredPoints && [filteredPoints count] > 0)
            [pointsToReturn addObjectsFromArray:filteredPoints];
        else {
//					SSGraphPoint* startPoint = [[SSGraphPoint alloc] init];
//					startPoint.value = [self interpolatedValueForDate:period.startDate];
//					startPoint.date = period.startDate;
//					[pointsToReturn addObject:startPoint];
//					[startPoint release];
//					SSGraphPoint* endPoint = [[SSGraphPoint alloc] init];
//					endPoint.value =  [self interpolatedValueForDate:period._endDate];
//					endPoint.date = period._endDate;
//					[pointsToReturn addObject:endPoint];
//					[endPoint release];
//					
        }
    }
    //NSLog(@"Requested from %@ to %@, returning:\n%@",startDate, _endDate, pointsToReturn);
    return pointsToReturn;
}

- (void)addToCache:(NSArray *)data from:(NSDate *)startDate to:(NSDate *)endDate
{

    NSMutableDictionary *localPeriods = [NSMutableDictionary dictionary];
    int startPeriod = [self periodNumberForDate:startDate];
    int endPeriod = [self periodNumberForDate:endDate];
    for (int i = startPeriod; i <= endPeriod; i++) {
        SSDataPeriod *dataPeriod = [[SSDataPeriod alloc] init];
        dataPeriod.startDate = [self startDateForPeriodNumber:i];
        dataPeriod.endDate = [self endDateForPeriodNumber:i];
        [localPeriods setObject:dataPeriod forKey:[NSNumber numberWithInt:i]];
    }

    for (SSGraphPoint *point in data) {
        int periodNumber = [self periodNumberForDate:point.date];
        SSDataPeriod *dataPeriod = [localPeriods objectForKey:[NSNumber numberWithInt:periodNumber]];
        if (dataPeriod) {
            [dataPeriod.points addObject:point];
        }
        else {
            NSException *myException = [NSException
                    exceptionWithName:@"PeriodNotAvailable"
                    reason:@"Supplied data was not within supplied range."
                    userInfo:nil];
            @throw myException;
        }
    }
    [allPoints addObjectsFromArray:data];
    //we need to sort resolution points
    //sort the data
    NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    for (SSDataPeriod *period in [localPeriods allValues]) {
        [period.points sortUsingDescriptors:[NSArray arrayWithObject:dateSort]];
    }
    [allPoints sortUsingDescriptors:[NSArray arrayWithObject:dateSort]];

    [cache addEntriesFromDictionary:localPeriods];
}

- (double)interpolatedValueForDate:(NSDate *)date
{
    SSGraphPoint *previousPoint = nil;
    for (SSGraphPoint *point in allPoints) {
        if (previousPoint && [point.date isAfterDate:date]) {

            double previousPointDistance = [date timeIntervalSinceDate:previousPoint.date];
            double thisPointDistance = [point.date timeIntervalSinceDate:date];
            double weight = previousPointDistance / (previousPointDistance + thisPointDistance);
            double endValue = ((point.value - previousPoint.value) * weight) + previousPoint.value;
//				NSLog(@"When interpolating date %@, the previous date was %@, which was %f seconds away and had a value of: %f",date,previousPoint.date,previousPointDistance, previousPoint.value);
//				NSLog(@"The current date is %@, which is %f seconds away. This has a value of: %f This leads to a weight of: %f",point.date, thisPointDistance, point.value, weight);
//				NSLog(@"The final value was: %f", endValue);
            return endValue;
        }
        previousPoint = point;
    }

    //TODO: Remove this and put better exception throws?
    return 0;
    NSException *periodNotFound = [NSException
            exceptionWithName:@"PeriodNotAvailable"
            reason:@"Supplied data was not within supplied range."
            userInfo:nil];
    @throw periodNotFound;
}

- (NSDate *)startDateForPeriodNumber:(int)periodNumber
{
    return [self dateForPeriodNumber:periodNumber];
}

- (NSDate *)endDateForPeriodNumber:(int)periodNumber
{
    NSDate *nextDate = [self dateForPeriodNumber:periodNumber + 1];
    return [NSDate dateWithTimeIntervalSinceReferenceDate:[nextDate timeIntervalSinceReferenceDate] - 1];
}

- (NSDate *)dateForPeriodNumber:(int)periodNumber
{

    NSCalendar *gregorianCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    if (resolutionLevel == 0) {
        components.year = periodNumber * 5;
    }
    else if (resolutionLevel == 1) {
        components.year = periodNumber;
    }
    else if (resolutionLevel == 2) {
        int newPeriodNumber = periodNumber * 3;
        components.year = newPeriodNumber / 12;
        components.month = newPeriodNumber % 12;
    }

    NSDate *newDate = [gregorianCalendar dateFromComponents:components];
    return newDate;
}

- (int)periodNumberForDate:(NSDate *)date
{
    NSCalendar *gregorianCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [gregorianCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:date];
    if (resolutionLevel == 0)
        return [components year] / 5;
    else if (resolutionLevel == 1) {

        return [components year];
    }
    else {
        return ([components month] + [components year] * 12) / 3;
    }
}
@end

