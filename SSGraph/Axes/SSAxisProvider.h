//
//  SSAxisProvider.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/1/10.
//  Copyright 2010 Spritely Software.
//

#import <Foundation/Foundation.h>
#import "SSGraphStyle.h"

@interface SSAxisProvider : NSObject
{
    SSGraphStyle *style;
}
- (id)initWithGraphStyle:(SSGraphStyle *)aStyle;
- (NSArray *)horizontalYearsFromDate:(NSDate *)startDate toDate:(NSDate *)endDate;
- (NSArray *)horizontalWeeksFromDate:(NSDate *)startDate toDate:(NSDate *)endDate;
- (NSArray *)horizontalDaysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate;
- (NSArray *)horizontalMonthsFromDate:(NSDate *)startDate toDate:(NSDate *)endDate;
- (NSArray *)horizontalAxisPointsFromDate:(NSDate *)startDate toDate:(NSDate *)endDate;
- (NSArray *)verticalAxisPointsFromValue:(double)lowValue toValue:(double)highValue;
@end
