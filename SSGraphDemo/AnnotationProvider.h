//
//  AnnotationProvider.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/2/10.
//  Copyright 2010 Spritely Software.
//

#import <Foundation/Foundation.h>
#import "SSAnnotationDataSource.h"
#import "SSGraphView.h"

@interface AnnotationProvider : NSObject<SSAnnotationDataSource> {
	SSGraphView *graph;
	NSMutableArray *annotations;
}
@property(nonatomic)SSGraphView *graph;

@end
