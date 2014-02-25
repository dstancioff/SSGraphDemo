//
//  VerticalAccessPoint.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 2/27/10.
//  Copyright 2010 Spritely Software.
//

#import <Foundation/Foundation.h>

@interface SSVerticalAxisPoint : NSObject
{
    double value;
    NSString *text;
    int weight;
}
@property(nonatomic, assign) double value;
@property(nonatomic, assign) int weight;
@property(nonatomic) NSString *text;
- (id)initWithValue:(double)aValue text:(NSString *)aText;
@end
