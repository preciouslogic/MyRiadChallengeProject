//
//  DetailsViewController.h
//  ChallengeProject
//
//  Created by Faizan on 4/26/14.
//  Copyright (c) 2014 MYRIAD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "QuestHandler.h"
#import "AsyncImageView.h"

@interface DetailsViewController : UIViewController<QuestHandlerDelegate>
{
     QuestHandler *objQuestHandler;
}
@property (weak, nonatomic) IBOutlet UITextView *txtFieldHeading;
@property (weak, nonatomic) IBOutlet UILabel *lblPosted;
@property (weak, nonatomic) IBOutlet UITextView *txtFieldDetails;
@property (nonatomic,strong)Quest *objQuest;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentMapType;
@property (weak, nonatomic) IBOutlet UIButton *btnAccepted;
@property (weak, nonatomic) IBOutlet MKMapView *mapLocation;
- (IBAction)MapTypeChangeAction:(id)sender;
- (IBAction)acceptedAction:(id)sender;
@property (weak, nonatomic) IBOutlet AsyncImageView *imgViewQuest;
@end
