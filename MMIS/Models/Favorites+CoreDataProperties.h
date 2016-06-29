//
//  Favorites+CoreDataProperties.h
//  DGTU
//
//  Created by Anton Pavlov on 15.05.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Favorites.h"

NS_ASSUME_NONNULL_BEGIN

@interface Favorites (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *graph;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *semester;
@property (nullable, nonatomic, retain) NSString *tableTime;
@property (nullable, nonatomic, retain) NSNumber *university;
@property (nullable, nonatomic, retain) NSNumber *positionCount;

@end

NS_ASSUME_NONNULL_END
