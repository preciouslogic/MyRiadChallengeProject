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
#import "EGORefreshTableHeaderView.h"
#import <QuartzCore/QuartzCore.h>


@interface QuestViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,QuestHandlerDelegate,SettingViewControllerDelegates,EGORefreshTableHeaderDelegate>
{
    QuestHandler *objQuestHandler;
    NSMutableArray *objQuestList;
    int selectedRow;
    int currentAlignment;
    int selectedFilterType;
    NSMutableArray *filterData;
    BOOL dataLoadingDone;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    CGPoint point;
    BOOL dataLoading;
    int pageNo;
}
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@property (weak, nonatomic) IBOutlet UIButton *btnSetting;
@property (assign,nonatomic)BOOL isSignUpCall;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentFilters;
@property (weak, nonatomic) IBOutlet UITableView *tblViewQuestData;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewUserProfile;


- (IBAction)settingAction:(id)sender;
- (IBAction)logoutAction:(id)sender;
- (IBAction)filterAction:(id)sender;

@end
