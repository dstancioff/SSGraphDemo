//
//  SSAnnotationStyle.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/2/10.
//  Copyright 2010 Spritely Software.
//

#import <Foundation/Foundation.h>
#import "SSStyleBase.h"

typedef enum _SSAnnotationLocation
{
	SSAnnotationLocationTop,
	SSAnnotationLocationOnLine,
	SSAnnotationLocationBottom,
	SSAnnotationLocationCustom
} SSAnnotationLocation;

@interface SSAnnotationStyle : SSStyleBase
{
	SSAnnotationLocation location;
}
@property(nonatomic, assign) SSAnnotationLocation location;

@end
