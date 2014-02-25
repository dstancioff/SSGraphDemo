//
//  SSAxisProvider.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/1/10.
//  Copyright 2010 Spritely Software.
//

#import "SSAxisProvider.h"
#import "SSHorizontalAxisPoint.h"
#import "SSVerticalAxisPoint.h"
#import "SSPriceFormatter.h"

@implementation SSAxisProvider
NSTimeInterval oneDay = 24 * 60 * 60;
NSTimeInterval oneMonth = 30 * 24 * 60 * 60; //inaccurate, but that's ok for this
NSTimeInterval oneYear = 365 * 24 * 60 * 60;

- (id)initWithGraphStyle:(SSGraphStyle *)aStyle
{
    self = [super init];
    if (self != nil) {
        style = aStyle;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        style = [[SSGraphStyle alloc] init];
    }
    return self;
}

- (NSArray *)horizontalAxisPointsFromDate:(NSDate *)startDate toDate:(NSDate *)endDate
{

    NSTimeInterval totalInterval = [endDate timeIntervalSinceDate:startDate];
    double numYears = totalInterval / oneYear;
    double numMonths = totalInterval / oneMonth;

    if (numYears > 3) {
        return [self horizontalYearsFromDate:startDate toDate:endDate];
    }
    else if (numMonths > 2) {
        return [self horizontalMonthsFromDate:startDate toDate:endDate];
    }
    else if (numMonths > .7) {
        return [self horizontalWeeksFromDate:startDate toDate:endDate];
    }
    else {
        return [self horizontalDaysFromDate:startDate toDate:endDate];
    }
}

- (NSArray *)horizontalYearsFromDate:(NSDate *)startDate toDate:(NSDate *)endDate
{
    NSTimeInterval totalInterval = [endDate timeIntervalSinceDate:startDate];
    double numUnits = totalInterval / oneYear;
    NSMutableArray *newPoints = [[NSMutableArray alloc] init];
    int ratio = numUnits / 5 + 1;
    NSCalendar *gregorian = [[NSCalendar alloc]
            initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents =
            [gregorian components:(NSYearCalendarUnit) fromDate:startDate];

    //NSLog(@"Ratio:%d",ratio); //"Good" ratios are 1, 2, 5, 10, 20
    if (ratio == 2 || ratio == 1) {}
    else if (ratio < 5) {ratio = 2;}
    else if (ratio < 10) {ratio = 5;}
    else if (ratio < 20) {ratio = 10;}
    else if (ratio > 20) {ratio = 20;}

    for (int i = 0; i < numUnits; i++) {
        int unit = dateComponents.year + 1;
        dateComponents.year = unit;

        if (unit % ratio == 0) {
            NSDate *justUnit = [gregorian dateFromComponents:dateComponents];
            NSString *text = [NSString stringWithFormat:@"%d", unit];

            [newPoints addObject:[[SSHorizontalAxisPoint alloc] initWithDate:justUnit text:text]];
        }
    }
    return newPoints;
}

- (NSArray *)horizontalMonthsFromDate:(NSDate *)startDate toDate:(NSDate *)endDate
{
    NSTimeInterval totalInterval = [endDate timeIntervalSinceDate:startDate];
    double numUnits = totalInterval / oneMonth;
    NSMutableArray *newPoints = [[NSMutableArray alloc] init];
    int ratio = numUnits / 5 + 1;
    NSCalendar *gregorian = [[NSCalendar alloc]
            initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents =
            [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:startDate];

    //NSLog(@"Ratio:%d",ratio); //"Good" ratios are 1, 3, 6, 12
    if (ratio < 3) {ratio = 1;}
    else if (ratio < 6) {ratio = 3;}
    else if (ratio < 12) {ratio = 6;}
    else {ratio = 12;}

    //TODO: get this out of here
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];

    for (int i = 0; i < numUnits; i++) {
        int unit = dateComponents.month + 1;
        dateComponents.month = unit;

        if (ratio == 1 || unit % ratio == 1) {

            int lineWeight = 1;
            if (unit % 12 == 1) {
                [dateFormat setDateFormat:@"yyyy"];
                lineWeight = 2;
            }
            else {
                [dateFormat setDateFormat:@"MMM"];
            }

            NSDate *justUnit = [gregorian dateFromComponents:dateComponents];
            NSString *text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:justUnit]];
            SSHorizontalAxisPoint *newPoint = [[SSHorizontalAxisPoint alloc] initWithDate:justUnit text:text];
            newPoint.weight = lineWeight;
            [newPoints addObject:newPoint];
        }
    }
    return newPoints;
}

