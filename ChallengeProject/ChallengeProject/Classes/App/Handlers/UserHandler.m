//
//  UserHandler.m
//  EnticeUsApp
//
//  Created by Faizan Ali on 18/12/2013.
//  Copyright (c) 2013 Slick. All rights reserved.
//

#import "UserHandler.h"
#import "CommonMethods.h"
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
    
    if([username isEqualToString:@"Lancelot"] && [password isEqualToString:@"arthurDoesntKnow"])
    {
        self.objUser = [[User alloc] init];
        self.objUser.firstName =  @"jhon";
        self.objUser.lastName =  @"malik";
        self.objUser.username =  username;
        self.objUser.displayPic = [NSURL URLWithString:@"http://howfb.com/gallery/dps/Stylish-Cute-Little-Boy-Dp-For-Facebook.jpg"];
        self.objUser.sessionId = @"1234567890";
        [self.delegate loginDone:YES];
    }
    else
    {
        [self.delegate loginDone:NO];
    }
    
}

@end
