//
//  TableViewPageContFav.h
//  DGTU
//
//  Created by Anton Pavlov on 15.02.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HTMLReader.h>


@interface TableViewPageContFav : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmented;
@property (strong, nonatomic) IBOutlet UIView *viewSeg;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *timeTable;
@property (strong, nonatomic) NSNumber *university;

- (IBAction)ActionSegmented:(id)sender;
@end
