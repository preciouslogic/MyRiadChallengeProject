//
//  SignUpViewController.m
//  ChallengeProject
//
//  Created by Faizan on 4/30/14.
//  Copyright (c) 2014 MYRIAD. All rights reserved.
//

#import "SignUpViewController.h"
#import "CommonMethods.h"
#import "SVProgressHUD.h"
#import "QuestViewController.h"
@interface SignUpViewController ()

@end

@implementation SignUpViewController

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
-(void)viewWillAppear:(BOOL)animated
{
    [UserHandler sharedInstance].delegate = self;
    [self setViewAccordingToOrientations];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)AlignmentAction:(id)sender
{
    
}

- (IBAction)signUpAction:(id)sender
{
    if([CommonMethods countStringLength:self.txtFieldUsername.text].length>0 && [CommonMethods countStringLength:self.txtFieldPassword.text].length>0 && [CommonMethods countStringLength:self.txtFieldName.text].length>0 )
    {
         
         [[UserHandler sharedInstance] signUp:self.txtFieldUsername.text password:self.txtFieldPassword.text Name:self.txtFieldName.text alignmenttype:self.segmentControllerAlignment.selectedSegmentIndex];
    }
    else if([CommonMethods countStringLength:self.txtFieldUsername.text].length<=0)
    {
        [SVProgressHUD showErrorWithStatus:@"Username field can't be empty"];
    }
    else if([CommonMethods countStringLength:self.txtFieldUsername.text].length<=0)
    {
        [SVProgressHUD showErrorWithStatus:@"Password field can't be empty"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"Name field can't be empty"];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"QuestViewController"])
    {
        UINavigationController *objNav = segue.destinationViewController;
        QuestViewController *objQuest = [objNav.viewControllers objectAtIndex:0];
        objQuest.isSignUpCall = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)setViewAccordingToOrientations
{
    UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
    
    [self.view endEditing:YES];
    if (orientation==UIInterfaceOrientationPortrait)
    {
        self.txtFieldUsername.frame = CGRectMake(25, 239, 270, 30);
        self.txtFieldPassword.frame = CGRectMake(25, 277, 270, 30);
        self.txtFieldName.frame = CGRectMake(25, 260, 270, 30);
        self.imgUser.frame = CGRectMake(100, 81, 120, 120);
        self.segmentControllerAlignment.frame = CGRectMake(25, 410, 270, 29);
        self.btnSignUp.frame = CGRectMake(0, 461, 320, 30);
    }
    else if (orientation==UIInterfaceOrientationLandscapeLeft || orientation==UIInterfaceOrientationLandscapeRight)
    {
        self.txtFieldUsername.frame = CGRectMake(177, 88, 270, 30);
        self.txtFieldPassword.frame = CGRectMake(177, 127, 270, 30);
        self.txtFieldName.frame = CGRectMake(177, 180, 270, 30);
        self.imgUser.frame = CGRectMake(20, 82, 120, 120);
        self.btnSignUp.frame = CGRectMake(149, 260, 320, 30);
        self.segmentControllerAlignment.frame = CGRectMake(177, 220, 270, 29);
    }
}
- (BOOL)shouldAutorotate {
    
    [self setViewAccordingToOrientations];
    
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark TextFieldDelegates
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag != 101 && textField.tag !=102)
    {
        [CommonMethods onTextFieldBeingEditing:textField forView:self.view isTextField:YES];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag != 101 && textField.tag !=102)
    {
        [CommonMethods onEndingOfTextEditing:textField forView:self.view isTextField:YES];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == 101)
    {
        [self.txtFieldPassword becomeFirstResponder];
    }
    else if(textField.tag == 102)
    {
        [self.txtFieldName becomeFirstResponder];
        
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}
#pragma mark UserHandlerDelegates
-(void)signUpDone:(BOOL)status
{
    
    if (status)
    {
        [self performSegueWithIdentifier:@"QuestViewController" sender:Nil];
    }
}
@end
