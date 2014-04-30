//
//  UserHandler.m
//  EnticeUsApp
//
//  Created by Faizan Ali on 18/12/2013.
//  Copyright (c) 2013 Slick. All rights reserved.
//

#import "UserHandler.h"
#import "CommonMethods.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
//#import "NetworkHandler.h"
@implementation UserHandler
static UserHandler *singleton = nil;

+ (UserHandler *)sharedInstance {
    if (nil != singleton) {
        return singleton;
    }
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        singleton = [[UserHandler alloc] init];
       
    });
    
    return singleton;
}

#pragma mark Login
-(void)login:(NSString*)username password:(NSString*)password
{
    [SVProgressHUD showWithStatus:@"Logging..."];

    [PFUser logInWithUsernameInBackground:username password:password
                                    block:^(PFUser *user, NSError *error) {
                                        
                                        [SVProgressHUD dismiss];
                                        if (user) {
                                        
                                            [self.delegate loginDone:YES];
                                        } else {
                                            [self.delegate loginDone:NO];
                                            NSString *errorString = [error userInfo][@"error"];
                                            [SVProgressHUD dismiss];
                                            [SVProgressHUD showErrorWithStatus:errorString];

                                        }
                                    }];
    
}
#pragma mark signUp
-(void)signUp:(NSString*)username password:(NSString*)password Name:(NSString*)name alignmenttype:(int)type
{
    [SVProgressHUD showWithStatus:@"Signing Up...."];
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    
    //user.email = [NSString stringWithFormat:@"%@@gmail.com",username];
    user[@"alignment"] = [NSNumber numberWithInt:type];
    user[@"name"] = name;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        [SVProgressHUD dismiss];
        if (!error)
        {
            NSLog(@"object ID%@",user.objectId);
            [self.delegate signUpDone:YES];
            
        } else
        {
            NSString *errorString = [error userInfo][@"error"];
            [self.delegate signUpDone:NO];
            
            [SVProgressHUD showErrorWithStatus:errorString];
            // Show the errorString somewhere and let the user try again.
        }
    }];
             
}
#pragma mark LoginUsingFacebook
-(void)loginUsingFacebook
{
    [SVProgressHUD showWithStatus:@"Logging..."];
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"email",nil];
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error)
     {
         [SVProgressHUD dismiss];
         if (!error)
         {
             if (!user) {
                 [SVProgressHUD showErrorWithStatus:@"Uh oh. The user cancelled the Facebook login."];
                 
             }
             else {
                 [self.delegate loginDone:YES];
             }
             
         } else
         {
             NSString *errorString = [error userInfo][@"error"];
             [self.delegate loginDone:NO];
             
             [SVProgressHUD showErrorWithStatus:errorString];
             // Show the errorString somewhere and let the user try again.
         }
        
    }];
}
-(void)loginUsingTwitter
{
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted)
            {
                NSArray *accounts = [accountStore accountsWithAccountType:accountType];
                // Check if the users has setup at least one Twitter account
                if (accounts.count > 0)
                {
                    [SVProgressHUD showWithStatus:@"Logging..."];
                    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
                        [SVProgressHUD dismiss];
                        if (!error)
                        {
                            if (!user) {
                                [SVProgressHUD showErrorWithStatus:@"Uh oh. The user cancelled the Facebook login."];
                                
                            }
                            else {
                                [self.delegate loginDone:YES];
                            }
                            
                        } else
                        {
                            NSString *errorString = [error userInfo][@"error"];
                            [self.delegate loginDone:NO];
                            
                            [SVProgressHUD showErrorWithStatus:errorString];
                            // Show the errorString somewhere and let the user try again.
                        }
                    }];
                }
                else
                {
                    [CommonMethods showAlertView:@"No Twitter Account Setup" Message:@"Goto 1. Settings 2. Twitter 3. Setup an account"];
                }
            }
            else
            {
                [CommonMethods showAlertView:@"Twitter permission needed" Message:@"Goto 1. Settings 2. Twitter 3. Set ChallengeProject to ON"];
            }
        });
    }];
    
}
@end
