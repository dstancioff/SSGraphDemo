//
//  SSGraphSyncher.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/1/10.
//  Copyright 2010 Spritely Software.
//

#import "SSGraphSyncher.h"

void *SelectedPointsContext = &SelectedPointsContext;

@implementation SSGraphSyncher
- (id)init
{
    self = [super init];
    if (self != nil) {
        graphViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addGraphView:(SSGraphView *)graphView
{
    [graphViews addObject:graphView];
    [graphView addObserver:self forKeyPath:@"startDate" options:NSKeyValueObservingOptionNew context:SelectedPointsContext];
    [graphView addObserver:self forKeyPath:@"endDate" options:NSKeyValueObservingOptionNew context:SelectedPointsContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == SelectedPointsContext) {
        if (isProgramaticallyAccessing)
            return;
        for (SSGraphView *graphView in graphViews) {
            if (object != graphView) {
                isProgramaticallyAccessing = YES;
                [graphView setValue:[object valueForKey:keyPath] forKey:keyPath];
                [graphView refresh];
                isProgramaticallyAccessing = NO;
            }
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)removeGraphView:(SSGraphView *)graphView
{
    [graphView removeObserver:self forKeyPath:@"selectedPoints"];
    [graphViews removeObject:graphView];
}
@end
