//
//  NSDate+Utilities.h
//
//  Created by Dimitri Stancioff on 7/20/09.
//  Copyright 2009 Spritely Software.
//

#import <Foundation/Foundation.h>


@interface NSDate (Utilities) 
+(NSDate*)dateOnlyFromDate:(NSDate*)date;
- (BOOL) isBeforeDate:(NSDate*)date;
- (BOOL) isAfterDate:(NSDate*)date;
- (NSString *)stringForMonthDay;
- (BOOL) isSameDayAsDate:(NSDate*)date;
- (NSString*)formatDate;
@end
