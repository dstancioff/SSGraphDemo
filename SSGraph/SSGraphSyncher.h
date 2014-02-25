//
//  SSGraphSyncher.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/1/10.
//  Copyright 2010 Spritely Software.
//

#import <Foundation/Foundation.h>
#import "SSGraphView.h"

@interface SSGraphSyncher : NSObject
{
    NSMutableArray *graphViews;
    BOOL isProgramaticallyAccessing;
}
- (void)addGraphView:(SSGraphView *)graphView;
@end
