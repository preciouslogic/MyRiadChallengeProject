//
//  SettingViewController.h
//  ChallengeProject
//
//  Created by Faizan on 4/27/14.
//  Copyright (c) 2014 MYRIAD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@class SettingViewController;
@protocol SettingViewControllerDelegates <NSObject>

-(void)settingViewControllerDone:(NSString*)selectedType;

@end

@interface SettingViewController : UIViewController<CLLocationManagerDelegate,UITextFieldDelegate>
{
    CLLocationManager *locationManager;
}


@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControllerType;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdateLocation;
@property (weak, nonatomic) IBOutlet MKMapView *locationMap;

- (IBAction)doneAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction)UpdationLocationAction:(id)sender;

@property (nonatomic,weak)id <SettingViewControllerDelegates>delegate;

@end
