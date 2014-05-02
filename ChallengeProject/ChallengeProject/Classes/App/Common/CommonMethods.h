//
//  CommonMethods.h
//
//  Created by Faizan Ali on 25/04/2014.
//  Copyright (c) 2014. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
//#import <FacebookSDK/FacebookSDK.h>
#import "Constants.h"


@interface CommonMethods : NSObject


+(NSString*)plistPath:(NSString *)plistName;
+(void)showAlertView:(NSString*)title Message:(NSString*)msg;


+(void)onTextFieldBeingEditing:(id)sender forView:(UIView*)view isTextField:(BOOL)isTextField;
+(void)onEndingOfTextEditing:(id)sender forView:(UIView*)view isTextField:(BOOL)isTextField;
+(void)saveInUserDefaultValue:(id)value forKey:(NSString*)key;
+(id)getFromUserDefaultValueForKey:(NSString*)key;



+(float)calculateTextSize:(NSString *)msgStr fontSize:(UIFont*)font;
+(BOOL)containString:(NSString*)str inText:(NSString*)text;
+(NSString *)getUUID;


+(void)removeFromUserDefaultValueForKey:(NSString*)key;

+(NSString *)countStringLength:(NSString *)str;
+(void)takePhoto:(id)delegate;
+(void)selectPhoto:(id)delegate;

@end
