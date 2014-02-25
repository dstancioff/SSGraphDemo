//
//  SSAnnotationView.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/3/10.
//  Copyright 2010 Spritely Software.
//

#import "SSAnnotationView.h"

@implementation SSAnnotationView
@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize annotation = _annotation;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super init];
    if (self != nil) {
        self.reuseIdentifier = reuseIdentifier;
        self.frame = CGRectMake(0, 0, 20, 20);
    }
    return self;
}
@end
