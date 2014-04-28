//
//  AnnotationMaker.h
//  WinterApp
//
//  Created by Mohsin Yaseen on 12/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<MapKit/MapKit.h>
@interface AnnotationMaker : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;	
	NSString *title;
    NSString *subTitle;
}

@property(nonatomic,copy)NSString *title;
@property(nonatomic,assign)int type;
@property(nonatomic,copy)NSString *subTitle;
@property (nonatomic, readonly)CLLocationCoordinate2D coordinate;
- (id)initWithTitle:(NSString *)ttl withSubTitle:(NSString*)subTit andCoordinate:(CLLocationCoordinate2D)c2d;
@end
