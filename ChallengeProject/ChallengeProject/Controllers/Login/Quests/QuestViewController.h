//
//  QuestViewController.h
//  ChallengeProject
//
//  Created by Faizan on 4/26/14.
//  Copyright (c) 2014 MYRIAD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestHandler.h"
#import "SettingViewController.h"
@interface QuestViewController : UITableViewController<QuestHandlerDelegate,SettingViewControllerDelegates>
{
    QuestHandler *objQuestHandler;
    NSMutableArray *objQuestList;
    int selectedRow;
    NSString *currentAlignment;
}
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
- (IBAction)logoutAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSetting;
- (IBAction)settingAction:(id)sender;

@end
