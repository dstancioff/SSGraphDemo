//
//  SSGraphicHelpers.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/3/10.
//  Copyright 2010 Spritely Software.
//

#import "SSGraphicHelpers.h"

void drawLinearGradient(CGContextRef c, CGPoint point1, CGColorRef color1, CGPoint point2, CGColorRef color2)
//Gradient
{
    CGGradientRef myGradient;
    CGColorSpaceRef myColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = {0.0, 1.0};
    const CGFloat *color1Components = CGColorGetComponents(color1);
    const CGFloat *color2Components = CGColorGetComponents(color2);
    CGFloat components[8] = {
            color1Components[0],
            color1Components[1],
            color1Components[2],
            color1Components[3],
            color2Components[0],
            color2Components[1],
            color2Components[2],
            color2Components[3],};

    myColorspace = CGColorSpaceCreateDeviceRGB();
    myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, num_locations);

    CGContextDrawLinearGradient(c, myGradient, point1, point2, 0);
}

#define H_PATTERN_SIZE 1
#define V_PATTERN_SIZE 18

void drawPattern(void *info, CGContextRef myContext) {
    float subunit = V_PATTERN_SIZE/ 2;
    CGRect myRect1 = {{0, 0}, {1, subunit}};
    //myRect2 = {{subunit, subunit}, {subunit, 1}};

    CGContextSetRGBFillColor(myContext, 0, 0, 0, 0.1);
    CGContextFillRect(myContext, myRect1);
    // CGContextSetRGBFillColor (myContext, 1, 1, 1, 0.5);
    // CGContextFillRect (myContext, myRect2);
}

//Change this to fillpath?
void coloredPatternPainting(CGContextRef myContext,
        CGPathRef path) {
    CGPatternRef pattern;
    CGColorSpaceRef patternSpace;
    float alpha = 1;
    static const CGPatternCallbacks callbacks = {0,
            &drawPattern,
            NULL};

    CGContextSaveGState(myContext);
    patternSpace = CGColorSpaceCreatePattern(NULL);
    CGContextSetFillColorSpace(myContext, patternSpace);
    CGColorSpaceRelease(patternSpace);

    pattern = CGPatternCreate(NULL,
            CGRectMake(0, 0, H_PATTERN_SIZE, V_PATTERN_SIZE),
            CGAffineTransformMake (1, 0, 0, 1, 0, 0),
            H_PATTERN_SIZE,
            V_PATTERN_SIZE,
            kCGPatternTilingConstantSpacing,
            true,
            &callbacks);

    CGContextSetFillPattern(myContext, pattern, &alpha);
    CGPatternRelease(pattern);
    CGContextAddPath(myContext, path);
    CGContextFillPath(myContext);
    CGContextRestoreGState(myContext);
}