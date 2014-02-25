//
//  NSString-Utilities.h
//
//
//  Created by Dimitri Stancioff on 2/20/09.
//  Copyright 2009 Spritely Software.
//

#import <Foundation/Foundation.h>


@interface NSString (Utilities)
-(BOOL) isNilOrEmpty;
-(NSString*) pluralStringForCount:(NSInteger) count;
-(NSString*) addHttp;
@end
