//
//  TableViewPageContTeacher.m
//  DGTU
//
//  Created by Anton Pavlov on 25.03.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewControllerClamping.h"
#import "TableViewCellContent.h"




@interface TableViewControllerClamping ()

@property (strong,nonatomic) NSMutableArray *timeArray;
@property (strong,nonatomic) NSMutableArray *subjectArray;
@property (strong,nonatomic) NSMutableArray *groupArray;
@property (strong,nonatomic) NSMutableArray *classroomArray;
@property (strong,nonatomic) NSMutableArray *dateArray;

@end

@implementation TableViewControllerClamping

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 135.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
   
    self.tableView.contentInset = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    
    if ([self.graph isEqualToString:@"teacher"]) {
        HTMLDocument *home = [HTMLDocument documentWithString:self.tableTime];
        [self loadTimeTable:home];
    }else{
        [self loadGroupReference:self.reference];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) loadGroupReference:(NSString*) URLGroup{
    
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
                                                                           [self loadGroupReference:URLGroup];
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
                  [self loadTimeTable:home ];
              });
          }
      }] resume];
}


-(void) loadTimeTable:(HTMLDocument*)home
{
    self.timeArray = [NSMutableArray array];
    self.subjectArray = [NSMutableArray array];
    self.groupArray = [NSMutableArray array];
    self.classroomArray = [NSMutableArray array];
    self.dateArray = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
  
        
        NSInteger dayNum = 2;
        NSInteger dayNumEnd = 0;
        HTMLElement *day;
        // День недели
        while (YES) {
         
            day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td",(long)dayNum]];
            if ([day.textContent isEqualToString:@"Расписание фиксированных занятий"]) {
                
                break;
            }else if (day.textContent == nil){
                break;
            }
            dayNum++;
        }
        dayNumEnd += dayNum;
        while (YES) {
            
            day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNumEnd]];
            if (day.textContent == nil){
                break;
            }
            dayNumEnd++;
        }
        

        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            NSInteger section = dayNum+1;
            NSInteger timeRow;
            NSInteger subjectRow;
            NSInteger groupRow;
            NSInteger classroomRow;
            for (; section < dayNumEnd; section++) {
                
                timeRow = 1;
                subjectRow = 2;
                groupRow = 3;
                classroomRow = 4;
                
                HTMLElement *date = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)section]];
                HTMLElement *time = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)timeRow]];
                HTMLElement *group = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)groupRow]];
                HTMLElement *classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)classroomRow]];
                HTMLElement *subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)subjectRow]];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd.MM.yyyy"];
                NSDate *dateform = [dateFormatter dateFromString:date.textContent];
                
                NSString *dateNum = date.attributes.allValues.lastObject;
                NSInteger dateInt = [dateNum integerValue];
                
                if (dateform != nil) {
                    if ([dateNum isEqual:@"center"]) {
                        dateInt=1;
                    }
                    for (NSInteger i = 0; i<dateInt; i++) {
                        [self.dateArray addObject:date.textContent];
                    }
                    time = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%d)",(long)section,2]];
                    subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%d)",(long)section,3]];
                    group = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%d)",(long)section,4]];
                    classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%d)",(long)section,5]];
                    
                }
                
                

                
                NSString *timeNum = time.attributes.allValues.lastObject;
                NSString *timeNum2 = time.attributes.allKeys.lastObject;
                
                NSInteger timeInt = [timeNum integerValue];
                if ([timeNum isEqual:@"center"]) {
                    timeInt=1;
                }
                if ([timeNum2 isEqual:@"rowspan"] || [timeNum2 isEqual:@"align"]) {
                    for (NSInteger i = 0; i<timeInt; i++) {
                        [self.timeArray addObject:time.textContent];
                    }
                }
                
                if (subject.attributes.allValues.lastObject == nil) {
                    subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%d)",(long)section,1]];
                    group = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%d)",(long)section,2]];
                    classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%d)",(long)section,3]];
                }
                
                [self.subjectArray addObject:subject.textContent];
                [self.groupArray addObject:group.textContent];
                [self.classroomArray addObject:classroom.textContent];
                
                [self.tableView reloadData];
            }
            
            NSLog(@"%ld",(unsigned long)[self.timeArray count]);
            NSLog(@"%ld",(unsigned long)[self.subjectArray count]);
            NSLog(@"%ld",(unsigned long)[self.groupArray count]);
            NSLog(@"%ld",(unsigned long)[self.classroomArray count]);
            NSLog(@"%ld",(unsigned long)[self.dateArray count]);
            for (NSMutableString *time in self.timeArray) {
                
                NSRange range = [time rangeOfString:@":"];
                if (![NSStringFromRange(range) isEqualToString:@"{2, 1}"]) {
                    [time insertString:@"-" atIndex:time.length-5];
                    [time replaceCharactersInRange:NSMakeRange(time.length-3, 1) withString:@":"];
                    [time replaceCharactersInRange:NSMakeRange(time.length-9, 1) withString:@":"];
                }
            }
            
        });
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:
                                 CGRectMake(0, 0, tableView.frame.size.width, 20)];
//    sectionHeaderView.backgroundColor = [UIColor colorWithRed:100.0f/255.0f green:181.0f/255.0f blue:246.0f/255.0f alpha:0.95f];
    sectionHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"NavBar.png"]];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:
                            CGRectMake(15, 10, sectionHeaderView.frame.size.width, 15)];
    
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    [headerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    [sectionHeaderView addSubview:headerLabel];
    
    
    if ([self.dateArray count]==0) {
        headerLabel.text = @"Фиксированные занятия отсутствуют";
    }else{
        headerLabel.text = @"Фиксированные занятия";
    }

    return sectionHeaderView;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return [self.subjectArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    TableViewCellContent *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.num.text = self.dateArray[indexPath.row];
        cell.time.text = [NSString stringWithFormat:@"Время: %@",self.timeArray[indexPath.row]];
        cell.subject.text = [NSString stringWithFormat:@"Дисциплина: %@",self.subjectArray[indexPath.row]];
        cell.room.text =[NSString stringWithFormat:@"Аудитория: %@",  self.classroomArray[indexPath.row]];
        cell.teacher.text = [NSString stringWithFormat:@"Группа: %@",self.groupArray[indexPath.row]];
    
 
    return cell;
    
}


@end
