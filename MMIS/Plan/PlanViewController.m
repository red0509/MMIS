//
//  PlanViewController.m
//  DGTU
//
//  Created by Anton Pavlov on 16.06.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "PlanViewController.h"
#import <HTMLReader.h>
#import "PlanViewCell.h"
#import "SVProgressHUD.h"



@interface PlanViewController ()

@property (strong,nonnull) HTMLDocument *htmlHome;

@property (strong,nonatomic) NSMutableArray *name;
@property (strong,nonatomic) NSMutableArray *allTime;
@property (strong,nonatomic) NSMutableArray *work;
@property (strong,nonatomic) NSMutableArray *course;
@property (strong,nonatomic) NSMutableArray *session;
@property (strong,nonatomic) NSMutableArray *typeExam;
@property (strong,nonatomic) NSMutableArray *typeCredit;
@property (strong,nonatomic) NSMutableArray *typeCR;
@property (strong,nonatomic) NSMutableArray *typeCP;
@property (strong,nonatomic) NSMutableArray *lec;
@property (strong,nonatomic) NSMutableArray *prac;
@property (strong,nonatomic) NSMutableArray *lab;
@property (strong,nonatomic) NSMutableArray *KSR;
@property (strong,nonatomic) NSMutableArray *numbers;
@property (strong,nonatomic) NSMutableArray *bloc;

@property BOOL exit;
@property BOOL external;

@end

@implementation PlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.exit = NO;
    
    self.tableView.estimatedRowHeight = 135.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.viewSeg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"NavBar.png"]];
    self.title = self.plan;
    
    NSRange range = [self.plan rangeOfString:@"plz"];
    
    if (range.location != NSNotFound) {
         self.external = YES;
        [self.sessionSegmented removeAllSegments];
        [self.sessionSegmented insertSegmentWithTitle:@"Летняя" atIndex:0 animated:NO];
        [self.sessionSegmented insertSegmentWithTitle:@"Зимняя" atIndex:1 animated:NO];
        [self.sessionSegmented insertSegmentWithTitle:@"Установочная" atIndex:2 animated:NO];
        self.sessionSegmented.selectedSegmentIndex = 0;

    }
    
    

    //    http://stud.sssu.ru/Plans/Plan.aspx?id=34776
    
    //    http://stud.sssu.ru/Plans/Plan.aspx?id=34716 заочники
    
    //    http://stud.sssu.ru/Plans/Plan.aspx?id=34471 очники
    [self loadDept];
}

- (void) viewWillDisappear:(BOOL)animated{
     [super viewWillDisappear:animated];
    self.exit = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}


- (IBAction)actionSessionSegmented:(id)sender {
    
    self.numbers = [NSMutableArray array];
    if (self.external == YES) {
        for (int i = 0; i<[self.name count]; i++) {
            
            if ([self.course[i] isEqualToString:[NSString stringWithFormat: @"%ld", self.courseSegmented.selectedSegmentIndex+1]] && [self.session[i]  isEqualToString:[self sessionExternal]]) {
                
                [self.numbers addObject:@(i)];
                
            }
        }
    }else{
        
        for (int i = 0; i<[self.name count]; i++) {
            
            if ([self.course[i] isEqualToString:[NSString stringWithFormat: @"%ld", self.courseSegmented.selectedSegmentIndex+1]] && [self.session[i]  isEqualToString:[self sessionNum]]) {
                
                [self.numbers addObject:@(i)];
                
            }
            
        }
    }
    [self.tableView reloadData];
    
}

- (IBAction)actionCourseSegmented:(id)sender {
    
     self.numbers = [NSMutableArray array];
    if (self.external == YES) {

        for (int i = 0; i<[self.name count]; i++) {
            
            if ([self.course[i] isEqualToString:[NSString stringWithFormat: @"%ld", self.courseSegmented.selectedSegmentIndex+1]] && [self.session[i]  isEqualToString:[self sessionExternal]]) {
                
                [self.numbers addObject:@(i)];
                
            }
        }

    }else{
        
        for (int i = 0; i<[self.name count]; i++) {
            
            if ([self.course[i] isEqualToString:[NSString stringWithFormat: @"%ld", self.courseSegmented.selectedSegmentIndex+1]] && [self.session[i]  isEqualToString:[self sessionNum]]) {
                
                [self.numbers addObject:@(i)];
                
            }
        }
    }
    
    [self.tableView reloadData];
    
}

