//
//  PlanViewCell.h
//  DGTU
//
//  Created by Anton Pavlov on 19.06.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *allTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *workLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseAndSessionLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *lecAndPracLabel;
@property (strong, nonatomic) IBOutlet UILabel *labAndKSRLabel;
@property (strong, nonatomic) IBOutlet UILabel *blocLabel;


@end
