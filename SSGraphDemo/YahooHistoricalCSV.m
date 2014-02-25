//
//  YahooHistoricalCSV.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/5/10.
//  Copyright 2010 Spritely Software.
//

#import "YahooHistoricalCSV.h"
#import "NSStringBuilder.h"

NSString * const YahooMonthly = @"m";
NSString * const YahooWeekly = @"w";
NSString * const YahooDaily = @"d";

@implementation YahooHistoricalCSV
+(NSString*) urlWithSymbol:(NSString*)symbol from:(NSDate*)startDate to:(NSDate*)endDate frequency:(NSString*)frequency
{
	if (!frequency) {
		frequency = YahooDaily;
	}
	NSDateComponents *startComps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:startDate];
	NSDateComponents *endComps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:endDate];
	
	
	NSDictionary* arguments = [NSDictionary dictionaryWithObjectsAndKeys:
							   symbol, @"symbol",
							   [NSString stringWithFormat:@"%d", [startComps year]], @"startYear",
							   [NSString stringWithFormat:@"%d", [startComps month]-1], @"startMonth",
							   [NSString stringWithFormat:@"%d", [startComps day]], @"startDay",
							   [NSString stringWithFormat:@"%d", [endComps year]], @"endYear",
							   [NSString stringWithFormat:@"%d", [endComps month]-1], @"endMonth",
							   [NSString stringWithFormat:@"%d", [endComps day]], @"endDay",
							   frequency, @"frequency", nil];
	NSString* baseUrl = @"http://ichart.finance.yahoo.com/table.csv?s={symbol}&ignore=csv&g={frequency}&f={endYear}&e={endDay}&d={endMonth}&c={startYear}&b={startDay}&a={startMonth}";
	
	NSString *url = [NSString stringWithArgumentFormat:baseUrl replacements:arguments];
	
	//NSString *url = [NSString stringWit:@"http://ichart.finance.yahoo.com/table.csv?s={quote}&ignore=%@&g=h&f=2010&e=5&d=2&c=2009&b=5&a=2"
	return url;				 
}
@end