- (NSString*)sessionExternal{
    
    if (self.sessionSegmented.selectedSegmentIndex == 0) {
        return @"Летняя";
    }else if (self.sessionSegmented.selectedSegmentIndex == 1) {
        return @"Зимняя";
    }else if (self.sessionSegmented.selectedSegmentIndex == 2) {
        return @"Установ.";
    }else{
         return @"Летняя";
    }
}

- (NSString*)sessionNum{
    if (self.courseSegmented.selectedSegmentIndex+1 == 1 && self.sessionSegmented.selectedSegmentIndex == 0) {
        return @"1";
    }else if (self.courseSegmented.selectedSegmentIndex+1 == 1 && self.sessionSegmented.selectedSegmentIndex == 1) {
        return @"2";
    }else if (self.courseSegmented.selectedSegmentIndex+1 == 2 && self.sessionSegmented.selectedSegmentIndex == 0) {
        return @"3";
    }else if (self.courseSegmented.selectedSegmentIndex+1 == 2 && self.sessionSegmented.selectedSegmentIndex == 1) {
        return @"4";
    }else if (self.courseSegmented.selectedSegmentIndex+1 == 3 && self.sessionSegmented.selectedSegmentIndex == 0) {
        return @"5";
    }else if (self.courseSegmented.selectedSegmentIndex+1 == 3 && self.sessionSegmented.selectedSegmentIndex == 1) {
        return @"6";
    }else if (self.courseSegmented.selectedSegmentIndex+1 == 4 && self.sessionSegmented.selectedSegmentIndex == 0) {
        return @"7";
    }else if (self.courseSegmented.selectedSegmentIndex+1 == 4 && self.sessionSegmented.selectedSegmentIndex == 1) {
        return @"8";
    }else if (self.courseSegmented.selectedSegmentIndex+1 == 5 && self.sessionSegmented.selectedSegmentIndex == 0) {
        return @"9";
    }else if (self.courseSegmented.selectedSegmentIndex+1 == 5 && self.sessionSegmented.selectedSegmentIndex == 1) {
        return @"10";
    }else if (self.courseSegmented.selectedSegmentIndex+1 == 6 && self.sessionSegmented.selectedSegmentIndex == 0) {
        return @"11";
    }else if (self.courseSegmented.selectedSegmentIndex+1 == 6 && self.sessionSegmented.selectedSegmentIndex == 1) {
        return @"12";
    }else{
        return @"1";
    }
}

-(void) loadDept{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://stud.sssu.ru/Plans/%@",self.reference ]];
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
                  
                  [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
                  [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
                  [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
                  [SVProgressHUD setBackgroundColor:[UIColor grayColor]];
                  [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
                  [SVProgressHUD showProgress:0 status:@"Загрузка.."];
                  
                  NSString *contentType = nil;
                  if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                      NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
                      contentType = headers[@"Content-Type"];
                  }
                  
                  self.htmlHome = [HTMLDocument documentWithData:data
                                               contentTypeHeader:contentType];
                  
                  if (self.external == YES) {
                      [self loadPlan:self.htmlHome external:YES];
                  }else{
                      [self loadPlan:self.htmlHome external:NO];
                  }
                  
              }
              
              
          }] resume];
    });
}

