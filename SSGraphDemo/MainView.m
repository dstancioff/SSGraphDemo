//
//  MainView.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 2/27/10.
//  Copyright 2010 Spritely Software.
//

#import "MainView.h"
#import "AnnotationProvider.h"
#import "YahooHistoricalCSV.h"
#import "CSVFetchOperation.h"

@interface MainView ()
@property(weak, nonatomic) IBOutlet UIView *loadingIndicator;
@end

@implementation MainView

- (void)viewDidLoad
{
    [super viewDidLoad];

    operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addObserver:self forKeyPath:@"operationCount" options:NSKeyValueObservingOptionNew context:nil];
    [operationQueue setMaxConcurrentOperationCount:4];

    syncher = [[SSGraphSyncher alloc] init];
    double topmargin = 25;
    double margin = 10;
    graphView = [[SSGraphView alloc] initWithFrame:CGRectMake(margin, topmargin, graphViewContainer.bounds.size.width - 2 * margin, graphViewContainer.bounds.size.height - topmargin - margin)];

    [syncher addGraphView:graphView];
    volumeView = [[SSGraphView alloc] initWithFrame:CGRectMake(margin, topmargin, volumeViewContainer.bounds.size.width - 2 * margin, volumeViewContainer.bounds.size.height - topmargin - margin)];
    volumeView.allowSelection = NO;

    [syncher addGraphView:volumeView];
    graphView.annotationDataSource = [[AnnotationProvider alloc] init];
    graphView.clipsToBounds = NO;
    [graphViewContainer addSubview:graphView];
    [volumeViewContainer addSubview:volumeView];

    [self reset];
    UIBarButtonItem *optionsButton = [[UIBarButtonItem alloc] initWithTitle:@"Options" style:UIBarButtonItemStylePlain target:self action:@selector(toggleOptionsPanel:)];

    self.navigationItem.rightBarButtonItem = optionsButton;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == operationQueue) {
        [graphView refresh];
        self.loadingIndicator.hidden = ([operationQueue operationCount] == 0);
    }
}

- (void)toggleOptionsPanel:(id)sender
{
    UIPopoverController *aPopover = [[UIPopoverController alloc] initWithContentViewController:optionUIViewController];
    //optioUIViewController.contentSizeForViewInPopover = [optioUIViewController.view size];
    [aPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return YES;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [graphView clearAnnotationCache];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)toggleLogarithm
{
    graphView.useLogarithmicScale = !graphView.useLogarithmicScale;
    NSLog(@"Log scale: %@", graphView.useLogarithmicScale ? @"ON" : @"OFF");
}

- (IBAction)togglePercent
{
    graphView.usePercentScale = !graphView.usePercentScale;
    NSLog(@"Percent scale: %@", graphView.usePercentScale ? @"ON" : @"OFF");
}

- (IBAction)changeSegmentedControl:(UISegmentedControl *)sender
{
    [self changeGraphMode:sender.selectedSegmentIndex];
}

- (void)changeGraphMode:(int)option
{
    if (option == 0) {
        SSLineStyleShaded *aaplStyle = [[SSLineStyleShaded alloc] initWithColor:[UIColor colorWithName:@"lightblue"]];
        aaplStyle.positiveGradientTopColor = [UIColor colorWithName:@"lightgrey"];
        aaplStyle.positiveGradientBottomColor = [UIColor colorWithName:@"slategray"];
        aaplStyle.lineColor = [UIColor colorWithName:@"silver"];
        aaplStyle.shadePositiveAndNegativeSeparately = YES;
        aapl.style = aaplStyle;
        graphView.backgroundColor = [UIColor blackColor];
        graphView.dataSets = [NSArray arrayWithObjects:aapl, nil];
        volumeView.dataSets = [NSArray arrayWithObject:aaplVolume];
    }
    if (option == 1) {
        msft.style = [[SSLineStyleShaded alloc] initWithColor:[UIColor blueColor]];
        graphView.backgroundColor = [UIColor blackColor];
        graphView.dataSets = [NSArray arrayWithObjects:msft, nil];
        volumeView.dataSets = [NSArray arrayWithObject:msftVolume];
    }
    if (option == 2) {
        aapl.style = [[SSLineStyleBasic alloc] initWithColor:[UIColor greenColor]];
        msft.style = [[SSLineStyleBasic alloc] initWithColor:[UIColor blueColor]];
        graphView.backgroundColor = [UIColor yellowColor];
        graphView.dataSets = [NSArray arrayWithObjects:aapl, msft, nil];
        volumeView.dataSets = [NSArray arrayWithObject:aaplVolume];
    }
}

- (IBAction)reset
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //2010-02-25
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    //NSDate *startDate = [dateFormat dateFromString:@"1984-02-25"];
    NSDate *startViewDate = [dateFormat dateFromString:@"2004-02-25"];
    //NSDate *_endDate = [dateFormat dateFromString:@"2010-02-05"];
    NSDate *endDate = [NSDate date];

    graphView.startDate = startViewDate;
    graphView.endDate = endDate;

    volumeView.startDate = startViewDate;
    volumeView.endDate = endDate;

    volumeView.style.maxVerticalLines = 5;

    aapl = [[SSDataSet alloc] init];
    aapl.dataSource = self;
    aaplVolume = [[SSDataSet alloc] init];
    SSBarStyle *aaplBarStyle = [[SSBarStyle alloc] init];
    aaplBarStyle.barColor = [UIColor lightGrayColor];
    aaplVolume.style = aaplBarStyle;
    aaplVolume.dataSource = self;
    aaplVolume.name = @"AAPL-Volume";
    aapl.name = @"AAPL";
    //[self readInCSVForSymbol:aapl.name from:graphView.startDate to:graphView._endDate frequency:YahooMonthly];


    msft = [[SSDataSet alloc] init];
    msftVolume = [[SSDataSet alloc] init];
    SSBarStyle *msftBarStyle = [[SSBarStyle alloc] init];
    msftBarStyle.barColor = [UIColor lightGrayColor];
    msftVolume.style = msftBarStyle;
    msft.name = @"MSFT";
    msft.dataSource = self;
    //[self readInCSVForSymbol:msft.name from:graphView.startDate to:graphView._endDate frequency:YahooMonthly];

    [self changeGraphMode:0];
}

- (void)requestDataForSet:(SSDataSet *)set from:(NSDate *)startDate to:(NSDate *)endDate withResolution:(int)resolution
{
    if ([set.name isEqualToString:@"AAPL-Volume"]) {
        return;
    }
    NSString *frequency;
    if (resolution == 0)
        frequency = YahooMonthly;
    else if (resolution == 1) {
        frequency = YahooWeekly;
    }
    else {
        frequency = YahooDaily;
    }

    CSVFetchOperation *operation = [[CSVFetchOperation alloc] init];
    NSString *url = [YahooHistoricalCSV urlWithSymbol:set.name from:startDate to:endDate frequency:frequency];
    operation.url = url;
    operation.set = set;
    operation.volumeSet = aaplVolume;
    operation.startDate = startDate;
    operation.endDate = endDate;
    operation.resolution = resolution;
    [operationQueue addOperation:operation];
}
@end
