//
//  AnnotationMaker.m
//  WinterApp
//
//  Created by Mohsin Yaseen on 12/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnnotationMaker.h"

@implementation AnnotationMaker
@synthesize title, coordinate;
@synthesize subTitle;

- (id)initWithTitle:(NSString *)ttl withSubTitle:(NSString*)subTit andCoordinate:(CLLocationCoordinate2D)c2d
{
	self = [super init];
    
	title = ttl;
	coordinate = c2d;
    subTitle=subTit;
	return self;
}
@end

