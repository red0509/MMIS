//
//  TableViewGraphFav.h
//  DGTU
//
//  Created by Anton Pavlov on 15.02.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HTMLReader.h>

@interface TableViewGraphFav : UITableViewController

@property(strong,nonatomic) NSNumber *university;

-(void) loadGraph:(NSString*) str sem:(NSString*) sem;
-(void) loadGraph1:(NSString*) str;


@end
