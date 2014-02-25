//
//  HorizontalAxisPoint.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 2/27/10.
//  Copyright 2010 Spritely Software.
//

#import <Foundation/Foundation.h>

@interface SSHorizontalAxisPoint : NSObject
{
    NSDate *date;
    NSString *text;
    int weight;
}
@property(nonatomic) NSDate *date;
@property(nonatomic) NSString *text;
@property(nonatomic, assign) int weight;
- (id)initWithDate:(NSDate *)aDate text:(NSString *)aText;
@end
