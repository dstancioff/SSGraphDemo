//
//  SSAnnotation.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/2/10.
//  Copyright 2010 Spritely Software.
//

#import "SSAnnotation.h"

@implementation SSAnnotation
@synthesize date = date;
@synthesize userData = userData;

- (id)init
{
    self = [super init];
    if (self != nil) {
        identifier = [super hash];
    }
    return self;
}

- (id)initWithIdentifier:(NSUInteger)anIdentifier
{
    self = [super init];
    if (self != nil) {
        identifier = anIdentifier;
    }
    return self;
}

- (NSUInteger)hash
{
    return identifier;
}

- (BOOL)isEqual:(id)object
{
    return [object hash] == [self hash];
}

- (id)copyWithZone:(NSZone *)zone
{
    SSAnnotation *copy = [[SSAnnotation alloc] initWithIdentifier:identifier];
    copy.date = [self.date copyWithZone:zone];
    copy.userData = [self.userData copyWithZone:zone];
    return copy;
}

- (void)dealloc
{
    date = nil;
    userData = nil;
}
@end
