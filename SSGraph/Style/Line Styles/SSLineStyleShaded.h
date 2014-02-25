//
//  SSLineStyleShaded.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/1/10.
//  Copyright 2010 Spritely Software.
//

#import <Foundation/Foundation.h>
#import "SSLineStyle.h"

@interface SSLineStyleShaded : SSLineStyle
{
	UIColor *positiveGradientTopColor;
	UIColor *positiveGradientBottomColor;
	UIColor *negativeGradientTopColor;
	UIColor *negativeGradientBottomColor;
	BOOL shadePositiveAndNegativeSeparately;
	BOOL shadeWhileMoving;
}
- (id)initWithColor:(UIColor *)color;

@property(nonatomic) UIColor *positiveGradientTopColor;
@property(nonatomic) UIColor *positiveGradientBottomColor;
@property(nonatomic) UIColor *negativeGradientTopColor;
@property(nonatomic) UIColor *negativeGradientBottomColor;
@property(nonatomic, assign) BOOL shadePositiveAndNegativeSeparately;
@end
