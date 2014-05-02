//
//  QuestHandler.m
//  ChallengeProject
//
//  Created by Faizan on 4/27/14.
//  Copyright (c) 2014 MYRIAD. All rights reserved.
//

#import "QuestHandler.h"
#import "CommonMethods.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
@implementation QuestHandler


-(void)QuestAcceptCall:(Quest*)objQuest
{
    [SVProgressHUD showWithStatus:@"Processing..."];

    PFQuery *query = [PFQuery queryWithClassName:@"Quests"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:objQuest.questID block:^(PFObject *gameScore, NSError *error) {
        
        [SVProgressHUD dismiss];
        if(!error)
        {
            [SVProgressHUD showSuccessWithStatus:@"Quest Accepted Successfully"];
            gameScore[@"acceptedBy"] = [PFUser currentUser];
            
            [gameScore saveInBackground];
            [self.delegate questAcceptedDone:YES];
  
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"Some thing wrong happend!"];
            [self.delegate questAcceptedDone:NO];
        }
        
        
    }];
}
-(void)QuestCompleteCall:(Quest*)objQuest
{
    [SVProgressHUD showWithStatus:@"Processing..."];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Quests"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:objQuest.questID block:^(PFObject *gameScore, NSError *error) {
        
        
         [SVProgressHUD dismiss];
        if(!error)
        {
            [SVProgressHUD showSuccessWithStatus:@"Quest Completed Successfully"];
            gameScore[@"completed"] = [NSNumber numberWithBool:YES];
            
            [gameScore saveInBackground];
            [self.delegate questCompleteDone:YES];
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"Some thing wrong happend!"];
            [self.delegate questCompleteDone:NO];
        }
       
        
    }];
}

-(void)loadAllQuests:(int)pageNo alignmentType:(int)type
{
    @try
    {
        [SVProgressHUD showWithStatus:@"Loading Quests..."];
        
        PFQuery *playerAcceptedAndCompleteQuest = [PFQuery queryWithClassName:@"Quests"];
        [playerAcceptedAndCompleteQuest whereKey:@"acceptedBy" equalTo:[PFUser currentUser]];
        [playerAcceptedAndCompleteQuest whereKey:@"alignment" equalTo:[NSNumber numberWithInt:type]];
        
        PFQuery *allNotAcceptedPost = [PFQuery queryWithClassName:@"Quests"];
        [allNotAcceptedPost whereKey:@"acceptedBy" equalTo:[NSNull null]];
        [allNotAcceptedPost whereKey:@"alignment" equalTo:[NSNumber numberWithInt:type]];
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[playerAcceptedAndCompleteQuest,allNotAcceptedPost]];
        query.skip = pageNo*20;
        query.limit = 20;
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error)
        {
            
            NSMutableArray *objQuestsDataArray = [[NSMutableArray alloc] init];
            for (PFObject *objQuestDic in results)
            {
                    Quest *objQuest = [[Quest alloc] init];
                    objQuest.questID = objQuestDic.objectId;
                    objQuest.title = [objQuestDic objectForKey:@"name"];
                    objQuest.Details = [objQuestDic objectForKey:@"description"];
                    objQuest.location = [objQuestDic objectForKey:@"location"];
                    objQuest.alignment = [[objQuestDic objectForKey:@"alignment"] intValue];
                    objQuest.goldRewards = 1000;
                    objQuest.xpRewards = 1000;
                
                    if([objQuestDic objectForKey:@"acceptedBy"] && [objQuestDic objectForKey:@"acceptedBy"] !=[NSNull null])
                    {
                        objQuest.isAccepted = YES;
                        objQuest.isCompleted = [[objQuestDic objectForKey:@"completed"] boolValue];
                    }
                
                    objQuest.imageURL = [NSURL URLWithString:[objQuestDic objectForKey:@"locationImageUrl"]];
                
                    PFUser *objUser =[objQuestDic objectForKey:@"questGiver"];
                    [objUser fetch];
                    objQuest.objOwner =objUser ;
                    NSLog(@"%@",objQuest.objOwner);
                    [objQuestsDataArray addObject:objQuest];
                
                
            }
            [SVProgressHUD dismiss];
            [self.delegate questLodingDone:objQuestsDataArray Status:YES];
        }];
        
    }
    @catch (NSException *exception) {
        [SVProgressHUD dismiss];
        NSLog(@"LoadAllQuest Exception %@",exception);
        [self.delegate questLodingDone:nil Status:NO];
    }
    @finally {
        
    }
}
@end
