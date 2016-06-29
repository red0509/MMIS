//
//  DateManager.h
//  DGTU
//
//  Created by Anton Pavlov on 14.02.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Favorites+CoreDataProperties.h"

@interface DataManager : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (DataManager*) sharedManager;
@end
