//
//  TableViewControllerRegister.m
//  DGTU
//
//  Created by Anton Pavlov on 26.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewControllerRegister.h"
#import "TableViewCellSubject.h"
#import "TableViewControllerInfo.h"
#import "TableViewRegisterContent.h"




@interface TableViewControllerRegister ()

@property (strong,nonatomic) NSMutableArray *subjectArray;
@property (strong,nonatomic) NSMutableArray *typeArray;
@property (strong,nonatomic) NSMutableArray *closedArray;
@property (strong,nonatomic) NSMutableArray *registerReferences;

@property (strong,nonatomic) NSMutableArray *pointArray;


@end

@implementation TableViewControllerRegister

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Дисциплины";
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
-(void) loadRegister: (NSString*) URLFacul{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.subjectArray = [NSMutableArray array];
        self.typeArray = [NSMutableArray array];
        self.closedArray = [NSMutableArray array];
        self.registerReferences = [NSMutableArray array];
        
        NSURL *URL = [NSURL URLWithString:URLFacul];
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
                                                                               [self loadRegister:URLFacul];
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
                  NSInteger section = 2;
                  
                  
                  HTMLElement *subject = [home firstNodeMatchingSelector:
                                          [NSString stringWithFormat:@"#ctl00_ContentPage_ucListVedBox_Grid > tbody > tr:nth-child(%ld) > td:nth-child(1) > a",(long)section]];
                  HTMLElement *type;
                  HTMLElement *closed;
                  
                  while (subject != nil) {
                      
                      
                      subject = [home firstNodeMatchingSelector:
                                 [NSString stringWithFormat:@"#ctl00_ContentPage_ucListVedBox_Grid > tbody > tr:nth-child(%ld) > td:nth-child(1) > a",(long)section]];
                      type = [home firstNodeMatchingSelector:
                              [NSString stringWithFormat:@"#ctl00_ContentPage_ucListVedBox_Grid > tbody > tr:nth-child(%ld) > td:nth-child(2)",(long)section]];
                      closed = [home firstNodeMatchingSelector:
                                [NSString stringWithFormat:@"#ctl00_ContentPage_ucListVedBox_Grid > tbody > tr:nth-child(%ld) > td:nth-child(3)",(long)section]];
                      
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if (subject != nil) {
                              
                              [self.subjectArray addObject:subject.textContent];
                              [self.registerReferences addObject:subject.attributes.allValues.lastObject];
                              [self.typeArray addObject:type.textContent];
                              [self.closedArray addObject:closed.textContent];
                              [self.tableView reloadData];
                          }
                      });
                      
                      section++;
                      
                  }
              }
          }] resume];
    });
}
#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    TableViewControllerInfo *tableViewControllerInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewControllerInfo"];
    tableViewControllerInfo.referenceInfo = self.registerReferences[indexPath.row];
    [self.navigationController pushViewController:tableViewControllerInfo animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.subjectArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cellSubject";
    TableViewCellSubject *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.subjectLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.subjectLabel.numberOfLines = 4;
    cell.subjectLabel.text = self.subjectArray[indexPath.row];
    cell.typeLabel.text = [NSString stringWithFormat:@"Тип ведомости: %@  Закрыта: %@",self.typeArray[indexPath.row],self.closedArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self loadPoint:[NSString stringWithFormat:@"%@/Ved/%@",self.referenceUniversity ,self.registerReferences[indexPath.row]]];
    
    NSString *type = [NSString stringWithFormat:@"%@",self.typeArray[indexPath.row]];
    TableViewRegisterContent *tableViewRegisterContent = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewRegisterContent"];
    
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
    tableViewRegisterContent.referenceContent = self.registerReferences[indexPath.row];
    
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
