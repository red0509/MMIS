//
//  TableViewControllerGraph.h
//  DGTU
//
//  Created by Anton Pavlov on 29.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewControllerGraph : UITableViewController

-(void) loadGraph:(NSString*) URLGroup sem:(NSString*) sem;

-(void) loadGraph1:(NSString*) URLGroup;

@end
