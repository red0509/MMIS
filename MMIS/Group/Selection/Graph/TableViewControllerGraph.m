//
//  TableViewControllerGraph.m
//  DGTU
//
//  Created by Anton Pavlov on 29.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewControllerGraph.h"
#import "TableViewCellGraph.h"
#import <HTMLReader.h>

@interface TableViewControllerGraph ()

@property (strong,nonatomic) NSMutableArray *subjectArray;
@property (strong,nonatomic) NSMutableArray *typeArray;
@property (strong,nonatomic) NSMutableArray *teacherArray;
@property (strong,nonatomic) NSMutableArray *dateArray;

@property (strong,nonatomic) NSMutableArray *ktBeginArray;
@property (strong,nonatomic) NSMutableArray *ktEndArray;
@property (strong,nonatomic) NSMutableArray *monthArray;
@property (strong,nonatomic) NSMutableArray *ktBeginArray2;
@property (strong,nonatomic) NSMutableArray *ktEndArray2;
@property (strong,nonatomic) NSMutableArray *monthArray2;

@property (assign,nonatomic) NSInteger university;

@property BOOL oneTwo;
@end

@implementation TableViewControllerGraph

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.oneTwo = NO;
    self.title = @"График";
    self.tableView.estimatedRowHeight = 68.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger numberDefaults = [defaults integerForKey:@"number"];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.university = numberDefaults;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

-(void) loadGraph:(NSString*) URLGroup sem:(NSString*) sem{
    
    self.subjectArray = [NSMutableArray array];
    self.typeArray = [NSMutableArray array];
    self.teacherArray = [NSMutableArray array];
    self.dateArray = [NSMutableArray array];
    self.ktBeginArray = [NSMutableArray array];
    self.ktEndArray = [NSMutableArray array];
    self.monthArray = [NSMutableArray array];
    self.ktBeginArray2 = [NSMutableArray array];
    self.ktEndArray2 = [NSMutableArray array];
    self.monthArray2 = [NSMutableArray array];
    
    
    NSURL *URL = [NSURL URLWithString:URLGroup];
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
                                                                           [self loadGraph:URLGroup sem:sem];
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
                  if ([sem isEqualToString:@"1"]) {
                      NSInteger num = 5;
                      while (YES) {
                          HTMLElement *subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(2)",(long)num]];
                          if (subject.textContent == nil) {
                              break;
                          }else{
                              [self.subjectArray addObject:subject.textContent];
                              num++;
                          }
                      }
                      
                      [self graphKT:num max:27 document:home];
                      
                      for (NSInteger i = 5; i<num; i++) {
                          HTMLElement *type = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(3)",(long)i]];
                          [self.typeArray addObject:type.textContent];
                          
                          HTMLElement *teacher = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(31)",(long)i]];
                          if (teacher.textContent == nil) {
                              [self.teacherArray addObject:@" "];
                          }else{
                              [self.teacherArray addObject:teacher.textContent];
                          }
                          
                          HTMLElement *date;
                          if ([self.typeArray[i-5] isEqualToString:@"Зачет"]) {
                              date = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(29)",(long)i]];
                          }else{
                              date = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(30)",(long)i]];
                          }
                          if (date.textContent == nil) {
                              [self.dateArray addObject:@" "];
                          }else{
                              [self.dateArray addObject:date.textContent];
                          }
                          [self.tableView reloadData];
                      }
                      
                  }else if([sem isEqualToString:@"2"]){
                      NSInteger num = 5;
                      while (YES) {
                          HTMLElement *subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(2)",(long)num]];
                          if (subject.textContent == nil) {
                              break;
                          }else{
                              [self.subjectArray addObject:subject.textContent];
                              num++;
                          }
                      }
                      
                      [self graphKT:num max:34 document:home];
                      
                      for (NSInteger i = 5; i<num; i++) {
                          HTMLElement *type = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(3)",(long)i]];
                          [self.typeArray addObject:type.textContent];
                          
                          HTMLElement *teacher = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(37)",(long)i]];
                          
                          if (teacher.textContent == nil) {
                              [self.teacherArray addObject:@" "];
                          }else{
                              [self.teacherArray addObject:teacher.textContent];
                          }
                          
                          HTMLElement *date;
                          if ([self.typeArray[i-5] isEqualToString:@"Зачет"]) {
                              date = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(35)",(long)i]];
                          }else{
                              date = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(36)",(long)i]];
                          }
                          if (date.textContent == nil) {
                              [self.dateArray addObject:@" "];
                          }else{
                              [self.dateArray addObject:date.textContent];
                          }
                          
                          [self.tableView reloadData];
                      }
                      
                  }
              });
          }
      }
      ] resume];
}

