//
//  NSString-Utilities.m
//
//
//  Created by Dimitri Stancioff on 2/20/09.
//  Copyright 2009 Spritely Software.
//

#import "NSString-Utilities.h"


@implementation NSString (Utilities) 
-(BOOL) isNilOrEmpty {
	if(self == nil || [self isEqualToString:@""])
	{
		return true;
	}
	else
	{
		return false;
	}
	
}

-(NSString*) addHttp
{
	NSString *webUrl = self;
	if ([webUrl rangeOfString:@"http://"].location == NSNotFound)
	{ 
		NSString *httpPrefix = @"http://"; // CREATE a variable of type string with the "http://" prefix
		NSString *correctURL = [httpPrefix stringByAppendingString:webUrl]; // Combine both strings to get the final one
		webUrl = correctURL;
	}
	return webUrl;
}

///
// Returns the plural form of the string, for a specific count.
///
-(NSString*) pluralStringForCount:(NSInteger) count
{
	BOOL shouldBePlural = count != 1;
	NSString *returnString = [NSString stringWithString:self];
	if([self characterAtIndex:[self length]-1] == 's') //already plural
	{
		if(!shouldBePlural)
			returnString = [self stringByReplacingCharactersInRange:NSMakeRange([self length]-1, 1) withString:@""];
	}
	else if(shouldBePlural) { //not already plural
		returnString = [self stringByAppendingString:@"s"];
	}
	return returnString;

}
@end 
