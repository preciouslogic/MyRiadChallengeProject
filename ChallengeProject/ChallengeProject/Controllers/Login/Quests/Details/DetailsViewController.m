//
//  DetailsViewController.m
//  ChallengeProject
//
//  Created by Faizan on 4/26/14.
//  Copyright (c) 2014 MYRIAD. All rights reserved.
//

#import "DetailsViewController.h"
#import "CommonMethods.h"
@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txtFieldHeading.text = self.objQuest.title;
    self.lblPosted.text = [NSString stringWithFormat:@"Posted By: %@",self.objQuest.owner];
    self.txtFieldDetails.text  = self.objQuest.Details;
    
    [self.txtFieldHeading sizeToFit];
    CGRect lblPostedFrame = self.lblPosted.frame;
    lblPostedFrame.origin.y = self.txtFieldHeading.frame.origin.y+self.txtFieldHeading.frame.size.height+5;
    self.lblPosted.frame = lblPostedFrame;
    
    CGRect txtFieldDetailFrame = self.txtFieldDetails.frame;
    txtFieldDetailFrame.origin.y = self.lblPosted.frame.origin.y+self.lblPosted.frame.size.height+5;
   
    txtFieldDetailFrame.size.height = (CurrentDeviceBound.size.height-txtFieldDetailFrame.origin.y-15);
    self.txtFieldDetails.frame = txtFieldDetailFrame;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
