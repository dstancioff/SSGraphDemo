//
//  ChartDataFetch.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 2/25/10.
//  Copyright 2010 Spritely Software.
//

#import <Foundation/Foundation.h>
#import "SSGraphPoint.h"
#import "SSGraphView.h"
#import "SSStyle.h"

@interface SSTimeBasedDataSet : SSDataSet
{
    NSArray *hours;
    NSArray *days;
    NSArray *weeks;
    NSArray *months;
}
- (SSGraphPoint *)earliestPoint;
- (SSGraphPoint *)latestPoint;
- (SSGraphPoint *)earliestPointInSubset;
- (SSGraphPoint *)latestPointInSubset;
- (NSArray *)fetchDataBeginningOn:(NSDate *)startDate endingOn:(NSDate *)endDate;
- (double)percentageChangeForValue:(double)value;
- (void)feedMe:(NSArray *)data;
@end
