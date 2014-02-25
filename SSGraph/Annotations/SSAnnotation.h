//
//  SSAnnotation.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/2/10.
//  Copyright 2010 Spritely Software.
//

#import <Foundation/Foundation.h>

@interface SSAnnotation : NSObject <NSCopying>
{
	NSDate *date;
	NSUInteger identifier;
	NSDictionary *userData;
}
@property(nonatomic, strong) NSDate *date;
@property(nonatomic, strong) NSDictionary *userData;

@end
