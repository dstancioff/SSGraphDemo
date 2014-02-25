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

@protocol SSDataSetDataSource

- (void)requestDataForSet:(SSDataSet *)set from:(NSDate *)startDate to:(NSDate *)endDate withResolution:(int)resolution;

@end

@interface SSDataSet : NSObject
{

	NSArray *subSet;

	double maxValue;
	double minValue;

	NSString *name;

	SSDataSetStyle *style;

	BOOL usePercentScale;

	NSTimeInterval timeInterval;

	NSArray *periodDefinitions;
	NSArray *periodCache;

	NSDate *lastUpdated;

	id <SSDataSetDataSource> __weak dataSource;

}
- (SSGraphPoint *)earliestPointInSubset;

- (SSGraphPoint *)latestPointInSubset;

- (NSArray *)fetchDataBeginningOn:(NSDate *)startDate endingOn:(NSDate *)endDate withMaxPoints:(int)maxItems;

- (double)percentageChangeForValue:(double)value;

- (void)feedMe:(NSArray *)data forResolution:(int)resolutionLevel from:(NSDate *)startDate to:(NSDate *)endDate;

- (NSArray *)fetchDataBeginningOn:(NSDate *)startDate endingOn:(NSDate *)endDate;

- (void)requestFromDataSourceFrom:(NSDate *)startDate to:(NSDate *)endDate;

- (SSGraphPoint *)pointForDate:(NSDate *)date;

@property(nonatomic) double maxValue;
@property(nonatomic) double minValue;
@property(nonatomic) NSString *name;
@property(nonatomic, strong) SSDataSetStyle *style;
@property(nonatomic) NSArray *subSet;
@property(nonatomic, assign) NSTimeInterval timeInterval;
@property(nonatomic) NSArray *periodDefinitions;
@property(nonatomic) NSArray *periodCache;
@property(nonatomic) NSDate *lastUpdated;
@property(nonatomic, weak) id dataSource;

@end
