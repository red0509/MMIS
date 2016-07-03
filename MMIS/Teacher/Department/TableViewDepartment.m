//
//  TableViewDepartment.m
//  DGTU
//
//  Created by Anton Pavlov on 01.05.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewDepartment.h"
#import <HTMLReader.h>
#import "TableViewTeacher.h"
#import "LeftMenuViewController.h"


@interface TableViewDepartment ()

@property (strong,nonatomic) NSMutableArray *name;
@property (strong,nonatomic) NSMutableArray *ref;

@property (strong, nonatomic) NSMutableArray *searchResult;
@property (strong,nonatomic) UISearchController *resultSearchController ;
@end

@implementation TableViewDepartment

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 68.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.title = @"Кафедры";
    [SlideNavigationController sharedInstance].leftBarButtonItem = self.navigationItem.leftBarButtonItem;
    [SlideNavigationController sharedInstance].enableSwipeGesture = YES;
    
    [self loadDept];
    
    UIImage *image = [UIImage imageNamed:@"menu-button"];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(slideMenu)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    self.searchResult = [NSMutableArray arrayWithCapacity:[self.name count]];
    self.resultSearchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.resultSearchController.searchResultsUpdater = self;
    self.resultSearchController.dimsBackgroundDuringPresentation = NO;
    self.resultSearchController.searchBar.placeholder = @"Поиск";
    self.resultSearchController.searchBar.tintColor = [UIColor whiteColor];
    [self.resultSearchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.resultSearchController.searchBar;
    self.definesPresentationContext = YES;
}

-(void) slideMenu{
    
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
}

-(void)dealloc {
    [self.resultSearchController.view removeFromSuperview];
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) loadDept{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.name= [NSMutableArray array];
        self.ref= [NSMutableArray array];
        NSURL *URL = [NSURL URLWithString:@"http://stud.sssu.ru/Dek/Default.aspx?mode=kaf"];
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.timeoutIntervalForResource = 7;
        sessionConfig.timeoutIntervalForRequest = 7;
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
        [[session dataTaskWithURL:URL completionHandler:
          ^(NSData *data, NSURLResponse *response, NSError *error) {
              
              if (error != nil) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Не удается подключится." preferredStyle:UIAlertControllerStyleAlert];
                      
                      UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Закрыть"
                                                                              style:UIAlertActionStyleCancel
                                                                            handler:^(UIAlertAction * action) {
                                                                                [self.navigationController popViewControllerAnimated:YES];
                                                                            }];
                      
                      UIAlertAction* repeatAction = [UIAlertAction actionWithTitle:@"Повторить"
                                                                             style:UIAlertActionStyleDefault
                                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                                               [self loadDept];
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
                  
                  HTMLDocument *home = [HTMLDocument documentWithData:data
                                                    contentTypeHeader:contentType];
                  NSInteger numFacul = 2;
                  
                  HTMLElement *div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(1) > a",(long)numFacul]];
                  HTMLElement *ref;
                                    
                  while (!(div == nil)) {
                      
                      div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(1) > a",(long)numFacul]];
                      ref = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(2) > a",(long)numFacul]];
                     
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if (div != nil) {
                              
                              [self.name addObject:div.textContent];
                              [self.ref addObject:ref.attributes.allValues.firstObject];

                              [self.tableView reloadData];
                          }
                      });
                      
                      numFacul++;
                      
                  }
                }
          }] resume];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.resultSearchController.active)
    {
        return [self.searchResult count];
    }
    else
    {
        return [self.name count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellDepTeach";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (self.resultSearchController.active)
    {
        cell.textLabel.text = [self.searchResult objectAtIndex:indexPath.row];
    }
    else
    {
        cell.textLabel.text = self.name[indexPath.row];
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableViewTeacher * tableViewTeacher = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewTeacher"];
    
    if (self.resultSearchController.active)
    {
        for (int i = 0; i < [self.name count]; i++) {
            if ([self.name[i] isEqualToString:self.searchResult[indexPath.row]]) {

                tableViewTeacher.nameSize = [NSString stringWithFormat:@"http://stud.sssu.ru%@",self.ref[i]];
                 NSLog(@"%@",self.name[i]);
            }
        }
       
    }
    else
    {
        tableViewTeacher.nameSize = [NSString stringWithFormat:@"http://stud.sssu.ru%@",self.ref[indexPath.row]];
        NSLog(@"%@",self.name[indexPath.row]);
    }
    [self.navigationController pushViewController:tableViewTeacher animated:YES];
    
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    [self.searchResult removeAllObjects];
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchController.searchBar.text];
    
    self.searchResult = [NSMutableArray arrayWithArray: [self.name filteredArrayUsingPredicate:resultPredicate]];
    [self.tableView reloadData];
    
}

@end
