//
//  PlanTableView.m
//  DGTU
//
//  Created by Anton Pavlov on 29.06.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "PlanTableView.h"
#import <HTMLReader.h>
#import "PlanViewController.h"
#import "LeftMenuViewController.h"



@interface PlanTableView ()

@property (strong,nonatomic) NSMutableArray *nameArray;
@property (strong,nonatomic) NSMutableArray *planArray;
@property (strong,nonatomic) NSMutableArray *planRefArray;

@end

@implementation PlanTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 135.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.title = @"Учебные планы";
    
    [self loadDept];
    UIImage *image = [UIImage imageNamed:@"menu-button"];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(slideMenu)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}

-(void) slideMenu{
    
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

#pragma mark - Table view data source


-(void) loadDept{
    
    self.nameArray = [NSMutableArray array];
    self.planArray = [NSMutableArray array];
    self.planRefArray = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *URL = [NSURL URLWithString:@"http://stud.sssu.ru/Plans/Default.aspx"];
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
                 
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      NSInteger dayNum = 2;
                      HTMLElement *name;
                      HTMLElement *plan;
                      HTMLDocument *home = [HTMLDocument documentWithData:data
                                                        contentTypeHeader:contentType];
                      while (YES) {
                          name = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_Grid > tbody > tr:nth-child(%ld) > td:nth-child(2) > span",(long)dayNum]];
                          
                          if (name == nil) {
                              break;
                          }else{
                              [self.nameArray addObject:name.textContent];
                          }
                          
                          plan = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_Grid > tbody > tr:nth-child(%ld) > td:nth-child(3) > a",(long)dayNum]];

                          if (plan == nil) {
                              [self.planArray addObject:@" "];
                              [self.planRefArray addObject:@" "];
                          }else{
                              [self.planArray addObject:plan.textContent];
                              [self.planRefArray addObject:plan.attributes.allValues.firstObject];
                          }
                          
                          dayNum++;
                          [self.tableView reloadData];
                      }
                      
                      
                  });
              }
            
          }] resume];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.nameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] ;
    }
    
        
    cell.textLabel.text = self.nameArray[indexPath.row];
    cell.detailTextLabel.text = self.planArray[indexPath.row];
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];

    PlanViewController *planViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"PlanViewController"];
    
    planViewController.reference = self.planRefArray[indexPath.row];
    planViewController.plan = self.planArray[indexPath.row];
    
    [self.navigationController pushViewController:planViewController animated:YES];
}



@end
