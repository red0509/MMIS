//
//  TableViewControllerSelection.m
//  DGTU
//
//  Created by Anton Pavlov on 17.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewControllerSelection.h"
#import "TableViewControllerRegister.h"
#import "TableViewControllerGraph.h"
#import "DataManager.h"
#import "Favorites+CoreDataProperties.h"
#import "SVProgressHUD.h"



@interface TableViewControllerSelection () 

@property (strong, nonatomic) HTMLDocument* docTime;
@property (strong, nonatomic) HTMLDocument* docGraph;

@property (strong, nonatomic) NSString *docString;
@property BOOL boolRef;
@property NSMutableArray *array;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation TableViewControllerSelection

- (void)viewDidLoad {
    [super viewDidLoad];
    self.docTime = [[HTMLDocument alloc]init];
    self.docGraph = [[HTMLDocument alloc]init];
    self.title = self.group;
    self.numberGroupString = [self.reference substringFromIndex:22];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (NSManagedObjectContext*) managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [[DataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
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


-(void) addFavorites{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"M"];
    NSString * strintDate = [dateFormatter stringFromDate:date];
    NSInteger intDate = [strintDate integerValue];
    NSString *semester;
    if (intDate > 8 || intDate == 1) {
        semester =  @"1";
    }else{
        semester = @"2";
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *URLTime = [NSURL URLWithString:[NSString stringWithFormat:@"%@Rasp/Rasp.aspx?group=%@&sem=%@",self.referenceUniversity,self.numberGroupString, semester]];
        NSError *errorData = nil;
        NSData *dataTime = [[NSData alloc]initWithContentsOfURL:URLTime options:NSDataReadingUncached error:&errorData];
        
//        NSString *contentType = @"text/html; charset=windows-1251";
        NSString *contentType = @"text/html; charset=utf-8";
       
        NSURL *URLGraph = [NSURL URLWithString:[NSString stringWithFormat:@"%@Graph/Graph.aspx?group=%@&sem=%@",self.referenceUniversity,self.numberGroupString, semester]];
        NSData *dataGraph = [[NSData alloc]initWithContentsOfURL:URLGraph options:NSDataReadingUncached error:&errorData];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (errorData != nil) {
                
            } else {
                
                HTMLDocument *homeTime = [HTMLDocument documentWithData:dataTime
                                                      contentTypeHeader:contentType];
                HTMLDocument *homeTable = [HTMLDocument documentWithData:dataGraph
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
                NSString *graph= homeTable.serializedFragment;
                NSString *time= homeTime.serializedFragment;
                favorites.name = self.group;
                favorites.graph = graph;
                favorites.tableTime = time;
                favorites.semester = semester;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){//Расписание
        
        ViewControllerPageContent *viewControllerPageContent = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerPageContent"];
        viewControllerPageContent.referenceContent = self.numberGroupString;
        viewControllerPageContent.referenceUniversity = self.referenceUniversity;
        [self.navigationController pushViewController:viewControllerPageContent animated:YES];
        
    }else if(indexPath.row == 1){//Ведомость
        TableViewControllerRegister *tableViewControllerRegister = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewControllerRegister"];
        [tableViewControllerRegister loadRegister:[NSString stringWithFormat:@"%@Ved/Default.aspx?sem=cur&group=%@",self.referenceUniversity,self.numberGroupString]];
        
        tableViewControllerRegister.referenceUniversity = self.referenceUniversity;
        [self.navigationController pushViewController:tableViewControllerRegister animated:YES];
        
        
    }else if(indexPath.row == 2){//Графики
        
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        
        [dateFormatter setDateFormat:@"M"];
        NSString * strintDate = [dateFormatter stringFromDate:date];
        NSInteger intDate = [strintDate integerValue];
        NSString *semester;
        if (intDate > 8 || intDate == 1) {
            semester =  @"1";
        }else{
            semester = @"2";
        }
        TableViewControllerGraph *tableViewControllerGraph = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewControllerGraph"];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSInteger numberDefaults = [defaults integerForKey:@"number"];
        
        if (numberDefaults == 0) {
            [tableViewControllerGraph loadGraph:[NSString stringWithFormat:@"%@Graph/Graph.aspx?group=%@&sem=%@",self.referenceUniversity,self.numberGroupString, semester] sem:semester];
        }else if(numberDefaults == 1){
            [tableViewControllerGraph loadGraph1:[NSString stringWithFormat:@"%@Graph/Graph.aspx?group=%@&sem=%@",self.referenceUniversity,self.numberGroupString, semester]];
        }
        
        [self.navigationController pushViewController:tableViewControllerGraph animated:YES];
        
    }
}

@end
