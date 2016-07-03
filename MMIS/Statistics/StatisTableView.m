//
//  StatisTableView.m
//  MMIS
//
//  Created by Anton Pavlov on 01.07.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "StatisTableView.h"
#import <HTMLReader.h>
#import "LeftMenuViewController.h"
#import "SVProgressHUD.h"
#import "StatisKafTableView.h"


@interface StatisTableView ()

@property (strong, nonatomic) NSMutableArray *searchResult;
@property (strong,nonatomic) UISearchController *resultSearchController ;

@property (strong,nonatomic) NSMutableArray *nameArray;
@property (strong,nonatomic) NSMutableArray *allVedom;
@property (strong,nonatomic) NSMutableArray *noKT;
@property (strong,nonatomic) NSMutableArray *noKTRef;
@property (strong,nonatomic) NSMutableArray *noRating;
@property (strong,nonatomic) NSMutableArray *noRatingRef;
@property (strong,nonatomic) NSMutableArray *noClosed;
@property (strong,nonatomic) NSMutableArray *noClosedRef;
@property (strong,nonatomic) NSMutableArray *empty;
@property (strong,nonatomic) NSMutableArray *emptyRef;

@end

@implementation StatisTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 135.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UIImage *image = [UIImage imageNamed:@"menu-button"];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(slideMenu)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    self.title = @"Статистика";
    
    self.searchResult = [NSMutableArray arrayWithCapacity:[self.nameArray count]];
    self.resultSearchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.resultSearchController.searchResultsUpdater = self;
    self.resultSearchController.dimsBackgroundDuringPresentation = NO;
    self.resultSearchController.searchBar.placeholder = @"Поиск";
    self.resultSearchController.searchBar.tintColor = [UIColor whiteColor];
    [self.resultSearchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.resultSearchController.searchBar;
    self.definesPresentationContext = YES;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidOpen object:nil queue:nil usingBlock:^(NSNotification *note) {
        [SVProgressHUD dismiss];
    }];
    
    [self loadStat];
    
}

-(void)dealloc {
    [self.resultSearchController.view removeFromSuperview];
}

