//
//  UserHandler.h
//  EnticeUsApp
//
//  Created by Faizan Ali on 18/12/2013.
//  Copyright (c) 2013 Slick. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <FacebookSDK/FacebookSDK.h>

@class UserHandler;

@protocol UserHandlerDelegate <NSObject>
@optional
-(void)loginDone:(BOOL)status ;
-(void)signUpDone:(BOOL)status ;
@end


@interface UserHandler : NSObject
{
    BOOL isFacbookLogin;
    
    
}
@property (nonatomic,weak)id<UserHandlerDelegate> delegate;
@property (nonatomic,strong)UIView *delegateView;

+ (UserHandler *)sharedInstance;

-(void)login:(NSString*)username password:(NSString*)password;
-(void)signUp:(NSString*)username password:(NSString*)password Name:(NSString*)name alignmenttype:(int)type image:(UIImage*)userImage;
-(void)loginUsingFacebook;
-(void)loginUsingTwitter;
@end
