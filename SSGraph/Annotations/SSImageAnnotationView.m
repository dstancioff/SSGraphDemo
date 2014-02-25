//
//  SSImageAnnotationView.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/4/10.
//  Copyright 2010 Spritely Software.
//

#import "SSImageAnnotationView.h"

@implementation SSImageAnnotationView
@synthesize imageView = imageView;
@synthesize label = label;

- (id)initWithReuseIdentifier:(NSString *)identifier
{
	self = [super initWithReuseIdentifier:identifier];
	if (self != nil)
	{
		self.frame = CGRectMake(0, 0, 50, 65);
		label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 15)];
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
		[self addSubview:imageView];
	}
	return self;
}

- (void)dealloc
{
	imageView = nil;
	label = nil;
}

@end