- (void)loadGraph1:(NSString *)URLGroup{
    
    self.subjectArray = [NSMutableArray array];
    self.typeArray = [NSMutableArray array];
    self.teacherArray = [NSMutableArray array];
    self.dateArray = [NSMutableArray array];
    self.ktBeginArray = [NSMutableArray array];
    
    NSURL *URL = [NSURL URLWithString:URLGroup];
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
                                                                           [self loadGraph1:URLGroup];
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
                  NSInteger num = 5;
                  while (YES) {
                      HTMLElement *subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(2)",(long)num]];
                      if (subject.textContent == nil) {
                          break;
                      }else{
                          [self.subjectArray addObject:subject.textContent];
                          num++;
                      }
                  }
                  for (NSInteger i = 5; i<num; i++) {
                      HTMLElement *type = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(3)",(long)i]];
                      [self.typeArray addObject:type.textContent];
                      
                      HTMLElement *teacher = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(8)",(long)i]];
                      if (teacher.textContent == nil) {
                          [self.teacherArray addObject:@" "];
                      }else{
                          [self.teacherArray addObject:teacher.textContent];
                      }
                      
                      HTMLElement *date;
                      if ([self.typeArray[i-5] isEqualToString:@"Зачет"]) {
                          date = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(6)",(long)i]];
                      }else{
                          date = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(7)",(long)i]];
                      }
                      if (date.textContent == nil) {
                          [self.dateArray addObject:@" "];
                      }else{
                          [self.dateArray addObject:date.textContent];
                      }
                      HTMLElement *hour = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(5)",(long)i]];
                      if (hour.textContent == nil) {
                          [self.ktBeginArray addObject:@" "];
                      }else{
                          [self.ktBeginArray addObject:hour.textContent];
                      }
                      
                      [self.tableView reloadData];
                  }
              });
          }
      }
      ] resume];
    
}


-(void) graphKT:(NSInteger) num max:(NSInteger) max document:(HTMLDocument*) home{
    for (NSInteger i = 5; i<num; i++) {
        for (NSInteger j = 6; j<max; j++) {
            HTMLElement *KT = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)i, (long)j]];
            if ([KT.textContent isEqualToString:@"КТ"]) {
                if (self.oneTwo == NO) {
                    HTMLElement *begin = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(2) > td:nth-child(%ld)", (long)j-5]];
                    [self.ktBeginArray addObject:begin.textContent];
                    
                    HTMLElement *end = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(3) > td:nth-child(%ld)", (long)j-5]];
                    [self.ktEndArray addObject:end.textContent];
                    
                    [self num:j-5 document:home max:max array:self.monthArray];
                    self.oneTwo = YES;
                    continue;
                }
                else if (self.oneTwo == YES) {
                    HTMLElement *begin = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(2) > td:nth-child(%ld)", (long)j-5]];
                    [self.ktBeginArray2 addObject:begin.textContent];
                    
                    HTMLElement *end = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(3) > td:nth-child(%ld)", (long)j-5]];
                    [self.ktEndArray2 addObject:end.textContent];
                    
                    [self num:j-5 document:home max:max array:self.monthArray2];
                    self.oneTwo = NO;
                    break;
                }
                
            }else if ([KT.textContent isEqualToString:@"Э"]){
                [self.ktBeginArray addObject:@" "];
                [self.ktBeginArray2 addObject:@" "];
                [self.ktEndArray addObject:@" "];
                [self.ktEndArray2 addObject:@" "];
                [self.monthArray addObject:@" "];
                [self.monthArray2 addObject:@" "];
                break;
            }
        }
    }
}

