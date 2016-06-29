//
//  PlanViewController.h
//  DGTU
//
//  Created by Anton Pavlov on 16.06.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UISegmentedControl *sessionSegmented;
@property (strong, nonatomic) IBOutlet UISegmentedControl *courseSegmented;
- (IBAction)actionSessionSegmented:(id)sender;
- (IBAction)actionCourseSegmented:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *viewSeg;

@property (strong, nonatomic) NSString *reference;
@property (strong, nonatomic) NSString *plan;


@end
