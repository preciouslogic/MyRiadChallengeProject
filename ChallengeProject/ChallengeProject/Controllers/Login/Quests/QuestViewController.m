//
//  QuestViewController.m
//  ChallengeProject
//
//  Created by Faizan on 4/26/14.
//  Copyright (c) 2014 MYRIAD. All rights reserved.
//

#import "QuestViewController.h"
#import "QuestCell.h"
#import "SVProgressHUD.h"
#import "DetailsViewController.h"

@interface QuestViewController ()

@end

@implementation QuestViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentAlignment = @"neutral";
    objQuestList = [[NSMutableArray alloc] init];
    objQuestHandler = [[QuestHandler alloc] init];
    objQuestHandler.delegate = self;
    [objQuestHandler loadAllQuests:currentAlignment];
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"DetailViewController"])
    {
        DetailsViewController *objDetailViewController = segue.destinationViewController;
        objDetailViewController.objQuest = [objQuestList objectAtIndex:selectedRow];
    }
    else if([segue.identifier isEqualToString:@"SettingViewController"])
    {
        UINavigationController *objNav = segue.destinationViewController;
        SettingViewController *objSetting = [objNav.viewControllers objectAtIndex:0];
        objSetting.delegate = self;
        
    }
}
- (IBAction)settingAction:(id)sender
{
    [self performSegueWithIdentifier:@"SettingViewController" sender:nil];
}

#pragma mark TableViewDelegatesAndDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return objQuestList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QuestCell";
    QuestCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Quest *objQuest = [objQuestList objectAtIndex:indexPath.row];
    cell.lblQuestHeading.text = objQuest.title;
    cell.lblPostedBy.text = [NSString stringWithFormat:@"Posted By: %@",objQuest.owner];
    cell.lblRewards.text = [NSString stringWithFormat:@"Rewards: %d Gold %d XP",objQuest.goldRewards,objQuest.xpRewards];
    // Configure the cell...
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"DetailViewController" sender:tableView];
}
- (IBAction)logoutAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark QuestHandlerDelegates
-(void)questLodingDone:(id)data Status:(BOOL)status
{
    if(status)
    {
        
        objQuestList = data;
        [self.tableView reloadData];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"Some thing wrong happend!"];
    }
}
#pragma  mark SettingViewDelegates
-(void)settingViewControllerDone:(NSString *)selectedType
{
    currentAlignment = selectedType;
     [objQuestHandler loadAllQuests:currentAlignment];
}
@end
