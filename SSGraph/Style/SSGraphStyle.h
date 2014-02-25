//
//  SSGraphStyle.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/1/10.
//  Copyright 2010 Spritely Software.
//

#import <Foundation/Foundation.h>
#import "SSStyleBase.h"

@interface SSGraphStyle : SSStyleBase
{
	int maxVerticalLines;
	UIColor *selectedLineColor;
}
@property(nonatomic, assign) int maxVerticalLines;
@property(nonatomic) UIColor *selectedLineColor;

@end
