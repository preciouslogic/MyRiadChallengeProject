//
//  Quest.h
//  ChallengeProject
//
//  Created by Faizan on 4/27/14.
//  Copyright (c) 2014 MYRIAD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
@interface Quest : NSObject


@property (nonatomic,strong)NSString *questID;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *Details;
@property (nonatomic,strong)PFGeoPoint *location;
@property (nonatomic,assign)int alignment;
@property (nonatomic,assign)int goldRewards;
@property (nonatomic,assign)int xpRewards;
@property (nonatomic,assign)BOOL isAccepted;
@property (nonatomic,assign)BOOL isCompleted;
@property (nonatomic,strong)NSURL *imageURL;
@property (nonatomic,strong)PFUser *objOwner;
@end
