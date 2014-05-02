//
//  CommonMethods.h
//
//  Created by Faizan Ali on 25/04/2014.
//  Copyright (c) 2014. All rights reserved.
//

#import "CommonMethods.h"


#define KEYBOARD_ANIMATION_DURATION  0.3
#define MINIMUM_SCROLL_FRACTION  0.2
#define MAXIMUM_SCROLL_FRACTION  0.8
#define PORTRAIT_KEYBOARD_HEIGHT  216
#define PORTRAIT_SPECIAL_KEYBOARD_HEIGHT  130
#define LANDSCAPE_KEYBOARD_HEIGHT  150


@implementation CommonMethods

+(NSString*)plistPath:(NSString *)plistName
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",plistName]];
    return finalPath;
}
+(void)showAlertView:(NSString*)title Message:(NSString*)msg
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
}
+(void)ShowShareActionSheet:(id)delegate inView:(UIView*)view
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:delegate cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Email", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.alpha=0.90;
    actionSheet.tag = 1;
    [actionSheet showInView:view];
}
+(void)saveInUserDefaultValue:(id)value forKey:(NSString*)key
{
    NSUserDefaults *prefs=[NSUserDefaults  standardUserDefaults];
   
    [prefs setObject:value forKey:key];
    [prefs synchronize];

}
+(id)getFromUserDefaultValueForKey:(NSString*)key
{
    NSUserDefaults *prefs=[NSUserDefaults  standardUserDefaults];
    
    return  [prefs valueForKey:key];
}
+(void)removeFromUserDefaultValueForKey:(NSString*)key
{
    NSUserDefaults *prefs=[NSUserDefaults  standardUserDefaults];
    
     [prefs removeObjectForKey:key];
     [prefs synchronize];
}
+(BOOL)containString:(NSString*)str inText:(NSString*)text
{
    NSRange range = [text rangeOfString:str];
    
    if (range.length > 0){
        return YES;
    }
    else {
        return NO;
    }
}

+(void)onTextFieldBeingEditing:(id)sender forView:(UIView*)view isTextField:(BOOL)isTextField
{
    
    CGRect viewFrame = view.frame;
    viewFrame.origin.y -= [CommonMethods animationDistance:sender forView:view isTextField:isTextField special:NO];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
}



+(void)onEndingOfTextEditing:(id)sender forView:(UIView*)view isTextField:(BOOL)isTextField
{
    CGRect viewFrame = view.frame;
    
    
    viewFrame.origin.y += [CommonMethods animationDistance:sender forView:view isTextField:isTextField special:NO];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [view setFrame:viewFrame];
    [UIView commitAnimations];
    
}


+(float)animationDistance:(id)sender forView:(UIView*)view isTextField:(BOOL)isTextField special:(BOOL)isSpecial
{
    CGRect textFieldRect;
    if(isTextField)
    {
        UITextField *textField =(UITextField*)sender;
        textFieldRect = [view.window convertRect:textField.bounds fromView:textField];
        
    }
    else
    {
        UITextView *objTextView =(UITextView*)sender;
        textFieldRect = [view.window convertRect:objTextView.bounds fromView:objTextView];
    }
    
    
    CGRect viewRect = [view.window convertRect:view.bounds fromView:view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if(heightFraction < 0.0){
        
        heightFraction = 0.0;
        
    }else if(heightFraction > 1.0){
        
        heightFraction = 1.0;
    }

    float  animatedDistance;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        
        if(isSpecial)
        {
            animatedDistance = floor(PORTRAIT_SPECIAL_KEYBOARD_HEIGHT * heightFraction);
        }
        else
        {
            animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
        }
        
        
    }else{
        
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    return animatedDistance;
}


+(float)calculateTextSize:(NSString *)msgStr fontSize:(UIFont*)font
{
    CGSize size = [msgStr sizeWithFont:font
                     constrainedToSize:CGSizeMake(300, 2000)lineBreakMode:NSLineBreakByWordWrapping ];
    return size.height+10;
}
+(NSString *)countStringLength:(NSString *)str
{
    NSString *rawString = str;
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [rawString stringByTrimmingCharactersInSet:whitespace];
}
+(NSString *)getUUID
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs objectForKey:@"deviceUUID"]){
        return [prefs objectForKey:@"deviceUUID"];
    }
    
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    NSString * uuidString = (__bridge NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    CFRelease(newUniqueId);
    
    uuidString = [uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    [prefs setObject:uuidString forKey:@"deviceUUID"];
    
    return uuidString;
}

+(void)takePhoto:(id)delegate {
    
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
        
    }
    else
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = delegate;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [delegate presentViewController:picker animated:YES completion:NULL];
    }
    
}
+(void)selectPhoto:(id)delegate
{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                              message:@"Photo gallary is not available"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
        
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = delegate;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [delegate presentViewController:picker animated:YES completion:NULL];
}

@end