-(void) num:(NSInteger) num document:(HTMLDocument*) home max:(NSInteger) max array:(NSMutableArray*) array{
    
    HTMLElement *month1 =[home firstNodeMatchingSelector:@"#Row1 > td:nth-child(6)"];
    HTMLElement *month2 =[home firstNodeMatchingSelector:@"#Row1 > td:nth-child(7)"];
    HTMLElement *month3 =[home firstNodeMatchingSelector:@"#Row1 > td:nth-child(8)"];
    HTMLElement *month4 =[home firstNodeMatchingSelector:@"#Row1 > td:nth-child(9)"];
    HTMLElement *month5 =[home firstNodeMatchingSelector:@"#Row1 > td:nth-child(10)"];
    
    NSNumber *m1 = @([month1.attributes.allValues.lastObject intValue]);
    NSNumber *m2 = @([month2.attributes.allValues.lastObject intValue]);
    NSNumber *m3 = @([month3.attributes.allValues.lastObject intValue]);
    NSNumber *m4 = @([month4.attributes.allValues.lastObject intValue]);
    NSNumber *m5 = @([month5.attributes.allValues.lastObject intValue]);
    
    NSInteger intMonth1 = [m1 integerValue];
    NSInteger intMonth2 = [m2 integerValue];
    NSInteger intMonth3 = [m3 integerValue];
    NSInteger intMonth4 = [m4 integerValue];
    NSInteger intMonth5 = [m5 integerValue];
    
    if (max==27) {
        if (num<=intMonth1) {
            [array addObject:@9];
        }else if(num<=intMonth2+intMonth1){
            [array addObject:@10];
        }else if(num<=intMonth3+intMonth2+intMonth1){
            [array addObject:@11];
        }else if(num<=intMonth4+intMonth3+intMonth2+intMonth1){
            [array addObject:@12];
        }else if(num<=intMonth5+intMonth4+intMonth3+intMonth2+intMonth1){
            [array addObject:@1];
        }
        
    }else if (max==34){
        if (num<=intMonth1) {
            [array addObject:@2];
        }else if(num<=intMonth2+intMonth1){
            [array addObject:@3];
        }else if(num<=intMonth3+intMonth2+intMonth1){
            [array addObject:@4];
        }else if(num<=intMonth4+intMonth3+intMonth2+intMonth1){
            [array addObject:@5];
        }else if(num<=intMonth5+intMonth4+intMonth3+intMonth2+intMonth1){
            [array addObject:@6];
        }
    }
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.subjectArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCellGraph *cell;
    if (self.university == 0) {
        static NSString *identifier = @"cellGraph";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        cell.disLabel.text = [NSString stringWithFormat:@"Дисциплина: %@",self.subjectArray[indexPath.row]];
        NSString *pred =self.teacherArray[indexPath.row];
        
        NSArray* array = [pred componentsSeparatedByString:@"-Лек"];
        pred = [array componentsJoinedByString:@"-Лек\n"];
        array = [pred componentsSeparatedByString:@"-Пр"];
        pred = [array componentsJoinedByString:@"-Пр\n"];
        array = [pred componentsSeparatedByString:@"-Лаб"];
        pred = [array componentsJoinedByString:@"-Лаб\n"];
        array = [pred componentsSeparatedByString:@"(За)"];
        pred = [array componentsJoinedByString:@"(За)"];
        array = [pred componentsSeparatedByString:@"(Эк)"];
        pred = [array componentsJoinedByString:@"(Эк)"];
        
        cell.PredLabel.text = [NSString stringWithFormat:@"Преподаватели: %@",pred];
        cell.typeLabel.text = [NSString stringWithFormat:@"Вид контроля: %@",self.typeArray[indexPath.row]];
        
        NSInteger intM;
        NSInteger intM2;
        
        NSString *len =self.dateArray[indexPath.row];
        
        NSInteger beginInt = [self.ktBeginArray[indexPath.row] integerValue];
        NSInteger endInt = [self.ktEndArray[indexPath.row] integerValue];
        
        if (beginInt>endInt) {
            intM = [self.monthArray[indexPath.row] integerValue];
            intM++;
        }else{
            NSNumber *m =self.monthArray[indexPath.row];
            intM = [m integerValue];
        }
        
        
        NSInteger beginInt2 = [self.ktBeginArray2[indexPath.row] integerValue];
        NSInteger endInt2 = [self.ktEndArray2[indexPath.row] integerValue];
        
        if (beginInt2>endInt2) {
            intM2 = [self.monthArray2[indexPath.row] integerValue];
            if (intM2==12) {
                intM2=1;
            }else{
                intM2++;
            }
        }else{
            NSNumber *m1 =self.monthArray2[indexPath.row];
            intM2 = [m1 integerValue];
        }
        
        if (len.length >10) {
            NSString *date = [self.dateArray[indexPath.row] substringToIndex:10];
            
            NSString *cab = [self.dateArray[indexPath.row] substringFromIndex:10];
            
            cell.dateLabel.text = [NSString stringWithFormat:@"КТ1: с %@.%@ по %@.%ld\nКТ2: с %@.%@ по %@.%ld\nДата сдачи: %@",self.ktBeginArray[indexPath.row],self.monthArray[indexPath.row],self.ktEndArray[indexPath.row],(long)intM,self.ktBeginArray2[indexPath.row],self.monthArray2[indexPath.row],self.ktEndArray2[indexPath.row],(long)intM2,date];
            cell.cabLabel.text = [NSString stringWithFormat:@"Аудитория: %@",cab];
        }else{
            cell.cabLabel.text = @" ";
            cell.dateLabel.text = [NSString stringWithFormat:@"КТ1: с %@.%@ по %@.%ld\nКТ2: с %@.%@ по %@.%ld\nДата сдачи: %@",self.ktBeginArray[indexPath.row],self.monthArray[indexPath.row],self.ktEndArray[indexPath.row],(long)intM,self.ktBeginArray2[indexPath.row],self.monthArray2[indexPath.row],self.ktEndArray2[indexPath.row],(long)intM2,self.dateArray[indexPath.row]];
        }
        if ([self.dateArray[indexPath.row] isEqualToString:@"*"]|| [self.dateArray[indexPath.row] isEqualToString:@"+"]) {
            cell.dateLabel.text = @" ";
            cell.cabLabel.text = @" ";
        }
    }else if(self.university == 1){
        static NSString *identifier = @"cellGraph1";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        cell.subLabel1.text = [NSString stringWithFormat:@"Дисциплина: %@",self.subjectArray[indexPath.row]];
        
        NSString *pred =self.teacherArray[indexPath.row];
        
        NSArray* array = [pred componentsSeparatedByString:@"-Лек"];
        pred = [array componentsJoinedByString:@"-Лек\n"];
        array = [pred componentsSeparatedByString:@"-Пр"];
        pred = [array componentsJoinedByString:@"-Пр\n"];
        array = [pred componentsSeparatedByString:@"-Лаб"];
        pred = [array componentsJoinedByString:@"-Лаб\n"];
        array = [pred componentsSeparatedByString:@"(За)"];
        pred = [array componentsJoinedByString:@"(За)"];
        array = [pred componentsSeparatedByString:@"(Эк)"];
        pred = [array componentsJoinedByString:@"(Эк)"];
        
        cell.techLabel1.text = [NSString stringWithFormat:@"Преподаватели: %@",pred];
        cell.typeLabel1.text = [NSString stringWithFormat:@"Вид контроля: %@",self.typeArray[indexPath.row]];
        cell.hourLabel1.text = [NSString stringWithFormat:@"Часов: %@",self.ktBeginArray[indexPath.row]];
        
        NSString *len =self.dateArray[indexPath.row];
        if (len.length >10) {
            NSString *date = [self.dateArray[indexPath.row] substringToIndex:10];
            
            NSString *cab = [self.dateArray[indexPath.row] substringFromIndex:10];
            
            cell.dateLabel1.text = [NSString stringWithFormat:@"Дата сдачи: %@",date];
            cell.roomLabel1.text = [NSString stringWithFormat:@"Аудитория: %@",cab];
        }else{
            cell.dateLabel1.text = [NSString stringWithFormat:@"Дата сдачи: %@",len];
            cell.roomLabel1.text = @" ";
        }
    }
    return cell;
}



@end
