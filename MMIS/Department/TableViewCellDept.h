//
//  TableViewCellDept.h
//  DGTU
//
//  Created by Anton Pavlov on 01.03.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCellDept : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelZav;
@property (weak, nonatomic) IBOutlet UILabel *labelNum;
@property (weak, nonatomic) IBOutlet UILabel *labelCab;

@end
