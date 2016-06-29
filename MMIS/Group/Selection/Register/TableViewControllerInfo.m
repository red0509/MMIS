//
//  TableViewControllerInfo.m
//  DGTU
//
//  Created by Anton Pavlov on 31.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewControllerInfo.h"
#import <HTMLReader.h>

@interface TableViewControllerInfo ()

@property (strong,nonatomic) NSMutableArray *nameArray;
@property (strong,nonatomic) NSMutableArray *valueArray;

@end

@implementation TableViewControllerInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *university;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger numberDefaults = [defaults integerForKey:@"number"];
    if (numberDefaults == 0) {
        university = @"http://stud.sssu.ru/";
    } else if(numberDefaults == 1){
        university = @"http://umu.sibadi.org/";
    }
    [self loadInfo:
     [NSString stringWithFormat:@"%@Ved/%@",university,self.referenceInfo]];
    self.title = @"Информация";
    self.tableView.estimatedRowHeight = 68.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

-(void) loadInfo:(NSString*) URLIngo{
    self.valueArray = [NSMutableArray array];
    self.nameArray = [NSMutableArray array];
    NSURL *URL = [NSURL URLWithString:URLIngo];
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForResource = 5;
    sessionConfig.timeoutIntervalForRequest = 5;
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
                                                                           [self loadInfo:URLIngo];
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
              
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  HTMLElement *info;
                  for (NSInteger i = 2; i<7; i++) {
                      for (NSInteger j = 1; j<7; j++) {
                          if ((i==4)&&(j==1)) {
                              info = [home firstNodeMatchingSelector:@"#ucVedBox_lblSemName"];
                          }else if((i==2)&&(j==6)){
                              info = [home firstNodeMatchingSelector:@"#ucVedBox_lblKafName"];
                          }
                          else{
                              info = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblTitle > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)i,(long)j ]];
                          }
                          
                          if (info.textContent == nil) {
                              if (j%2==0) {
//                                  [self.valueArray addObject:@" "];
                              }else{
//                                  [self.nameArray addObject:@" "];
                              }
                              
                          }else{
                              if (j%2==0) {
                                  [self.valueArray addObject:info.textContent];
                              }else{
                                  [self.nameArray addObject:info.textContent];
                              }
                          }
                      }
                      
                  }
                    [self.tableView reloadData];
              });
          }
      }] resume];
}


#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.valueArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cellInfo";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    

    
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",self.nameArray[indexPath.row],self.valueArray[indexPath.row]];

    return cell;
}

@end
