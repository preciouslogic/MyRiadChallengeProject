//
//  QuestViewController.h
//  ChallengeProject
//
//  Created by Faizan on 4/26/14.
//  Copyright (c) 2014 MYRIAD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestHandler.h"
@interface QuestViewController : UITableViewController<QuestHandlerDelegate>
{
    QuestHandler *objQuestHandler;
    NSMutableArray *objQuestList;
    int selectedRow;
}
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
- (IBAction)logoutAction:(id)sender;

@end
