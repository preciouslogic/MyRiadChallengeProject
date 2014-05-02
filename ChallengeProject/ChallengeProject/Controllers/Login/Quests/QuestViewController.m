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
#import "NoDataCell.h"
#import "CommonMethods.h"
@interface QuestViewController ()

@end

@implementation QuestViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    pageNo = 0;
    currentAlignment = [[[PFUser currentUser] objectForKey:@"alignment"] intValue];
   // NSLog(@"%@",[[PFUser currentUser] objectForKey:@"name"]);
    objQuestList = [[NSMutableArray alloc] init];
    filterData = [[NSMutableArray alloc] init];
    objQuestHandler = [[QuestHandler alloc] init];
    objQuestHandler.delegate = self;
    [objQuestHandler loadAllQuests:pageNo alignmentType:currentAlignment];
   
    if (_refreshHeaderView == nil)
    {
		
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tblViewQuestData.bounds.size.height, self.view.frame.size.width, self.tblViewQuestData.bounds.size.height) arrowImageName:@"grayArrow.png" textColor:[UIColor grayColor]];
        view.delegate = self;
        view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.85];
		[self.tblViewQuestData addSubview:view];
		_refreshHeaderView = view;
		
		
	}
    self.imgViewUserProfile.image = [UIImage imageNamed:placeHolderImage];
    //NSLog(@"%@",[PFUser currentUser]);
    
    if([[PFUser currentUser] objectForKey:@"customUserImage"] && [[PFUser currentUser] objectForKey:@"customUserImage"]!= [NSNull null])
    {
        PFFile *userImageFile = [PFUser currentUser][@"customUserImage"];
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                self.imgViewUserProfile.image = [UIImage imageWithData:imageData];
            }
        }];
    }
    self.imgViewUserProfile.clipsToBounds = YES;
    self.imgViewUserProfile.layer.cornerRadius = self.imgViewUserProfile.bounds.size.height/2;//half of the width
    self.imgViewUserProfile.layer.borderColor=[UIColor clearColor].CGColor;
	[_refreshHeaderView refreshLastUpdatedDate];
}
-(void)viewWillAppear:(BOOL)animated
{
     [self onFilterChange];
     [self setViewAccordingToOrientations];
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
        objDetailViewController.objQuest = [filterData objectAtIndex:selectedRow];
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

    if(dataLoadingDone)
    {
        return filterData.count+1;
    }
    else
    {
        return 0;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row< filterData.count)
    {
        static NSString *CellIdentifier = @"QuestCell";
        QuestCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        Quest *objQuest = [filterData objectAtIndex:indexPath.row];
        cell.lblQuestHeading.text = objQuest.title;
        cell.lblPostedBy.text = [NSString stringWithFormat:@"Posted By: %@",[objQuest.objOwner objectForKey:@"name"]];
        cell.lblRewards.text = [NSString stringWithFormat:@"Rewards: %d Gold %d XP",objQuest.goldRewards,objQuest.xpRewards];
        // Configure the cell...
        cell.imgViewQuest.image = [UIImage imageNamed:placeHolderImage];
        cell.imgViewQuest.imageURL = objQuest.imageURL;
        NSLog(@"%@",objQuest.imageURL );
        return cell;
    }
    else
    {
        NoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotDataCell" forIndexPath:indexPath];
        if(filterData.count<=0)
        {
            cell.lblMsg.text = [NSString stringWithFormat:@"No Quests Available"];
        }
        else
        {
            cell.lblMsg.text = [NSString stringWithFormat:@"No More Quests"];
        }
        
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"DetailViewController" sender:tableView];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row< filterData.count)
    {
        return 92;
    }
    else
    {
        return 50;
    }
    
}
- (IBAction)logoutAction:(id)sender
{
    if(self.isSignUpCall)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (IBAction)filterAction:(id)sender
{
    [self onFilterChange];
}
-(void)setViewAccordingToOrientations
{
    UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
    
    [self.view endEditing:YES];
    if (orientation==UIInterfaceOrientationPortrait)
    {
        self.segmentFilters.frame = CGRectMake(90, 20, 220, 29);
        self.tblViewQuestData.frame = CGRectMake(0, 65, 320, 439);
        self.imgViewUserProfile.frame = CGRectMake(15, 8, 50, 50);
    }
    else if (orientation==UIInterfaceOrientationLandscapeLeft || orientation==UIInterfaceOrientationLandscapeRight)
    {
        
        
        self.imgViewUserProfile.frame = CGRectMake(15, 2, 50, 50);
        self.segmentFilters.frame = CGRectMake(144, 14, 270, 29);
        if(g_IS_IPHONE_4_SCREEN)
        {
            self.tblViewQuestData.frame = CGRectMake(0, 56, 480, 200);
        }
        else
        {
            self.tblViewQuestData.frame = CGRectMake(0, 56, 568, 200);
        }
        
        
    }
}
- (BOOL)shouldAutorotate {
    
    [self setViewAccordingToOrientations];
    
    return YES;
}
-(void)onFilterChange
{
    [filterData removeAllObjects];
    
    for (Quest *objQuest in objQuestList)
    {
        if(self.segmentFilters.selectedSegmentIndex == 0 && !objQuest.isAccepted)
        {
            [filterData addObject:objQuest];
        }
        else if(self.segmentFilters.selectedSegmentIndex == 1 && objQuest.isAccepted && !objQuest.isCompleted)
        {
            [filterData addObject:objQuest];
        }
        else if(self.segmentFilters.selectedSegmentIndex == 2 && objQuest.isCompleted)
        {
            [filterData addObject:objQuest];
        }
    }
    
    [self.tblViewQuestData reloadData];
}
#pragma mark QuestHandlerDelegates
-(void)questLodingDone:(id)data Status:(BOOL)status
{
    if(status)
    {
        
        objQuestList = data;
        dataLoadingDone = YES;
        [self doneLoadingTableViewData];
        if(objQuestList.count < 20)
        {
            dataLoading = YES;
        }
        else
        {
            dataLoading = NO;
        }
        if(objQuestList.count<=0)
        {
            [SVProgressHUD showSuccessWithStatus:@"No Quests found"];
        }
        [self onFilterChange];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"Some thing wrong happend!"];
    }
}
#pragma  mark SettingViewDelegates
-(void)settingViewControllerDone:(int)selectedType
{
    currentAlignment = selectedType;
    [objQuestHandler loadAllQuests:pageNo alignmentType:currentAlignment];
}
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    if(scrollView.contentOffset.y > point.y)
    {
        float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        //NSLog(@"bottom:%f scrollHeight:%f floor:%f",bottomEdge,scrollView.contentSize.height,floor(scrollView.contentSize.height));
        float LoadedHeight = floor(scrollView.contentSize.height)-200;
        // NSLog(@"loaded:%f total:%f",LoadedHeight,floor(scrollView.contentSize.height));
        if (bottomEdge >=  LoadedHeight )
        {
            if(!dataLoading)
            {
                NSLog(@"called");
                dataLoading = YES;
                pageNo +=1;
                [objQuestHandler loadAllQuests:pageNo alignmentType:currentAlignment];
            }
        }
        
        
    }
    
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    point = scrollView.contentOffset;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	_reloading = YES;
    pageNo = 0;
    [objQuestHandler loadAllQuests:pageNo alignmentType:currentAlignment];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}
- (void)doneLoadingTableViewData
{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tblViewQuestData];
	
}
@end
