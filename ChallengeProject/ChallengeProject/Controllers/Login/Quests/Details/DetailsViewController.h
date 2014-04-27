//
//  DetailsViewController.h
//  ChallengeProject
//
//  Created by Faizan on 4/26/14.
//  Copyright (c) 2014 MYRIAD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quest.h"
@interface DetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *txtFieldHeading;
@property (weak, nonatomic) IBOutlet UILabel *lblPosted;
@property (weak, nonatomic) IBOutlet UITextView *txtFieldDetails;
@property (nonatomic,strong)Quest *objQuest;
@end
