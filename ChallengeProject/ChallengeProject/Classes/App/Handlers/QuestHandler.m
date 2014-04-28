//
//  QuestHandler.m
//  ChallengeProject
//
//  Created by Faizan on 4/27/14.
//  Copyright (c) 2014 MYRIAD. All rights reserved.
//

#import "QuestHandler.h"
#import "CommonMethods.h"

@implementation QuestHandler

-(void)loadAllQuests:(NSString*)alignmentType
{
    @try
    {
        NSMutableArray *objQuestsDataArray = [[NSMutableArray alloc] init];
        NSArray *tempQuestArray = [[NSArray alloc] initWithContentsOfFile:[CommonMethods plistPath:@"Quests"]];
        for (NSDictionary *objQuestDic in tempQuestArray)
        {
            if([[[objQuestDic objectForKey:@"Alignment"] lowercaseString] isEqualToString:[alignmentType lowercaseString]] || [[alignmentType lowercaseString] isEqualToString:@"neutral"])
            {
                Quest *objQuest = [[Quest alloc] init];
                objQuest.title = [objQuestDic objectForKey:@"Title"];
                objQuest.Details = [objQuestDic objectForKey:@"Details"];
                objQuest.owner = [objQuestDic objectForKey:@"Owner"];
                objQuest.ownerLatitude = [[objQuestDic objectForKey:@"OwnerLatitude"] floatValue];
                objQuest.ownerLongitude = [[objQuestDic objectForKey:@"OwnerLongitude"] floatValue];
                objQuest.latitude = [[objQuestDic objectForKey:@"Latitude"] floatValue];
                objQuest.longitude = [[objQuestDic objectForKey:@"Longitude"] floatValue];
                objQuest.alignment = [objQuestDic objectForKey:@"Alignment"];
                objQuest.goldRewards = [[objQuestDic objectForKey:@"GoldRewards"] intValue];
                objQuest.xpRewards = [[objQuestDic objectForKey:@"XP"] intValue];
                [objQuestsDataArray addObject:objQuest];
            }
            
        }
        [self.delegate questLodingDone:objQuestsDataArray Status:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"LoadAllQuest Exception %@",exception);
        [self.delegate questLodingDone:nil Status:NO];
    }
    @finally {
        
    }
   
    
    
    
}
@end
