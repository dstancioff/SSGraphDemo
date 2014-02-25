//
//  CSVFetchOperation.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/8/10.
//  Copyright 2010 Spritely Software.
//

#import <Foundation/Foundation.h>
#import "SSDataSet.h"

@interface CSVFetchOperation : NSOperation {
	NSString* url;
	SSDataSet* set;
	SSDataSet* volumeSet;
	int resolution;
	NSDate* startDate;
	NSDate* endDate;
	
}
@property(nonatomic)NSString *url;
@property(nonatomic)SSDataSet *set;
@property(nonatomic)SSDataSet *volumeSet;
@property(nonatomic,assign)int resolution;
@property(nonatomic)NSDate *startDate;
@property(nonatomic)NSDate *endDate;

@end
