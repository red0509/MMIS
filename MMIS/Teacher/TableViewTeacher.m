//
//  TableViewTeacher.m
//  DGTU
//
//  Created by Anton Pavlov on 01.05.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewTeacher.h"
#import <HTMLReader.h>
#import "TabBarTeacher.h"



@interface TableViewTeacher ()

@property (strong,nonatomic) NSMutableArray *name;
@property (strong,nonatomic) NSMutableArray *ref;

@property (strong, nonatomic) NSMutableArray *searchResult;
@property (strong,nonatomic) UISearchController *resultSearchController ;

@end

@implementation TableViewTeacher

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 68.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.title = @"Преподаватели";
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    self.searchResult = [NSMutableArray arrayWithCapacity:[self.name count]];
    self.resultSearchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.resultSearchController.searchResultsUpdater = self;
    self.resultSearchController.dimsBackgroundDuringPresentation = NO;
    self.resultSearchController.searchBar.placeholder = @"Поиск";
    self.resultSearchController.searchBar.tintColor = [UIColor whiteColor];
    [self.resultSearchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.resultSearchController.searchBar;
    self.definesPresentationContext = YES;
    
    [self loadDept];

}

-(void)dealloc {
    [self.resultSearchController.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}


-(void) loadDept{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.name= [NSMutableArray array];
        self.ref= [NSMutableArray array];
        NSURL *URL = [NSURL URLWithString:self.nameSize];
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
                  
                  HTMLElement *div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_grPrep > tbody > tr:nth-child(%ld) > td > a",(long)numFacul]];
                  
                  
                  while (!(div == nil)) {
                      
                      div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_grPrep > tbody > tr:nth-child(%ld) > td > a",(long)numFacul]];
                      
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if (div != nil) {
                              
                              [self.name addObject:div.textContent];
                              [self.ref addObject:div.attributes.allValues.firstObject];
                              
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
    static NSString *identifier = @"cellTeach";
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
    
    TabBarTeacher * tabBarTeacher = [self.storyboard  instantiateViewControllerWithIdentifier:@"TabBarTeacher"];
//    tabBarTeacher.reference = [NSString stringWithFormat:@"http://stud.sssu.ru/Rasp/%@",[self.ref[indexPath.row] stringByAddingPercentEscapesUsingEncoding:NSWindowsCP1251StringEncoding]];
    
    NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
    
    if (self.resultSearchController.active)
    {
        tabBarTeacher.surname = self.searchResult[indexPath.row];
        
        for (int i = 0; i < [self.name count]; i++) {
            if ([self.name[i] isEqualToString:self.searchResult[indexPath.row]]) {
                tabBarTeacher.reference = [NSString stringWithFormat:@"http://stud.sssu.ru/Rasp/%@",[self.ref[i]    stringByAddingPercentEncodingWithAllowedCharacters:set]];
                
            }
        }
    }
    else
    {
        tabBarTeacher.reference = [NSString stringWithFormat:@"http://stud.sssu.ru/Rasp/%@",[self.ref[indexPath.row]    stringByAddingPercentEncodingWithAllowedCharacters:set]];
        tabBarTeacher.surname = self.name[indexPath.row];
        
    }


    [self.navigationController pushViewController:tabBarTeacher animated:YES];
}


#pragma mark - UISearchResultsUpdating


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    [self.searchResult removeAllObjects];
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchController.searchBar.text];
    
    self.searchResult = [NSMutableArray arrayWithArray: [self.name filteredArrayUsingPredicate:resultPredicate]];
    [self.tableView reloadData];
    
}
@end
