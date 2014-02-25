//
//  NSDate+Utilities.m
//
//  Created by Dimitri Stancioff on 7/20/09.
//  Copyright 2009 Spritely Software.
//

#import "NSDate+Utilities.h"

@implementation NSDate (Utilities)

+ (NSDate *)dateOnlyFromDate:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:date];
    components.hour = 0;
    components.minute = 0;

    NSDate *midnight = [gregorian dateFromComponents:components];
    return midnight;
}

- (BOOL)isAfterDate:(NSDate *)date
{
    BOOL isAfter = [self compare:date] == NSOrderedDescending;
    return isAfter;
}

- (BOOL)isBeforeDate:(NSDate *)date
{
    return [self compare:date] == NSOrderedAscending;
}

- (NSString *)stringForMonthDay
{
    NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];
    NSString *displayString = nil;

    [displayFormatter setDateFormat:@"MMMM d"]; //September 23


    // use display formatter to return formatted date string
    displayString = [displayFormatter stringFromDate:self];
    return displayString;
}

- (BOOL)isSameDayAsDate:(NSDate *)date
{
    NSDate *selfDay = [NSDate dateOnlyFromDate:self];
    NSDate *otherDay = [NSDate dateOnlyFromDate:date];
    return [selfDay compare:otherDay] == 0;
}

- (NSString *)formatDate
{
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEEE, LLLL d, YYYY";
    }
    return [formatter stringFromDate:self];
}
@end
