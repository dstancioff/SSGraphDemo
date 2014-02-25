//
//  GraphPoint.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 2/25/10.
//  Copyright 2010 Spritely Software.
//

#import <Foundation/Foundation.h>

@class SSDataSet;

@interface SSGraphPoint : NSObject
{
    NSDate *date;
    double value;
    SSDataSet *__weak parentSet;
}
@property(nonatomic) NSDate *date;
@property(nonatomic, assign) double value;
@property(nonatomic, weak) SSDataSet *parentSet;
- (double)percentValue;
@end
