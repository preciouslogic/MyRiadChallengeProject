//
//  QuestCell.h
//  ChallengeProject
//
//  Created by Faizan on 4/26/14.
//  Copyright (c) 2014 MYRIAD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblQuestHeading;
@property (weak, nonatomic) IBOutlet UILabel *lblPostedBy;
@property (weak, nonatomic) IBOutlet UILabel *lblRewards;

@end