- (NSArray *)horizontalWeeksFromDate:(NSDate *)startDate toDate:(NSDate *)endDate
{
    NSTimeInterval totalInterval = [endDate timeIntervalSinceDate:startDate];
    double numUnits = totalInterval / (oneDay * 7);
    NSMutableArray *newPoints = [[NSMutableArray alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc]
            initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents =
            [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit) fromDate:startDate];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd"];

    for (int i = 0; i < numUnits; i++) {
        int unit = dateComponents.day + 7;
        [dateComponents setDay:unit];
        NSDate *justUnit = [gregorian dateFromComponents:dateComponents];
        NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:justUnit];
        NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
        /* Substract [gregorian firstWeekday] to handle first day of the week being something else than Sunday */
        [componentsToSubtract setDay:-((([weekdayComponents weekday] - [gregorian firstWeekday])
                + 7) % 7)];
        NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:justUnit options:0];



        //We need to set unit to the start of the week

        NSString *text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:beginningOfWeek]];

        [newPoints addObject:[[SSHorizontalAxisPoint alloc] initWithDate:beginningOfWeek text:text]];
    }
    return newPoints;
}

- (NSArray *)horizontalDaysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate
{
    NSTimeInterval totalInterval = [endDate timeIntervalSinceDate:startDate];
    double numUnits = totalInterval / oneDay;
    NSMutableArray *newPoints = [[NSMutableArray alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc]
            initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents =
            [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:startDate];
    NSDateFormatter *dateFormatMinor = [[NSDateFormatter alloc] init];
    [dateFormatMinor setDateFormat:@"dd"];

    NSDateFormatter *dateFormatMajor = [[NSDateFormatter alloc] init];
    [dateFormatMajor setDateFormat:@"MMM dd"];

    NSDateFormatter *dateFormatLong = [[NSDateFormatter alloc] init];
    [dateFormatLong setDateFormat:@"EEE, MMM dd"];

    for (int i = 0; i < numUnits; i++) {
        int unit = dateComponents.day + 1;
        dateComponents.day = unit;

        NSDate *justUnit = [gregorian dateFromComponents:dateComponents];
        NSDateComponents *resolvedDateComponents = [gregorian components:NSDayCalendarUnit fromDate:justUnit];
        NSString *text = nil;
        if (numUnits < 7) {

            text = [NSString stringWithFormat:@"%@", [dateFormatLong stringFromDate:justUnit]];
        }
        else if (i == 0 || [resolvedDateComponents day] == 1) {
            text = [NSString stringWithFormat:@"%@", [dateFormatMajor stringFromDate:justUnit]];
        }
        else {
            text = [NSString stringWithFormat:@"%@", [dateFormatMinor stringFromDate:justUnit]];
        }
        [newPoints addObject:[[SSHorizontalAxisPoint alloc] initWithDate:justUnit text:text]];
    }
    return newPoints;
}

- (NSArray *)verticalAxisPointsFromValue:(double)lowValue toValue:(double)highValue
{
    //Note, units are multiplied by 100 to help with floating point issues
    double totalInterval = highValue - lowValue;
    int adjustmentNumber = 1;
    if (totalInterval < 15) {
        adjustmentNumber = 100;
    }
    double numUnits = totalInterval * adjustmentNumber;
    NSMutableArray *newPoints = [[NSMutableArray alloc] init];
    //1, 2, 5, 10, 20, 50, 100
    int stepSize = 1;
    long loopCounter = 1;
    while (numUnits > stepSize * style.maxVerticalLines) {
        if (loopCounter % 3 == 2)
            stepSize *= 2.5;
        else {
            stepSize *= 2;
        }

        loopCounter++;
    }

    int adjustedLowValue = (lowValue * adjustmentNumber);
    int remainder = adjustedLowValue % stepSize;
    int firstStep = (lowValue * adjustmentNumber) - remainder;

    for (int i = firstStep; i < numUnits + firstStep; i = i + stepSize) {
        NSString *postfix = @"";
        int postRatio = 1;
        if ((stepSize / adjustmentNumber) > 1000000) {
            postfix = @"M";
            postRatio = 1000000;
        }
        else if ((stepSize / adjustmentNumber) > 1000) {
            postfix = @"K";
            postRatio = 1000;
        }
        NSString *text = [[SSPriceFormatter anyDecimal] stringFromNumber:[NSNumber numberWithDouble:(double) i / adjustmentNumber / postRatio]];
        text = [NSString stringWithFormat:@"%@%@", text, postfix];
        SSVerticalAxisPoint *newPoint = [[SSVerticalAxisPoint alloc] initWithValue:(double) i / adjustmentNumber text:text];
        if (newPoint.value == 0) {
            newPoint.weight = 3;
        }
        [newPoints addObject:newPoint];
    }
    return newPoints;
}
@end
