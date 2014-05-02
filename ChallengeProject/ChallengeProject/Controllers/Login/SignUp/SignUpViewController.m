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
- (IBAction)imageTapAction:(id)sender
{
    if(!selectedImage)
    {
        [self callActionSheet];
    }
    else
    {
        UIActionSheet *popupMenu = [[UIActionSheet alloc] initWithTitle:@"Select Option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Change Photo", @"Remove Photo", nil];
        popupMenu.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        popupMenu.tag = 101;
        [popupMenu showInView:self.view];
    }
}

- (IBAction)signUpAction:(id)sender
{
    if([CommonMethods countStringLength:self.txtFieldUsername.text].length>0 && [CommonMethods countStringLength:self.txtFieldPassword.text].length>0 && [CommonMethods countStringLength:self.txtFieldName.text].length>0 )
    {
        [self.view endEditing:YES];
         [[UserHandler sharedInstance] signUp:self.txtFieldUsername.text password:self.txtFieldPassword.text Name:self.txtFieldName.text alignmenttype:self.segmentControllerAlignment.selectedSegmentIndex image:selectedImage];
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
        self.txtFieldName.frame = CGRectMake(25, 360, 270, 30);
        self.imgUser.frame = CGRectMake(100, 81, 120, 120);
        self.segmentControllerAlignment.frame = CGRectMake(25, 410, 270, 29);
        self.btnSignUp.frame = CGRectMake(0, 461, 320, 30);
    }
    else if (orientation==UIInterfaceOrientationLandscapeLeft || orientation==UIInterfaceOrientationLandscapeRight)
    {
        float txtFieldsXPos = 177;
        
        float imgUserXPos = 20;
        float btnSignUpXPos = 150;
//        if(g_IS_IPHONE_4_SCREEN)
//        {
////             txtFieldsXPos = 100;
////             imgUserXPos = 120;
//             btnSignUpXPos = 150;
//            
//        }
       
        self.txtFieldUsername.frame = CGRectMake(txtFieldsXPos, 88, 270, 30);
        self.txtFieldPassword.frame = CGRectMake(txtFieldsXPos, 127, 270, 30);
        self.txtFieldName.frame = CGRectMake(txtFieldsXPos, 180, 270, 30);
        self.imgUser.frame = CGRectMake(imgUserXPos, 90, 120, 120);
        self.btnSignUp.frame = CGRectMake(btnSignUpXPos, 260, 320, 30);
        self.segmentControllerAlignment.frame = CGRectMake(txtFieldsXPos, 220, 270, 29);
    }
    self.btnImageTap.frame = self.imgUser.frame;
}
- (BOOL)shouldAutorotate {
    
    [self setViewAccordingToOrientations];
    
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark helpingMethods
-(void)callActionSheet
{
    UIActionSheet *popupMenu = [[UIActionSheet alloc] initWithTitle:@"Image Selection" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose from Gallary", nil];
    popupMenu.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupMenu showInView:self.view];
}
#pragma mark ActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(actionSheet.tag == 101)
    {
        if (buttonIndex == 0) {
            
            [self callActionSheet];
        }
        else if (buttonIndex == 1)
        {
            
            selectedImage = Nil;
            self.imgUser.image = [UIImage imageNamed:placeHolderImage];
            
        }
    }
    else
    {
        if (buttonIndex == 0) {
            
            NSLog(@"Take Photo");
            [CommonMethods takePhoto:self];
        }
        else if (buttonIndex == 1) {
            
            NSLog( @"Gallary Choose");
            [CommonMethods selectPhoto:self];
            
        }
        else if (buttonIndex == 2) {
            
            NSLog( @"Cancel Button Clicked");
            
        }
 
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.imgUser.image = selectedImage;
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
        
    }];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
        
    }];

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
