//
//  SSLineStyle.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/1/10.
//  Copyright 2010 Spritely Software.
//

#import <Foundation/Foundation.h>
#import "SSDataSetStyle.h"

@interface SSLineStyle : SSDataSetStyle
{
	UIColor *lineColor;
	double lineThickness;

}
- (CGPathRef)pathForPoints:(NSArray *)points onGraph:(SSGraphView *)graph;

- (void)strokePath:(CGPathRef)path;

@property(nonatomic) UIColor *lineColor;
@property(nonatomic, assign) double lineThickness;

@end
