//
//  SSAnnotationDataSource.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/2/10.
//  Copyright 2010 Spritely Software.
//

#import <UIKit/UIKit.h>
#import "SSAnnotation.h"
#import "SSAnnotationStyle.h"
#import "SSAnnotationView.h"

@protocol SSAnnotationDataSource
//Add set and/or graphView to allow this to be more flexible?
@required
- (NSSet *)annotationsfromDate:(NSDate *)startDate toDate:(NSDate *)endDate;

@optional
- (SSAnnotationStyle *)styleForAnnotation:(SSAnnotation *)annotation;
- (SSAnnotationView *)viewForAnnotation:(SSAnnotation *)annotation;
@end
