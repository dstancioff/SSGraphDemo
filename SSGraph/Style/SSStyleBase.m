//
//  SSStyleBase.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/2/10.
//  Copyright 2010 Spritely Software.
//

#import "SSStyleBase.h"

@implementation SSStyleBase
static SSStyleBase *defaultStyle = nil;

+ (SSStyleBase *)defaultStyle
{
	if (defaultStyle == nil)
	{
		defaultStyle = [[super allocWithZone:NULL] init];
	}
	return defaultStyle;
}
@end
