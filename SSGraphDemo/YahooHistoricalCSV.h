//
//  YahooHistoricalCSV.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/5/10.
//  Copyright 2010 Spritely Software.
//

#import <Foundation/Foundation.h>

extern NSString * const YahooMonthly;
extern NSString * const YahooWeekly;
extern NSString * const YahooDaily;

@interface YahooHistoricalCSV : NSObject {

}
+(NSString*) urlWithSymbol:(NSString*)symbol from:(NSDate*)startDate to:(NSDate*)endDate frequency:(NSString*)frequency;
@end
