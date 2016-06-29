//
//  LeftMenuViewController.h
//  DGTU
//
//  Created by Anton Pavlov on 01.03.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface LeftMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) BOOL slideOutAnimationEnabled;

@end
