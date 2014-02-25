//
//  SSAnnotationView.h
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/3/10.
//  Copyright 2010 Spritely Software.
//

#import <UIKit/UIKit.h>
#import "SSAnnotation.h"

@interface SSAnnotationView : UIView
{
    NSString *_reuseIdentifier;
    SSAnnotation *_annotation;
}
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
@property(readwrite) NSString *reuseIdentifier;
@property(readwrite) SSAnnotation *annotation;
@end
