//
//  KafTableView.m
//  MMIS
//
//  Created by Anton Pavlov on 01.07.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "KafTableView.h"
#import "SVProgressHUD.h"
#import <HTMLReader.h>
#import "TableViewRegisterContent.h"
#import "TableViewControllerInfo.h"




@interface KafTableView ()

@property (strong,nonatomic) NSMutableArray *nameArray;
@property (strong,nonatomic) NSMutableArray *vedom;
@property (strong,nonatomic) NSMutableArray *vedomRef;

@property (strong,nonatomic) NSMutableArray *pointArray;
@property (strong,nonatomic) NSMutableArray *typeArray;


@end

@implementation KafTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.status;
    
    [self loadStat: [NSString stringWithFormat:@"http://stud.sssu.ru/Stat/Default.aspx%@",self.reference]];
    
    self.tableView.estimatedRowHeight = 135.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger numberDefaults = [defaults integerForKey:@"number"];
    
    if (numberDefaults == 0) {
        self.referenceUniversity = @"http://stud.sssu.ru/";
    } else if(numberDefaults == 1){
        self.referenceUniversity = @"http://umu.sibadi.org/";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) loadStat:(NSString*) ref{
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[UIColor grayColor]];
    
    [SVProgressHUD show];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSURL *URL = [NSURL URLWithString:ref];
        
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
                                                                               [self loadStat:ref];
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
                  self.vedom = [NSMutableArray array];
                  self.vedomRef = [NSMutableArray array];
                  self.pointArray = [NSMutableArray array];
                  self.typeArray = [NSMutableArray array];
                  
                  NSInteger dayNum = 2;
                  HTMLElement *div;
                  HTMLDocument *home = [HTMLDocument documentWithData:data
                                                    contentTypeHeader:contentType];
                  while (YES) {
                      div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucStatListVed_Grid > tbody > tr:nth-child(%ld) > td:nth-child(1) > a",(long)dayNum]];
                      
                      if (div == nil) {
                          break;
                      }else{
                          [self.vedom addObject:div.textContent];
                          NSMutableString *space = [[NSMutableString alloc] initWithString:div.attributes.allValues.firstObject];
                          [space deleteCharactersInRange:NSMakeRange(0, 7)];
                          [self.vedomRef addObject:space];
                      }
                      
                      NSMutableString *space = [[NSMutableString alloc] initWithString:div.textContent];
                      [space deleteCharactersInRange:NSMakeRange(0, space.length-3)];
                      
                      if ([space isEqualToString:@"vdz"]) {
                          [self.typeArray addObject:@"Зачет"];
                      }else if ([space isEqualToString:@"vde"]) {
                          [self.typeArray addObject:@"Экзамен"];
                      }else if ([space isEqualToString:@"vkr"]) {
                          [self.typeArray addObject:@"Курсовая работа"];
                      }else if ([space isEqualToString:@"vpr"]) {
                          [self.typeArray addObject:@"Практика"];
                      }else if ([space isEqualToString:@"vdr"]) {
                          [self.typeArray addObject:@"Выпуская работа"];
                      }else if ([space isEqualToString:@"vkp"]) {
                          [self.typeArray addObject:@"Курсовая работа"];
                      }else if ([space isEqualToString:@"vge"]) {
                          [self.typeArray addObject:@"ГосЭкзамен"];
                      }
                      
                      div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucStatListVed_Grid > tbody > tr:nth-child(%ld) > td:nth-child(2)",(long)dayNum]];
                      
                      if ([div.serializedFragment isEqualToString:@"<td>&nbsp;</td>"]) {
                          [self.nameArray addObject:@"Отсутствует"];
                      }else{
                          [self.nameArray addObject:div.textContent];
                          
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.vedom count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] ;
    }
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"Ведомость: %@" ,self.vedom[indexPath.row]];
    cell.detailTextLabel.text =  [NSString stringWithFormat:@"Преподаватель: %@" ,self.nameArray[indexPath.row]];
    
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    TableViewControllerInfo *tableViewControllerInfo = [mainStoryboard instantiateViewControllerWithIdentifier:@"TableViewControllerInfo"];
    tableViewControllerInfo.referenceInfo = self.vedomRef[indexPath.row];
    [self.navigationController pushViewController:tableViewControllerInfo animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self loadPoint:[NSString stringWithFormat:@"%@/Ved/%@",self.referenceUniversity ,self.vedomRef[indexPath.row]]];

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    NSString *type = [NSString stringWithFormat:@"%@",self.typeArray[indexPath.row]];
    TableViewRegisterContent *tableViewRegisterContent = [mainStoryboard instantiateViewControllerWithIdentifier:@"TableViewRegisterContent"];
    
    [self.pointArray addObject:type];
    
    tableViewRegisterContent.arrayPage = self.pointArray;
    
    if([type isEqualToString:@"Курсовой проект" ]){
        tableViewRegisterContent.arrayPage = @[@"Курсовой проект"];
    }else if([type isEqualToString:@"Курсовая работа" ]){
        tableViewRegisterContent.arrayPage = @[@"Курсовая работа"];
    }else if([type isEqualToString:@"Практика" ]){
        tableViewRegisterContent.arrayPage = @[@"Практика"];
    }else if([type isEqualToString:@"ГосЭкзамен" ]){
        tableViewRegisterContent.arrayPage = @[@"ГосЭкзамен"];
    }else if([type isEqualToString:@"Выпуская работа" ]){
        tableViewRegisterContent.arrayPage = @[@"Выпуская работа"];
    }
    
    tableViewRegisterContent.referenceUniversity = self.referenceUniversity;
    tableViewRegisterContent.referenceContent = self.vedomRef[indexPath.row];
    
    [self.navigationController pushViewController:tableViewRegisterContent animated:YES];
    
}

