//
//  TableViewFav.h
//  DGTU
//
//  Created by Anton Pavlov on 16.02.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DataManager.h"
#import "Favorites+CoreDataProperties.h"
#import "SlideNavigationController.h"

@interface TableViewFav : UITableViewController <NSFetchedResultsControllerDelegate ,SlideNavigationControllerDelegate >

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
