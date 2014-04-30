//
//  SignUpViewController.h
//  ChallengeProject
//
//  Created by Faizan on 4/30/14.
//  Copyright (c) 2014 MYRIAD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserHandler.h"


@interface SignUpViewController : UIViewController<UserHandlerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldName;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControllerAlignment;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak,nonatomic)IBOutlet UIImageView *imgUser;

- (IBAction)AlignmentAction:(id)sender;
- (IBAction)signUpAction:(id)sender;

@end
