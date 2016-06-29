//
//  TabBarTeacher.m
//  DGTU
//
//  Created by Anton Pavlov on 09.04.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TabBarTeacher.h"
#import "DataManager.h"
#import "Favorites+CoreDataProperties.h"
#import <HTMLReader.h>
#import "TableViewControllerClamping.h"
#import "TableViewPageContTeacher.h"
#import "SVProgressHUD.h"



@interface TabBarTeacher ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation TabBarTeacher

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action)];
    TableViewControllerClamping *clamping = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewControllerClamping"];
    clamping.reference = self.reference;
    TableViewPageContTeacher *teacher = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewPageContTeacher"];
    teacher.reference = self.reference;
    
    teacher.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Расписание занятий" image:[UIImage imageNamed:@"agenda"] tag:1];
    
    clamping.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Фиксированные занятия" image:[UIImage imageNamed:@"note"] tag:2];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    if([self.graph isEqualToString:@"teacher"]){
        self.title = self.name;
        clamping.graph = self.graph;
        clamping.tableTime = self.tableTime;
        teacher.graph = self.graph;
        teacher.tableTime = self.tableTime;
    }else{
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        self.title = self.surname;
    }
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavBar.png"]]];
    
    [self setViewControllers:@[teacher,clamping]];

}
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) action{
    
    UIAlertController *alert= [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Отмена"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    UIAlertAction* addAction = [UIAlertAction actionWithTitle:@"Добавить в избранное"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [self addFavorites];
                                                      }];
    [alert addAction:addAction];
    [alert addAction:cancelAction];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
    
}


- (NSManagedObjectContext*) managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [[DataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
}



-(void) addFavorites{
    

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *URLTeacher = [NSURL URLWithString:self.reference];
        NSLog(@"%@",self.reference);
        NSError *errorData = nil;
        NSData *dataTeacher = [[NSData alloc]initWithContentsOfURL:URLTeacher options:NSDataReadingUncached error:&errorData];
        
//        NSString *contentType = @"text/html; charset=windows-1251";
        NSString *contentType = @"text/html; charset=utf-8";

        dispatch_async(dispatch_get_main_queue(), ^{
            if (errorData != nil) {
                NSLog(@"error %@", [errorData localizedDescription]);
                
            } else {
                
                HTMLDocument *homeTeacher = [HTMLDocument documentWithData:dataTeacher
                                                      contentTypeHeader:contentType];
                
                DataManager *data = [[DataManager alloc]init];
                Favorites* favorites =
                [NSEntityDescription insertNewObjectForEntityForName:@"Favorites"
                                              inManagedObjectContext:data.managedObjectContext];
                
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                NSInteger numberDefaults = [defaults integerForKey:@"number"];
                NSNumber *universityNum = [[NSNumber alloc]initWithInteger:numberDefaults];

                NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Favorites"];
                NSError *errorCount = nil;
                NSUInteger position = [self.managedObjectContext countForFetchRequest:fetchRequest error:&errorCount];
                NSNumber *count = [[NSNumber alloc]initWithUnsignedInteger:position];
                
                NSString *teacher= homeTeacher.serializedFragment;
                favorites.name = self.surname;
                favorites.tableTime = teacher;
                favorites.graph = @"teacher";
                favorites.semester = @"teacher";
                favorites.university = universityNum;
                favorites.positionCount = count;
                
                NSError* error = nil;
                if (![data.managedObjectContext save:&error]) {
                    NSLog(@"%@", [error localizedDescription]);
                }
                
                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
                [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
                [SVProgressHUD showSuccessWithStatus:@"Добавлено в избранное!"];
                
            }
        });
    });
}

@end
