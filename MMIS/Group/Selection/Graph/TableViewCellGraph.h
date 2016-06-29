//
//  TableViewCellGraph.h
//  DGTU
//
//  Created by Anton Pavlov on 29.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCellGraph : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *disLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *PredLabel;
@property (weak, nonatomic) IBOutlet UILabel *cabLabel;

@property (weak, nonatomic) IBOutlet UILabel *subLabel1;
@property (weak, nonatomic) IBOutlet UILabel *techLabel1;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel1;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel1;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel1;
@property (weak, nonatomic) IBOutlet UILabel *roomLabel1;

@end
