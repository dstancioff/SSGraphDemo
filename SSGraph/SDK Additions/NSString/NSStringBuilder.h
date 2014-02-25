//
//  StringBuilder.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/5/10.
//  Copyright 2010 Spritely Software.
//

#import <Foundation/Foundation.h>


@interface NSString (Builder)
+(NSString*)stringWithArgumentFormat:(NSString*)format replacements:(NSDictionary*)replacementDictionary;
@end
