//
//  SSAnnotationStyle.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/2/10.
//  Copyright 2010 Spritely Software.
//

#import "SSAnnotationStyle.h"

@implementation SSAnnotationStyle
@synthesize location = location;

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		self.location = SSAnnotationLocationTop;
	}
	return self;
}

@end
