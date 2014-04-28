//
//  QuestHandler.h
//  ChallengeProject
//
//  Created by Faizan on 4/27/14.
//  Copyright (c) 2014 MYRIAD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Quest.h"
typedef enum
{
    kQuestLoded=0,
    
} UserDelegateType;


@class QuestHandler;

@protocol QuestHandlerDelegate <NSObject>
@optional
-(void)questLodingDone:(id)data Status:(BOOL)status ;

@end


@interface QuestHandler : NSObject
@property (nonatomic,weak)id<QuestHandlerDelegate> delegate;

-(void)loadAllQuests:(NSString*)alignmentType;
@end
