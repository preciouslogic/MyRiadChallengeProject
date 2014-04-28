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
    NSLog(@"%@",[CommonMethods getFromUserDefaultValueForKey:@"username"]);
    self.txtFieldUsername.text = [CommonMethods getFromUserDefaultValueForKey:@"username"];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.txtFieldPassword.text = @"";
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
        self.txtFieldUsername.frame = CGRectMake(35, 229, 250, 30);
        self.txtFieldPassword.frame = CGRectMake(35, 269, 250, 30);
        self.lblRememberUsername.frame = CGRectMake(45, 315, 183, 21);
        self.switchRememberUsername.frame = CGRectMake(236, 309, 51, 31);
        self.btnLogin.frame = CGRectMake(85, 345, 150, 30);
    }
    else if (orientation==UIInterfaceOrientationLandscapeLeft || orientation==UIInterfaceOrientationLandscapeRight)
    {
        self.txtFieldUsername.frame = CGRectMake(159, 113, 250, 30);
        self.txtFieldPassword.frame = CGRectMake(159, 153, 250, 30);
        self.lblRememberUsername.frame = CGRectMake(185, 198, 183, 21);
        self.switchRememberUsername.frame = CGRectMake(340, 192, 51, 31);
        self.btnLogin.frame = CGRectMake(209, 240, 150, 30);
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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
        if(self.switchRememberUsername.isOn)
        {
            [CommonMethods saveInUserDefaultValue:self.txtFieldUsername.text forKey:@"username"];
        }
        else
        {
            [CommonMethods removeFromUserDefaultValueForKey:@"username"];
        }
        [self performSegueWithIdentifier:@"QuestViewController" sender:nil];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"Wrong Email or Password!"];
    }
}
@end
