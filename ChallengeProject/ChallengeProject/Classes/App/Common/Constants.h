//
//  Constants.h
//  FlickGame
//
//  Created by Emblem on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef FlickGame_Constants_h


#define FacebookAppID @"177660272400422"
#define Username @"Lancelot"
#define Password @"arthurDoesntKnow"


#define g_IS_IPHONE_4_SCREEN    [[UIScreen mainScreen] bounds].size.height >= 480.0f && [[UIScreen mainScreen] bounds].size.height < 568.0f
#define g_IS_IPHONE             ( [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] )
#define g_IS_IPOD               ( [[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"] )
#define g_IS_IPAD               ( [[[UIDevice currentDevice] model] isEqualToString:@"iPad"] )
#define myAppDelegate             [[UIApplication sharedApplication] delegate]
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define CurrentDeviceBound [[UIScreen mainScreen] bounds]

#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360
#define placeHolderImage @"placeHolder.png"

#endif
