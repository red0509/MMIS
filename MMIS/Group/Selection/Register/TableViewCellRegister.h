//
//  TableViewCellRegister.h
//  DGTU
//
//  Created by Anton Pavlov on 27.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCellRegister : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lecLabel;
@property (weak, nonatomic) IBOutlet UILabel *praLabel;
@property (weak, nonatomic) IBOutlet UILabel *labLabel;
@property (weak, nonatomic) IBOutlet UILabel *drLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameExamLabel;
@property (weak, nonatomic) IBOutlet UILabel *examLabel;
@property (weak, nonatomic) IBOutlet UILabel *examNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *project;

@property (weak, nonatomic) IBOutlet UILabel *NamePra;
@property (weak, nonatomic) IBOutlet UILabel *numPra;

@end
