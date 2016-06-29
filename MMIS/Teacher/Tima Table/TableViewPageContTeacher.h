//
//  TableViewPageContTeacher.h
//  DGTU
//
//  Created by Anton Pavlov on 25.03.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HTMLReader.h>


@interface TableViewPageContTeacher : UIViewController <UITableViewDataSource , UITableViewDelegate>

@property NSUInteger pageIndex;
@property NSString *titleText;

@property(strong,nonatomic) NSString *graph;
@property(strong,nonatomic) NSString *tableTime;
@property(strong,nonatomic) NSString *reference;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *viewSeg;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmented;
- (IBAction)actionSegmented:(id)sender;
@end
