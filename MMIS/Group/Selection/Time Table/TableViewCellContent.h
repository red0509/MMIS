//
//  TableViewCellContent.h
//  DGTU
//
//  Created by Anton Pavlov on 24.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCellContent : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (weak, nonatomic) IBOutlet UILabel *room;
@property (weak, nonatomic) IBOutlet UILabel *teacher;

@end