-(void) loadPlan:(HTMLDocument*) home external:(BOOL) external{
    
    self.name = [NSMutableArray array];
    self.allTime = [NSMutableArray array];
    self.work = [NSMutableArray array];
    self.course = [NSMutableArray array];
    self.session = [NSMutableArray array];
    self.typeExam = [NSMutableArray array];
    self.typeCredit = [NSMutableArray array];
    self.typeCP = [NSMutableArray array];
    self.typeCR= [NSMutableArray array];
    self.lec = [NSMutableArray array];
    self.prac = [NSMutableArray array];
    self.lab = [NSMutableArray array];
    self.KSR = [NSMutableArray array];
    self.bloc = [NSMutableArray array];
    float progress = 0.0f;
    
    NSInteger dayNum = 2;
    HTMLElement *day;
    
    while (YES) {

        if (self.exit) {
            break;
        }
        day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td.VedRow1",(long)dayNum]];
        
        if ([day.attributes.allValues.firstObject isEqualToString:@"VedRow1"]) {
            
            NSNumber *num = @([day.attributes.allValues.lastObject intValue]);
            NSInteger numInt = [num integerValue];
            if (numInt == 0) {
                numInt = 1;
            }
            for (NSInteger i = 0; i<numInt; i++){
                [self.bloc addObject: day.textContent];
            }
            
            // 1
            day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(2)",(long)dayNum]];
            if (day == nil) {
                // 1.1
                break;
            }else if ([day.textContent length] > 4) {
                // 1.2
                if (day.attributes.allValues.firstObject == nil) {
                    // 1.2.1
                    [self.name addObject:[self deleteSpace:day.textContent]];
                    
                    day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(3)",(long)dayNum]];
                    [self.allTime addObject:day.textContent];
                    
                    day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(4)",(long)dayNum]];
                    [self.work addObject:day.textContent];
                    
                    day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(5)",(long)dayNum]];
                    [self.course addObject:day.textContent];
                    
                    day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(6)",(long)dayNum]];
                    [self.session addObject:day.textContent];
                    
                    [self subjectLine:dayNum andRow:7 home:home];
                }else{
                    // 1.2.2
                    NSNumber *num = @([day.attributes.allValues.firstObject intValue]);
                    NSInteger numInt = [num integerValue];
                    for (NSInteger i = 0; i<numInt; i++) {
                        day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(2)",(long)dayNum]];
                        [self.name addObject:[self deleteSpace:day.textContent]];
                        
                        day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(3)",(long)dayNum]];
                        [self.allTime addObject:day.textContent];
                        
                        day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(4)",(long)dayNum]];
                        [self.work addObject:day.textContent];
                        
                        
                    }
                    
                    day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(5)",(long)dayNum]];
                    
                    if (day.attributes.allValues.firstObject == nil) {
                        [self.course addObject:day.textContent];
                        
                        day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(6)",(long)dayNum]];
                        [self.session addObject:day.textContent];
                        
                        [self subjectLine:dayNum andRow:7 home:home];
                    }else{
                        NSNumber *num2 = @([day.attributes.allValues.firstObject intValue]);
                        NSInteger numInt2 = [num2 integerValue];
                        if (external == YES && numInt2 == 3) {
                            [self.course addObject:day.textContent];
                            [self.course addObject:day.textContent];
                            [self.course addObject:day.textContent];
                            
                            day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(6)",(long)dayNum]];
                            [self.session addObject:day.textContent];
                            
                            [self subjectLine:dayNum andRow:7 home:home];
                            
                            day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNum+1]];
                            [self.session addObject:day.textContent];
                            
                            [self subjectLine:dayNum+1 andRow:2 home:home];
                            
                            dayNum++;
                            
                            day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNum+1]];
                            [self.session addObject:day.textContent];
                            
                            [self subjectLine:dayNum+1 andRow:2 home:home];
                            
                            dayNum++;
                        }else{
                            [self.course addObject:day.textContent];
                            [self.course addObject:day.textContent];
                            
                            day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(6)",(long)dayNum]];
                            [self.session addObject:day.textContent];
                            
                            [self subjectLine:dayNum andRow:7 home:home];
                            
                            day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNum+1]];
                            [self.session addObject:day.textContent];
                            
                            [self subjectLine:dayNum+1 andRow:2 home:home];
                            
                            dayNum++;
                        }
                        
                        
                    }
                    
                }
            }else if ([day.textContent length] < 4) {
                // 1.3 невыполняется
                NSLog(@"невыполняется");
                if (day.attributes.allValues.firstObject == nil) {
                    day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNum]];
                    [self.course addObject:day.textContent];
                }else{
                    day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNum]];
                    
                    if (day.attributes.allValues.firstObject == nil) {
                        [self.course addObject:day.textContent];
                    }else{
                        
                        [self.course addObject:day.textContent];
                        [self.course addObject:day.textContent];
                        dayNum++;
                    }
                }
                
            }
            dayNum++;
            progress += 0.01f;
            [SVProgressHUD showProgress:progress status:@"Загрузка.."];
        }else{
            // 2
            day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNum]];
            if (day == nil) {
                // 2.1
                break;
            }else if ([day.textContent length] > 4) {
                // 2.2
                if (day.attributes.allValues.firstObject == nil) {
                    // 2.2.1
                    [self.name addObject:[self deleteSpace:day.textContent]];
                    
                    day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(2)",(long)dayNum]];
                    [self.allTime addObject:day.textContent];
                    
                    day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(3)",(long)dayNum]];
                    [self.work addObject:day.textContent];
                    
                    day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(4)",(long)dayNum]];
                    [self.course addObject:day.textContent];
                    
                    day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(5)",(long)dayNum]];
                    [self.session addObject:day.textContent];
                    
                    [self subjectLine:dayNum andRow:6 home:home];
                    
                }else{
                    // 2.2.2
                    NSNumber *num = @([day.attributes.allValues.firstObject intValue]);
                    NSInteger numInt = [num integerValue];
                    for (NSInteger i = 0; i<numInt; i++) {
                        day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNum]];
                        [self.name addObject:[self deleteSpace:day.textContent]];
                        
                        day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(2)",(long)dayNum]];
                        [self.allTime addObject:day.textContent];
                        
                        day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(3)",(long)dayNum]];
                        [self.work addObject:day.textContent];
                    }
                    day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(4)",(long)dayNum]];
                    
                    if (day.attributes.allValues.firstObject == nil) {
                        [self.course addObject:day.textContent];
                        day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(5)",(long)dayNum]];
                        [self.session addObject:day.textContent];
                        
                        [self subjectLine:dayNum andRow:6 home:home];
                    }else{
                        NSNumber *num2 = @([day.attributes.allValues.firstObject intValue]);
                        NSInteger numInt2 = [num2 integerValue];
                        if (external == YES && numInt2 == 3) {
                            [self.course addObject:day.textContent];
                            [self.course addObject:day.textContent];
                            [self.course addObject:day.textContent];
                            
                            day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(5)",(long)dayNum]];
                            [self.session addObject:day.textContent];
                            
                            [self subjectLine:dayNum andRow:6 home:home];
                            
                            day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNum+1]];
                            [self.session addObject:day.textContent];
                            
                            [self subjectLine:dayNum+1 andRow:2 home:home];
                            
                            dayNum++;
                            
                            day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNum+1]];
                            [self.session addObject:day.textContent];
                            
                            [self subjectLine:dayNum+1 andRow:2 home:home];
                            
                            dayNum++;
                        }else{
                            [self.course addObject:day.textContent];
                            [self.course addObject:day.textContent];
                            
                            day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(5)",(long)dayNum]];
                            [self.session addObject:day.textContent];
                            
                            [self subjectLine:dayNum andRow:6 home:home];
                            
                            day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNum+1]];
                            [self.session addObject:day.textContent];
                            
                            [self subjectLine:dayNum+1 andRow:2 home:home];
                            
                            dayNum++;
                        }
             
                    }
                    
                }
            }else if ([day.textContent length] < 4) {
                // 2.3
                if (day.attributes.allValues.firstObject == nil) {
                    day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNum]];
                    [self.course addObject:day.textContent];
                    
                    day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(2)",(long)dayNum]];
                    [self.session addObject:day.textContent];
                    
                    [self subjectLine:dayNum andRow:3 home:home];
                }else{
                    NSNumber *num2 = @([day.attributes.allValues.firstObject intValue]);
                    NSInteger numInt2 = [num2 integerValue];
                    if (external == YES && numInt2 == 3) {
                        
                        day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNum]];
                        [self.course addObject:day.textContent];
                        [self.course addObject:day.textContent];
                        [self.course addObject:day.textContent];
                        
                        day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(2)",(long)dayNum]];
                        [self.session addObject:day.textContent];
                        
                        [self subjectLine:dayNum andRow:3 home:home];
                        
                        day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNum+1]];
                        [self.session addObject:day.textContent];
                        
                        [self subjectLine:dayNum+1 andRow:2 home:home];
                        
                        dayNum++;
                        
                        day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNum+1]];
                        [self.session addObject:day.textContent];
                        
                        [self subjectLine:dayNum+1 andRow:2 home:home];
                        
                        dayNum++;
                    }else{
                        day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNum]];
                        
                        [self.course addObject:day.textContent];
                        [self.course addObject:day.textContent];
                        
                        day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(2)",(long)dayNum]];
                        [self.session addObject:day.textContent];
                        
                        [self subjectLine:dayNum andRow:3 home:home];
                        
                        day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNum+1]];
                        [self.session addObject:day.textContent];
                        
                        [self subjectLine:dayNum+1 andRow:2 home:home];
                        dayNum++;

                    }
                    
                }
                
            }
            dayNum++;
            progress += 0.01f;
            [SVProgressHUD showProgress:progress status:@"Загрузка.."];
            
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        
        self.numbers = [NSMutableArray array];
        
        if (external == YES) {
            
            for (int i = 0; i<[self.name count]; i++) {
                
                if ([self.course[i] isEqualToString:@"1"] && [self.session[i]  isEqualToString:@"Летняя"]) {
                    NSLog(@"%d",i);
                    [self.numbers addObject:@(i)];
                    
                }
            }
        }else{
            
            for (int i = 0; i<[self.name count]; i++) {
                
                if ([self.course[i] isEqualToString:@"1"] && [self.session[i]  isEqualToString:@"1"]) {
                    
                    [self.numbers addObject:@(i)];
                    
                }
            }

        }
        
        [self.tableView reloadData];
        
    });
    
}

