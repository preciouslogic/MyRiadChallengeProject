//
//  LoginViewController.h
//  ChallengeProject
//
//  Created by Faizan on 4/26/14.
//  Copyright (c) 2014 MYRIAD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserHandler.h"
@interface LoginViewController : UIViewController<UserHandlerDelegate,UITextFieldDelegate>
{
}

@property (weak, nonatomic) IBOutlet UITextField *txtFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
- (IBAction)loginAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblRememberUsername;
@property (weak, nonatomic) IBOutlet UISwitch *switchRememberUsername;
@end