-(void) loadPoint: (NSString*) URLFacul{
    self.pointArray = [NSMutableArray array];
    
    NSURL *URLTime = [NSURL URLWithString:URLFacul];
    NSError *errorData = nil;
    NSData *data = [[NSData alloc]initWithContentsOfURL:URLTime options:NSDataReadingUncached error:&errorData];
    
    //        NSString *contentType = @"text/html; charset=windows-1251";
    NSString *contentType = @"text/html; charset=utf-8";
    
    
    if (errorData != nil) {
        
    } else {
        
        HTMLDocument *home = [HTMLDocument documentWithData:data
                                          contentTypeHeader:contentType];
        
        HTMLElement *div = [home firstNodeMatchingSelector:@"#ucVedBox_Row1 > td:nth-child(19)"];
        
        if ([div.textContent isEqualToString:@"Точка 6"]) {
            [self.pointArray insertObject:@"КT 6" atIndex:0];
        }
        
        div = [home firstNodeMatchingSelector:@"#ucVedBox_Row1 > td:nth-child(16)"];
        
        if ([div.textContent isEqualToString:@"Точка 5"]) {
            [self.pointArray insertObject:@"КT 5" atIndex:0];
        }
        
        div = [home firstNodeMatchingSelector:@"#ucVedBox_Row1 > td:nth-child(13)"];
        
        if ([div.textContent isEqualToString:@"Точка 4"]) {
            [self.pointArray insertObject:@"КT 4" atIndex:0];
        }
        
        div = [home firstNodeMatchingSelector:@"#ucVedBox_Row1 > td:nth-child(10)"];
        
        if ([div.textContent isEqualToString:@"Точка 3"]) {
            [self.pointArray insertObject:@"КT 3" atIndex:0];
        }
        
        div = [home firstNodeMatchingSelector:@"#ucVedBox_Row1 > td:nth-child(7)"];
        
        if ([div.textContent isEqualToString:@"Точка 2"]) {
            [self.pointArray insertObject:@"КT 2" atIndex:0];
        }
        
        div = [home firstNodeMatchingSelector:@"#ucVedBox_Row1 > td:nth-child(4)"];
        
        if ([div.textContent isEqualToString:@"Точка 1"]) {
            [self.pointArray insertObject:@"КT 1" atIndex:0];
        }
        
    }
}




@end
