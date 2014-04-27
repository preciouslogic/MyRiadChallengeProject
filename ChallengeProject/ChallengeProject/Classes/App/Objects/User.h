//
//  User.h
//  ChallengeProject
//
//  Created by Faizan on 4/27/14.
//  Copyright (c) 2014 MYRIAD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *firstName;
@property(nonatomic,strong)NSString *lastName;
@property(nonatomic,strong)NSURL *displayPic;
@property(nonatomic,strong)NSString *sessionId;
@end
