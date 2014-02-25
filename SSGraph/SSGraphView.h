//
//  GraphView.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 2/26/10.
//  Copyright 2010 Spritely Software.
//

#import <UIKit/UIKit.h>
#import "SSGraphPoint.h"
#import "SSLineStyle.h"
#import "SSDataSet.h"
#import "SSAxisProvider.h"
#import "SSAnnotationDataSource.h"
#import "SSUtilities.h"
#import "SSAnnotationView.h"

@protocol SSGraphViewDelegate

- (NSArray *)fetchDataSetsBeginningOn:(NSDate *)startDate endingOn:(NSDate *)endDate;
@end

@interface SSGraphView : UIView
{

    double _maxDrawnValue;
    double _minDrawnValue;
    NSDate *latestDate;
    NSDate *earliestDate;
    NSDate *previousStartDate;
    NSDate *previousEndDate;
    NSArray *selectedPoints;
    SSAxisProvider *axisProvider;
    CGFloat initialDistance;
    UILabel *valueLabel;
    BOOL useLogarithmicScale;
    BOOL usePercentScale;
    NSArray *dataSets;
    SSGraphStyle *style;
    NSMutableDictionary *reusableAnnotationViews; //Should be a dictionary with the key being a reuseIdentifier and the value being an NSArray which represents the queue
    NSMutableDictionary *activeAnnotationViews; //For this, the key is an annotation,

    BOOL allowSelection;
    BOOL isMoving;
}

- (double)yForValue:(double)value;
- (double)xForDate:(NSDate *)date;
- (double)adjustValue:(double)value inSet:(SSDataSet *)set;
- (CGFloat)distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;
CGPoint topRect(CGRect graphRect);
- (void)stopMoving;
- (void)startMoving;
- (void)refresh;
- (void)updateSelectedLabel;
- (void)addGestureRecognizers;
- (NSDate *)dateForX:(double)x;
- (NSArray *)pointsForDate:(NSDate *)date;
- (void)updateAnnotations;
- (void)drawAxes;
- (void)drawHorizontalAxis;
- (void)drawVerticalAxis;
- (void)drawSelectedMarker;
- (void)clearAnnotationCache;
- (void)recycleViewForAnnotation:(SSAnnotation *)annotation;
- (NSString *)formattedStringForPoint:(SSGraphPoint *)point showSetLabel:(BOOL)showSetLabel;
- (void)calculateDrawnMaxAndMin;
- (SSAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier;

@property(nonatomic, strong) NSDate *startDate;
@property(nonatomic, strong) NSDate *endDate;
@property(nonatomic, strong) NSDate *latestDate;
@property(nonatomic, strong) NSDate *earliestDate;
@property(nonatomic, strong) NSArray *selectedPoints;
@property(nonatomic, strong) NSArray *dataSets;
@property(nonatomic, assign) BOOL useLogarithmicScale;
@property(nonatomic, assign) BOOL usePercentScale;
@property(nonatomic, assign) BOOL allowSelection;
@property(readonly, assign) BOOL isMoving;
@property(nonatomic, strong) SSGraphStyle *style;
@property(nonatomic, strong) id <SSAnnotationDataSource> annotationDataSource;
@property(nonatomic) NSMutableDictionary *reusableAnnotationViews;
@property(nonatomic) NSMutableDictionary *activeAnnotationViews;
@end