-(void) slideMenu{
    
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) loadStat{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[UIColor grayColor]];
    
    [SVProgressHUD show];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        
        NSURL *URL = [NSURL URLWithString:@"http://stud.sssu.ru/Stat/Default.aspx?mode=statkaf"];
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.timeoutIntervalForResource = 7;
        sessionConfig.timeoutIntervalForRequest = 7;
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
        [[session dataTaskWithURL:URL completionHandler:
          ^(NSData *data, NSURLResponse *response, NSError *error) {
              
              if (error != nil) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [SVProgressHUD dismiss];
                      
                      UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Не удается подключится." preferredStyle:UIAlertControllerStyleAlert];
                      
                      
                      UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Закрыть"
                                                                              style:UIAlertActionStyleCancel
                                                                            handler:^(UIAlertAction * action) {
                                                                                [self.navigationController popViewControllerAnimated:YES];
                                                                            }];
                      
                      UIAlertAction* repeatAction = [UIAlertAction actionWithTitle:@"Повторить"
                                                                             style:UIAlertActionStyleDefault
                                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                                              [self loadStat];
                                                                           }];
                      [alert addAction:defaultAction];
                      [alert addAction:repeatAction];
                      
                      
                      [self.navigationController presentViewController:alert animated:YES completion:nil];
                  });
              }else{
                  
                  NSString *contentType = nil;
                  if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                      NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
                      contentType = headers[@"Content-Type"];
                  }
                  
                  self.nameArray = [NSMutableArray array];
                  self.allVedom = [NSMutableArray array];
                  self.noKT = [NSMutableArray array];
                  self.noRating = [NSMutableArray array];
                  self.noClosed = [NSMutableArray array];
                  self.empty = [NSMutableArray array];
                  
                  self.noKTRef = [NSMutableArray array];
                  self.noRatingRef = [NSMutableArray array];
                  self.noClosedRef = [NSMutableArray array];
                  self.emptyRef = [NSMutableArray array];
                  
                  NSInteger dayNum = 2;
                  HTMLElement *div;
                  HTMLDocument *home = [HTMLDocument documentWithData:data
                                                    contentTypeHeader:contentType];
                  while (YES) {
                      div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucStatKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(2) > a",(long)dayNum]];
                      
                      if (div == nil) {
                          break;
                      }else{
                          [self.nameArray addObject:div.textContent];
                      }
                      
                      div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucStatKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(3) > a",(long)dayNum]];
                      
                      if (div == nil) {
                          [self.allVedom addObject:@" "];
                      }else{
                          [self.allVedom addObject:div.textContent];
                      }
                      
                      div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucStatKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(4) > a",(long)dayNum]];
                      
                      if (div == nil) {
                          [self.noKTRef addObject:@" "];
                          [self.noKT addObject:@" "];
                      }else{
                          [self.noKT addObject:div.textContent];
                          [self.noKTRef addObject:div.attributes.allValues.firstObject];
                      }
                      
                      div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucStatKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(5) > a",(long)dayNum]];
                      
                      if (div == nil) {
                          [self.noRatingRef addObject:@" "];
                          [self.noRating addObject:@" "];
                      }else{
                           [self.noRating addObject:div.textContent];
                          [self.noRatingRef addObject:div.attributes.allValues.firstObject];
                      }
                      
                      div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucStatKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(6) > a",(long)dayNum]];
                      
                      if (div == nil) {
                          [self.noClosedRef addObject:@" "];
                          [self.noClosed addObject:@" "];
                      }else{
                          [self.noClosed addObject:div.textContent];
                          [self.noClosedRef addObject:div.attributes.allValues.firstObject];
                      }
                      
                      div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucStatKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(7) > a",(long)dayNum]];
                      
                      if (div == nil) {
                          [self.emptyRef addObject:@" "];
                          [self.empty addObject:@" "];
                      }else{
                          [self.empty addObject:div.textContent];
                          [self.emptyRef addObject:div.attributes.allValues.firstObject];
                      }
                      
                      dayNum++;
                      
                  }
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [SVProgressHUD dismiss];
                      [self.tableView reloadData];
                  });
                  
              }
          }] resume];
    });
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.resultSearchController.active)
    {
        return [self.searchResult count];
    }
    else
    {
        return [self.nameArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] ;
    }
    
    if (self.resultSearchController.active){
        cell.textLabel.text = self.searchResult[indexPath.row];
        for (int i = 0; i < [self.nameArray count]; i++) {
            if ([self.nameArray[i] isEqualToString:self.searchResult[indexPath.row]]) {
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Всего Ведомостей: %@", self.allVedom[i]];
                
            }
        }
    }else{
        cell.textLabel.text = self.nameArray[indexPath.row];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Всего Ведомостей: %@", self.allVedom[indexPath.row]];
        
    }

    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    StatisKafTableView *katTable = [[StatisKafTableView alloc]init];
    
    if (self.resultSearchController.active)
    {
        for (int i = 0; i < [self.nameArray count]; i++) {
            if ([self.nameArray[i] isEqualToString:self.searchResult[indexPath.row]]) {
                
                katTable.noKT = self.noKT[i];
                katTable.noRating = self.noRating[i];
                katTable.noClosed = self.noClosed[i];
                katTable.empty = self.empty[i];
                
                katTable.noKTRef = self.noKTRef[i];
                katTable.noRatingRef = self.noRatingRef[i];
                katTable.noClosedRef = self.noClosedRef[i];
                katTable.emptyRef = self.emptyRef[i];
                
            }
        }
    }
    else
    {
        katTable.noKT = self.noKT[indexPath.row];
        katTable.noRating = self.noRating[indexPath.row];
        katTable.noClosed = self.noClosed[indexPath.row];
        katTable.empty = self.empty[indexPath.row];
        
        katTable.noKTRef = self.noKTRef[indexPath.row];
        katTable.noRatingRef = self.noRatingRef[indexPath.row];
        katTable.noClosedRef = self.noClosedRef[indexPath.row];
        katTable.emptyRef = self.emptyRef[indexPath.row];
        
    }
    
    [self.navigationController pushViewController:katTable animated:YES];
    
    
}

#pragma mark - UISearchResultsUpdating


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    [self.searchResult removeAllObjects];
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchController.searchBar.text];
    
    self.searchResult = [NSMutableArray arrayWithArray: [self.nameArray filteredArrayUsingPredicate:resultPredicate]];
    [self.tableView reloadData];
    
}



@end
