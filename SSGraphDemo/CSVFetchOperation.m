//
//  CSVFetchOperation.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/8/10.
//  Copyright 2010 Spritely Software.
//

#import "CSVFetchOperation.h"
#import "SSGraphPoint.h"
#import "SSUtilities.h"

@implementation CSVFetchOperation

@synthesize url = url;
@synthesize set = set;
@synthesize volumeSet;
@synthesize resolution = resolution;
@synthesize startDate = startDate;
@synthesize endDate = endDate;


- (void) dealloc
{
	
	endDate = nil;
	url = nil;
	set = nil;
}

-(void)main {
    if ( self.isCancelled ) return;
    if ( nil == self.url ) return;
    [self readInCSV];
    if ( self.isCancelled ) return;
}

-(void)readInCSV
{
	NSLog(@"Fetching data for url:%@",url);
	NSString* fileData = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
	NSArray *lines = [fileData componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	
	NSMutableArray *newValues = [NSMutableArray arrayWithCapacity:[lines count]];
	NSMutableArray *newVolumes = [NSMutableArray arrayWithCapacity:[lines count]];
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	//2010-02-25
	[dateFormat setDateFormat:@"yyy-MM-dd"];
	
	for (NSString *line in lines) {
		
		NSArray *components = [line componentsSeparatedByString:@","];
		if ([components count] < 4) {
			break;
		}
		NSDate *date = [dateFormat dateFromString:[components objectAtIndex:0]]; 
		if(date)
		{
			SSGraphPoint *point = [[SSGraphPoint alloc] init];
			if(resolution == 0)
			{
				
				date = [date dateByAddingYears:0 months:0 days:15 hours:0 minutes:0 seconds:0];
			}
			else {
				
			}
			point.date = date;
			point.value = [[components objectAtIndex:6] doubleValue];
			[newValues addObject:point];
			
			SSGraphPoint *volumePoint = [[SSGraphPoint alloc] init];
			volumePoint.date = date;
			volumePoint.value = [[components objectAtIndex:5] doubleValue];
			[newVolumes addObject:volumePoint];
			
		}
	}
	
		
	[set feedMe:newValues forResolution:resolution from:startDate to:endDate];
    [volumeSet feedMe:newVolumes forResolution:0 from:startDate to:endDate];
	[volumeSet feedMe:newVolumes forResolution:1 from:startDate to:endDate];

}
@end
