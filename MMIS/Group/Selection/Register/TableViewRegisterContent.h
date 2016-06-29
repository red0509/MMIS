//
//  TableViewRegisterContent.h
//  DGTU
//
//  Created by Anton Pavlov on 26.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewRegisterContent : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property NSUInteger pageIndex;
@property NSInteger count;
@property NSString *titleText;
@property NSString *referenceContent;

@property (strong, nonatomic) NSArray *arrayPage;
@property (strong,nonatomic) NSString *referenceUniversity;
@property (strong, nonatomic) IBOutlet UIView *viewSeg;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmented;
- (IBAction)actionSegmented:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
