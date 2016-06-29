//
//  ViewControllerPageTeacher.h
//  DGTU
//
//  Created by Anton Pavlov on 25.03.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewPageContTeacher.h"

@interface ViewControllerPageTeacher : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;

@property(strong,nonatomic) NSString *graph;
@property(strong,nonatomic) NSString *tableTime;
@property(strong,nonatomic) NSString *reference;
@end
