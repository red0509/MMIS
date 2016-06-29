//
//  TableViewControllerFav.h
//  DGTU
//
//  Created by Anton Pavlov on 14.02.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HTMLReader.h>

@interface TableViewControllerSelFav : UITableViewController
@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSString *graph;
@property(strong,nonatomic) NSString *tableTime;
@property(strong,nonatomic) NSString *semester;
@property(strong,nonatomic) NSNumber *university;

@end
