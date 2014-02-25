//
//  SSGraphicHelpers.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/3/10.
//  Copyright 2010 Spritely Software.
//

#import <Foundation/Foundation.h>

void drawLinearGradient(CGContextRef c, CGPoint point1, CGColorRef color1, CGPoint point2, CGColorRef color2);
void coloredPatternPainting(CGContextRef myContext,
        CGPathRef path);
void drawPattern(void *info, CGContextRef myContext);
