//
//  UserHandler.h
//  EnticeUsApp
//
//  Created by Faizan Ali on 18/12/2013.
//  Copyright (c) 2013 Slick. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <FacebookSDK/FacebookSDK.h>
#import "User.h"
typedef enum
{
    kLoginDone=0,
    
} UserDelegateType;


@class UserHandler;

@protocol UserHandlerDelegate <NSObject>
@optional
-(void)loginDone:(BOOL)status ;

@end


@interface UserHandler : NSObject
{
    BOOL isFacbookLogin;
    
    
}
@property (nonatomic,weak)id<UserHandlerDelegate> delegate;
@property (nonatomic,strong)UIView *delegateView;
@property (nonatomic,strong)User *objUser;
+ (UserHandler *)sharedInstance;

-(void)login:(NSString*)username password:(NSString*)password;


@end
