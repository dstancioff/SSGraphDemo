//
//  CGColorAdditions.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 2/28/10.
//  Copyright 2010 Spritely Software.
//

#import "UIColorAdditions.h"


@implementation UIColor (Additions)

// Ensure a 4-component CGColor (not greyscale)
-(CGColorRef)fourComponentCGColor
{
	CGColorRef originalCGColor = [self CGColor];
	size_t numComp = CGColorGetNumberOfComponents(originalCGColor);
	if (numComp == 4) {
		return originalCGColor;
	}
	else if(numComp == 2) //greyscale
	{
		const CGFloat *oldComponents = CGColorGetComponents(originalCGColor);
		CGFloat components[4] = {oldComponents[0],oldComponents[0],oldComponents[0],oldComponents[1]};
		return CGColorCreate(CGColorSpaceCreateDeviceRGB(), components);
        
	}
    return nil;
}

@end
