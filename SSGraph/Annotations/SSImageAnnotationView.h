//
//  SSImageAnnotationView.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/4/10.
//  Copyright 2010 Spritely Software.
//

#import <Foundation/Foundation.h>
#import "SSAnnotationView.h"

@interface SSImageAnnotationView : SSAnnotationView
{
    UIImageView *imageView;
    UILabel *label;
}
@property(readonly) UIImageView *imageView;
@property(readonly) UILabel *label;
@end
