//
//  SSDataSetStyle.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/1/10.
//  Copyright 2010 Spritely Software.
//

#import <Foundation/Foundation.h>
#import "SSStyleBase.h"

@class SSGraphView;
@class SSDataSet;

typedef enum _GraphType
{
	SSGraphTypeNone,
	SSGraphTypeLine,
	SSGraphTypeBar
} SSGraphType;

@interface SSDataSetStyle : SSStyleBase
{
}
- (SSGraphType)graphType;

- (void)drawOnGraph:(SSGraphView *)graph forSet:(SSDataSet *)set inRect:(CGRect)rect;
@end
