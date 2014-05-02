//
//  QuestHandler.h
//  ChallengeProject
//
//  Created by Faizan on 4/27/14.
//  Copyright (c) 2014 MYRIAD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Quest.h"

@class QuestHandler;

@protocol QuestHandlerDelegate <NSObject>
@optional
-(void)questLodingDone:(id)data Status:(BOOL)status ;
-(void)questAcceptedDone:(BOOL)status ;
-(void)questCompleteDone:(BOOL)status ;
@end


@interface QuestHandler : NSObject
@property (nonatomic,weak)id<QuestHandlerDelegate> delegate;
-(void)QuestAcceptCall:(Quest*)objQuest;
-(void)QuestCompleteCall:(Quest*)objQuest;
-(void)loadAllQuests:(int)pageNo alignmentType:(int)type;
@end