-(NSString*) deleteSpace:(NSString*) string{
    
    NSMutableString *space = [[NSMutableString alloc] initWithString:string];
    [space deleteCharactersInRange:NSMakeRange(0, 29)];
    NSRange range = [space rangeOfString:@"\n"];
    [space deleteCharactersInRange:NSMakeRange(range.location, 25)];
    
    return space;
}

-(NSString*) deleteSpace2:(NSString*) string{
    
    NSMutableString *space = [[NSMutableString alloc] initWithString:string];
    [space deleteCharactersInRange:NSMakeRange(0, 8)];
    NSRange range = [space rangeOfString:@"\t"];
    [space deleteCharactersInRange:NSMakeRange(range.location, 6)];
    range = [space rangeOfString:@"\n"];
    [space deleteCharactersInRange:NSMakeRange(range.location, 1)];
    return space;
}

-(void) subjectLine:(NSInteger) section andRow:(NSInteger) row home:(HTMLDocument*) home{
    HTMLElement *day;
    
    NSMutableArray *array;
    
    for (int i = 0; i<8; i++) {
        
        day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#Grid > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)row+i]];
        
        if (i == 0) {
            array = self.typeExam;
        }else if (i == 1){
            array = self.typeCredit;
        }else if (i == 2){
            array = self.typeCR;
        }else if (i == 3){
            array = self.typeCP;
        }else if (i == 4){
            array = self.lec;
        }else if (i == 5){
            array = self.prac;
        }else if (i == 6){
            array = self.lab;
        }else if (i == 7){
            array = self.KSR;
        }
        
        if (day.textContent == nil) {
            [array addObject:@" "];
        }else{
            if (i == 0 || i == 1 || i == 2 || i == 3) {
                [array addObject:[self deleteSpace2:day.textContent]];
            }else{
                [array addObject:day.textContent];
            }
            
        }
    }
    
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return [self.numbers count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cellPlan";
    PlanViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
        NSNumber *num = self.numbers[indexPath.row];
        NSInteger i = [num integerValue];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",  self.name[i]];
    cell.allTimeLabel.text = [NSString stringWithFormat:@"Всего часов: %@",  self.allTime[i]];
    cell.workLabel.text = [NSString stringWithFormat:@"Сам. работа: %@",  self.work[i]];
    cell.typeLabel.text = [NSString stringWithFormat:@"Вид контроля: %@ %@ %@ %@",  self.typeExam[i],self.typeCredit[i],self.typeCP[i],self.typeCR[i]];
    cell.lecAndPracLabel.text = [NSString stringWithFormat:@"Лекций: %@     Практик: %@",self.lec[i],self.prac[i]];
    cell.labAndKSRLabel.text = [NSString stringWithFormat:@"Лабораторных: %@    КСР: %@",self.lab[i],self.KSR[i]];
    cell.blocLabel.text = [NSString stringWithFormat:@"Блок: %@",self.bloc[i]];

    if (self.external == YES) {
        cell.courseAndSessionLabel.text = [NSString stringWithFormat:@"Курс: %@     Сессия: %@",  self.course[i],self.session[i]];
    }else{
        cell.courseAndSessionLabel.text = [NSString stringWithFormat:@"Курс: %@     Семестр: %@",  self.course[i],self.session[i]];
    }
    
    return cell;
    
    
    
}



@end
