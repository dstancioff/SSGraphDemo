//
//  AnnotationProvider.m
//  SSGraphDemo
//
//  Created by Dimitri Stancioff on 3/2/10.
//  Copyright 2010 Spritely Software.
//

#import "AnnotationProvider.h"
#import "SSImageAnnotationView.h"

@implementation AnnotationProvider
@synthesize graph;
- (id) init
{
	self = [super init];
	if (self != nil) {
		annotations = [[NSMutableArray alloc] init];
		for (int i = 0; i < 24; i++) {
			 SSAnnotation *stockSplit = [[SSAnnotation alloc] init];
			 stockSplit.date = [NSDate dateWithTimeIntervalSinceNow:-365*60*60*24*i];
			[annotations addObject:stockSplit];
		}
		
	}
	return self;
}

-(NSSet*)annotationsfromDate:(NSDate*)startDate toDate:(NSDate*)endDate
{
	NSMutableSet *returnedAnnotations = [NSMutableSet set];
	for (SSAnnotation *annotation in annotations) {
		if ([annotation.date isAfterDate:startDate] && [annotation.date isBeforeDate:endDate]) {
			
			[returnedAnnotations addObject:annotation];
		}
	}
	
	//stockSplit.text = @"2:1";
	return returnedAnnotations;
}
-(SSAnnotationStyle*)styleForAnnotation:(SSAnnotation*)annotation
{
	//TODO: cache this
	SSAnnotationStyle *style = [[SSAnnotationStyle alloc] init];
	style.location = SSAnnotationLocationBottom;
	return style;
}
-(SSAnnotationView*)viewForAnnotation:(SSAnnotation*)annotation
{
	SSImageAnnotationView *annotationView = (SSImageAnnotationView *) [graph dequeueReusableAnnotationViewWithIdentifier:@"split"];
	if(!annotationView)
	{
		annotationView = [[SSImageAnnotationView alloc] initWithReuseIdentifier:@"split"];
	}
	else {
	}
	annotationView.annotation = annotation;
	annotationView.imageView.image = [UIImage imageNamed:@"split.png"];
	annotationView.imageView.contentMode = UIViewContentModeBottom;
	annotationView.label.text = @"2:1";
	return annotationView;
}
@end
