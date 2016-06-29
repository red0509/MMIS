//
//  TableViewControllerGroup.m
//  DGTU
//
//  Created by Anton Pavlov on 27.12.15.
//  Copyright © 2015 Anton Pavlov. All rights reserved.
//

#import "TableViewControllerGroup.h"
#import "ViewController.h"
#import "LeftMenuViewController.h"





@interface TableViewControllerGroup ()

@property (strong,nonatomic) NSMutableArray *EFfacul;
@property (strong,nonatomic) NSMutableArray *EFfaculReferences;


@property (strong,nonatomic) UISearchController *resultSearchController ;

@end

@implementation TableViewControllerGroup



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleName;
    self.searchResult = [NSMutableArray arrayWithCapacity:[self.EFfacul count]];
    self.resultSearchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.resultSearchController.searchResultsUpdater = self;
    self.resultSearchController.dimsBackgroundDuringPresentation = NO;
    self.resultSearchController.searchBar.placeholder = @"Поиск";
    self.resultSearchController.searchBar.tintColor = [UIColor whiteColor];
    [self.resultSearchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.resultSearchController.searchBar;
    self.definesPresentationContext = YES;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
}


- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

-(void) loadGroup: (NSString*) URLFacul{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.EFfacul= [NSMutableArray array];
        self.EFfaculReferences= [NSMutableArray array];
        NSURL *URL = [NSURL URLWithString:URLFacul];
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
                                                                              style:UIAlertActionStyleDefault
                                                                            handler:^(UIAlertAction * action) {
                                                                                [self.navigationController popViewControllerAnimated:YES];
                                                                            }];

                      UIAlertAction* repeatAction = [UIAlertAction actionWithTitle:@"Повторить"
                                                                             style:UIAlertActionStyleDefault
                                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                                               [self loadGroup:URLFacul];
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
                  
                  HTMLElement *div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucGroups_Grid > tbody > tr:nth-child(%ld) > td:nth-child(1) > a",(long)numFacul]];
                  
                  while (!(div == nil)) {
                      
                      div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucGroups_Grid > tbody > tr:nth-child(%ld) > td:nth-child(1) > a",(long)numFacul]];
                      
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if (div != nil) {
                              [self.EFfacul addObject:div.textContent];
                              [self.EFfaculReferences addObject:div.attributes.allValues.lastObject];
                              [self.tableView reloadData ];
                              
                          }
                      });
                      
                      numFacul++;
                      
                  }
              }
          }] resume];
    });
}


-(void)dealloc {
    [self.resultSearchController.view removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDatasource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.resultSearchController.active)
    {
        return [self.searchResult count];
    }
    else
    {
        return [self.EFfacul count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    
    if (self.resultSearchController.active)
    {
        cell.textLabel.text = [self.searchResult objectAtIndex:indexPath.row];
    }
    else
    {
        cell.textLabel.text = self.EFfacul[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewControllerSelection *tableViewControllerSelection = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewControllerSelection"];
    
    if (self.resultSearchController.active)
    {
        tableViewControllerSelection.group = self.searchResult[indexPath.row];
        
        for (int i = 0; i < [self.EFfacul count]; i++) {
            if ([self.EFfacul[i] isEqualToString:self.searchResult[indexPath.row]]) {
                tableViewControllerSelection.reference = self.EFfaculReferences[i];
                tableViewControllerSelection.referenceUniversity = self.referenceUniversity;
                
            }
        }
    }
    else
    {
        tableViewControllerSelection.group = self.EFfacul[indexPath.row];
        tableViewControllerSelection.reference = self.EFfaculReferences[indexPath.row];
        tableViewControllerSelection.referenceUniversity = self.referenceUniversity;

    }
    
    [self.navigationController pushViewController:tableViewControllerSelection animated:YES];
    
    
}


#pragma mark - UISearchResultsUpdating


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    [self.searchResult removeAllObjects];
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchController.searchBar.text];
    
    self.searchResult = [NSMutableArray arrayWithArray: [self.EFfacul filteredArrayUsingPredicate:resultPredicate]];
    [self.tableView reloadData];
    
}


@end
