//
//  StatisKafTableView.h
//  MMIS
//
//  Created by Anton Pavlov on 01.07.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisKafTableView : UITableViewController

@property (strong,nonatomic) NSString *noKT;
@property (strong,nonatomic) NSString *noRating;
@property (strong,nonatomic) NSString *noClosed;
@property (strong,nonatomic) NSString *empty;

@property (strong,nonatomic) NSString *noKTRef;
@property (strong,nonatomic) NSString *noRatingRef;
@property (strong,nonatomic) NSString *noClosedRef;
@property (strong,nonatomic) NSString *emptyRef;

@end
