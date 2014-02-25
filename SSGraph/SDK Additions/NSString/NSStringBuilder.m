//
//  StringBuilder.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/5/10.
//  Copyright 2010 Spritely Software.
//

#import "NSStringBuilder.h"


@implementation NSString (Builder)

// Test cases:
// start: @"{replace1}static", end: @"static{replace1}", mid: @"stat{replace1}ic", none:@"static", all: @"{replace1}"
+(NSString*)stringWithArgumentFormat:(NSString*)format replacements:(NSDictionary*)replacementDictionary
{
	
	NSCharacterSet *openBracketSet = [NSCharacterSet characterSetWithCharactersInString:@"{"];
	NSCharacterSet *closeBracketSet = [NSCharacterSet characterSetWithCharactersInString:@"}"];
	NSScanner *theScanner = [NSScanner scannerWithString:format];
	NSMutableArray *newStringComponents = [NSMutableArray array];
	while (![theScanner isAtEnd])
	{
		NSString *allFormat = nil;
		NSString *key = nil;
		
		[theScanner scanUpToCharactersFromSet:openBracketSet intoString:&allFormat];
		if(allFormat)
			[newStringComponents addObject:allFormat];
		
		if ([theScanner scanString:@"{" intoString:NULL] &&
			[theScanner scanUpToCharactersFromSet:closeBracketSet intoString:&key] &&
			[theScanner scanString:@"}" intoString:NULL])
		{
			NSString* value = [replacementDictionary valueForKeyPath:key];
			if(value)
				[newStringComponents addObject:value];
			else
				[newStringComponents addObject:[NSString stringWithFormat:@"{%@ NOT FOUND}",key]];
		}

	}
	return [newStringComponents componentsJoinedByString:@""];
}

@end
