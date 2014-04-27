//
//  Quest.h
//  ChallengeProject
//
//  Created by Faizan on 4/27/14.
//  Copyright (c) 2014 MYRIAD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Quest : NSObject

@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *Details;
@property (nonatomic,strong)NSString *owner;
@property (nonatomic,assign)float ownerLatitude;
@property (nonatomic,assign)float ownerLongitude;
@property (nonatomic,assign)float latitude;
@property (nonatomic,assign)float longitude;
@property (nonatomic,strong)NSString *alignment;
@property (nonatomic,assign)int goldRewards;
@property (nonatomic,assign)int xpRewards;

@end
