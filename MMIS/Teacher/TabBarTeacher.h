//
//  TabBarTeacher.h
//  DGTU
//
//  Created by Anton Pavlov on 09.04.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarTeacher : UITabBarController

@property (strong,nonatomic) NSString *surname;
@property (strong,nonatomic) NSString *reference;

@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSString *graph;
@property(strong,nonatomic) NSString *tableTime;

@end
