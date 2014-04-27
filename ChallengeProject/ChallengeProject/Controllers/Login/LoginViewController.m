//
//  LoginViewController.m
//  ChallengeProject
//
//  Created by Faizan on 4/26/14.
//  Copyright (c) 2014 MYRIAD. All rights reserved.
//

#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "CommonMethods.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotate {
    
    UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
    
    [self.view endEditing:YES];
    if (orientation==UIInterfaceOrientationPortrait)
    {
        self.txtFieldUsername.frame = CGRectMake(35, 238, 250, 30);
        self.txtFieldPassword.frame = CGRectMake(35, 280, 250, 30);
        self.btnLogin.frame = CGRectMake(85, 320, 150, 30);
    }
    else if (orientation==UIInterfaceOrientationLandscapeLeft || orientation==UIInterfaceOrientationLandscapeRight)
    {
        self.txtFieldUsername.frame = CGRectMake(159, 133, 250, 30);
        self.txtFieldPassword.frame = CGRectMake(159, 173, 250, 30);
        self.btnLogin.frame = CGRectMake(209, 208, 150, 30);
    }
    
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if (interfaceOrientation==UIInterfaceOrientationPortrait) {
        // do some sh!t
        
    }
    
    return YES;
}
- (IBAction)loginAction:(id)sender
{
    [self.view endEditing:YES];
    if([CommonMethods countStringLength:self.txtFieldUsername.text]>0 && self.txtFieldPassword.text.length>0)
    {
        [UserHandler sharedInstance].delegate = self;
        [[UserHandler sharedInstance] login:self.txtFieldUsername.text password:self.txtFieldPassword.text];
    }
    else if (self.txtFieldUsername.text.length<=0)
    {
        [SVProgressHUD showErrorWithStatus:@"Username field can't be empty"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"Password field can't be empty"];
    }
}
#pragma mark TextFieldDelegates 
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [CommonMethods onTextFieldBeingEditing:textField forView:self.view isTextField:YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [CommonMethods onEndingOfTextEditing:textField forView:self.view isTextField:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == 101)
    {
        [self.txtFieldPassword becomeFirstResponder];
    }
    else
    {
         [self loginAction:nil];
         [textField resignFirstResponder];
    }
    return YES;
}
#pragma mark UserHandlerDelegates
-(void)loginDone:(BOOL)status
{
    
    if(status)
    {
        [self performSegueWithIdentifier:@"QuestViewController" sender:nil];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"Wrong Email or Password!"];
    }
}
@end
