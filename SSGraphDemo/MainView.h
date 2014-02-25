//
//  MainView.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 2/27/10.
//  Copyright 2010 Spritely Software.
//

#import <UIKit/UIKit.h>
#import "SSGraphView.h"
#import "SSDataSet.h"
#import "SSGraphSyncher.h"
#import "SSTimeBasedDataSet.h"

@interface MainView : UIViewController <SSDataSetDataSource>
{
    SSGraphView *graphView;
    SSGraphView *volumeView;
    SSGraphSyncher *syncher;

    IBOutlet UIView *graphViewContainer;
    IBOutlet UIView *volumeViewContainer;
    IBOutlet UIViewController *optionUIViewController;
    SSDataSet *msft;
    SSDataSet *msftVolume;
    SSDataSet *aapl;
    SSDataSet *aaplVolume;
    NSOperationQueue *operationQueue;
}
- (IBAction)changeSegmentedControl:(UISegmentedControl *)sender;
- (IBAction)reset;
- (IBAction)toggleLogarithm;
- (IBAction)togglePercent;
- (void)changeGraphMode:(int)option;
@end
