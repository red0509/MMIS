//
//  TableViewPageContTeacher.m
//  DGTU
//
//  Created by Anton Pavlov on 25.03.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewPageContTeacher.h"
#import "TableViewCellContent.h"


@interface TableViewPageContTeacher ()

@property (strong,nonatomic) NSMutableArray *timeArray;
@property (strong,nonatomic) NSMutableArray *weekArray;
@property (strong,nonatomic) NSMutableArray *subjectArray;
@property (strong,nonatomic) NSMutableArray *groupArray;
@property (strong,nonatomic) NSMutableArray *classroomArray;

@property (strong,nonatomic) NSMutableArray *timeArrayWeekTwo;
@property (strong,nonatomic) NSMutableArray *weekArrayWeekTwo;
@property (strong,nonatomic) NSMutableArray *subjectArrayWeekTwo;
@property (strong,nonatomic) NSMutableArray *groupArrayWeekTwo;
@property (strong,nonatomic) NSMutableArray *classroomArrayWeekTwo;

@property (strong,nonatomic) HTMLDocument *htmlHome;

@end

@implementation TableViewPageContTeacher

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 135.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.viewSeg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"NavBar.png"]];
    self.segmented.selectedSegmentIndex = [self indexDate];
    [self actionSegmented:self.segmented];
    if (![self.graph isEqualToString:@"teacher"]) {
    [self firstLoad:[self indexDate]];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) firstLoad:(NSInteger) index{
    switch (index) {
        case 0:
            [self loadGroupReference:self.reference day:@"Понедельник"];
            break;
        case 1:
            [self loadGroupReference:self.reference day:@"Вторник"];
            break;
        case 2:
            [self loadGroupReference:self.reference day:@"Среда"];
            break;
        case 3:
            [self loadGroupReference:self.reference day:@"Четверг"];
            break;
        case 4:
            [self loadGroupReference:self.reference day:@"Пятница"];
            break;
        case 5:
            [self loadGroupReference:self.reference day:@"Суббота"];
            break;
        default:
            break;
    }
}

- (NSInteger) indexDate{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"EEEE"];
    NSString * strintDate = [dateFormatter stringFromDate:date];
    if ([strintDate isEqualToString:@"понедельник"]) {
        return 0;
    }else if([strintDate isEqualToString:@"вторник"]){
        return 1;
    }else if([strintDate isEqualToString:@"среда"]){
        return 2;
    }else if([strintDate isEqualToString:@"четверг"]){
        return 3;
    }else if([strintDate isEqualToString:@"пятница"]){
        return 4;
    }else if([strintDate isEqualToString:@"суббота"]){
        return 5;
    }else{
        return 0;
    }
}

- (IBAction)actionSegmented:(id)sender {
    if ([self.graph isEqualToString:@"teacher"]) {
        HTMLDocument *home = [HTMLDocument documentWithString:self.tableTime];
        switch (self.segmented.selectedSegmentIndex) {
                
            case 0:
                [self loadTimeTable:home day:@"Понедельник"];
                break;
            case 1:
                [self loadTimeTable:home day:@"Вторник"];
                break;
            case 2:
                [self loadTimeTable:home day:@"Среда"];
                break;
            case 3:
                [self loadTimeTable:home day:@"Четверг"];
                break;
            case 4:
                [self loadTimeTable:home day:@"Пятница"];
                break;
            case 5:
                [self loadTimeTable:home day:@"Суббота"];
                break;
            default:
                break;
        }
    }else{
        switch (self.segmented.selectedSegmentIndex) {
            case 0:
                [self loadTimeTable:self.htmlHome day:@"Понедельник"];
                break;
            case 1:
                [self loadTimeTable:self.htmlHome day:@"Вторник"];
                break;
            case 2:
                [self loadTimeTable:self.htmlHome day:@"Среда"];
                break;
            case 3:
                [self loadTimeTable:self.htmlHome day:@"Четверг"];
                break;
            case 4:
                [self loadTimeTable:self.htmlHome day:@"Пятница"];
                break;
            case 5:
                [self loadTimeTable:self.htmlHome day:@"Суббота"];
                break;
            default:
                break;
        }
        
    }
    
}

-(void) loadGroupReference:(NSString*) URLGroup day:(NSString*) weekDay{
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
                                                                           [self loadGroupReference:URLGroup day:weekDay];
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
                  
                  HTMLDocument *home = [HTMLDocument documentWithData:data
                                                    contentTypeHeader:contentType];
                  self.htmlHome = home;
                  [self loadTimeTable:home day:weekDay];
                  
                  
              });
          }
      }] resume];
}


-(void) loadTimeTable:(HTMLDocument*)home day:(NSString*) weekDay
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.timeArray = [NSMutableArray array];
        self.weekArray = [NSMutableArray array];
        self.subjectArray = [NSMutableArray array];
        self.groupArray = [NSMutableArray array];
        self.classroomArray = [NSMutableArray array];
        
        self.timeArrayWeekTwo = [NSMutableArray array];
        self.weekArrayWeekTwo = [NSMutableArray array];
        self.subjectArrayWeekTwo = [NSMutableArray array];
        self.groupArrayWeekTwo = [NSMutableArray array];
        self.classroomArrayWeekTwo = [NSMutableArray array];
        
        
        
        NSInteger dayNum = 2;
        NSNumber *dayRow;
        HTMLElement *day;
        // День недели
        while (YES) {
            day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNum]];
            if ([day.textContent isEqualToString:weekDay]) {
                if ([day.attributes.allValues.lastObject isEqual:@"center"]) {
                    dayRow=@1;
                }else{
                    dayRow = @([day.attributes.allValues.lastObject intValue]);
                }
                
                break;
            }else if (day.textContent == nil){
                break;
            }
            dayNum++;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSInteger dayRowInt = [dayRow integerValue];
            
            NSInteger section = dayNum;
            NSInteger timeRow;
            NSInteger weekRow;
            NSInteger subjectRow;
            NSInteger groupRow;
            NSInteger classroomRow;
            for (; section < dayRowInt+dayNum; section++) {
                if (section == dayNum) {
                    timeRow = 2;
                    weekRow = 3;
                    subjectRow = 4;
                    groupRow = 5;
                    classroomRow = 6;
                }else{
                    timeRow = 1;
                    weekRow = 2;
                    subjectRow = 3;
                    groupRow = 4;
                    classroomRow = 5;
                }
                HTMLElement *subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)subjectRow]];
                HTMLElement *time = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)timeRow]];
                HTMLElement *week = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)weekRow]];
                HTMLElement *group = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)groupRow]];
                HTMLElement *classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)classroomRow]];

                
                if(![week.textContent isEqualToString:@"1"]){
                    if ([week.textContent isEqualToString:@"2"]) {
                        week = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)weekRow]];
                        subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)subjectRow]];
                        group = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)groupRow]];
                        classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)classroomRow]];
                    }else{

                        week = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)weekRow-1]];
                        subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)subjectRow-1]];
                        group = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)groupRow-1]];
                        classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)classroomRow-1]];
                    }
                    if (week.textContent.length>3) {

                            subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)subjectRow-2]];
                            group = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)groupRow-2]];
                            classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)classroomRow-2]];
                    }
                }
                if (classroom.textContent == nil) {
                    subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section-1,(long)subjectRow]];
                    group = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)groupRow-2]];
                    classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)classroomRow-2]];
                }
                
                NSNumber *timeNum = @([time.attributes.allValues.lastObject intValue]);
                NSInteger timeInt = [timeNum integerValue];
                if (timeInt != 0 ||[timeNum isEqual:@"center"]) {
                    if (![time.textContent isEqualToString:@"2"]) {
                        if ([timeNum isEqual:@"center"]) {
                            timeInt=1;
                        }
                        for (NSInteger i = 0; i<timeInt; i++) {
                            [self.timeArray addObject:time.textContent];
                        }
                    }
                }
                NSNumber *weekNum = @([week.attributes.allValues.lastObject intValue]);
                NSInteger weekInt = [weekNum integerValue];
                if (weekInt != 0 ||[weekNum isEqual:@"center"]) {
                    if ([weekNum isEqual:@"center"]) {
                        weekInt=1;
                    }
                    
                    for (NSInteger i = 0; i<weekInt; i++) {
                        [self.weekArray addObject:week.textContent];
                        
                    }
                }

                [self.subjectArray addObject:subject.textContent];
                [self.groupArray addObject:group.textContent];
                [self.classroomArray addObject:classroom.textContent];
                
                
            }
            
            for (NSMutableString *time in self.timeArray) {
                if (time.length>3) {
                    
                    NSRange range = [time rangeOfString:@":"];
                    if (![NSStringFromRange(range) isEqualToString:@"{2, 1}"] && ![NSStringFromRange(range) isEqualToString:@"{1, 1}"]) {
                        [time insertString:@"-" atIndex:time.length-5];
                        [time replaceCharactersInRange:NSMakeRange(time.length-3, 1) withString:@":"];
                        [time replaceCharactersInRange:NSMakeRange(time.length-9, 1) withString:@":"];
                    }
                }
            }
            
            
            for (NSInteger i = 0; i<[self.weekArray count]; i++) {
                if ([self.weekArray[i] isEqual:@"2"]) {
                    [self.timeArrayWeekTwo addObject:self.timeArray[i]];
                    [self.weekArrayWeekTwo addObject:self.weekArray[i]];
                    [self.subjectArrayWeekTwo addObject:self.subjectArray[i]];
                    [self.groupArrayWeekTwo addObject:self.groupArray[i]];
                    [self.classroomArrayWeekTwo addObject:self.classroomArray[i]];
                }
                [self.tableView reloadData];
            }
            for (NSInteger i = 0; i<[self.weekArray count]; i++) {
                if ([self.weekArray[i] isEqual:@"2"]) {
                    [self.timeArray removeObjectAtIndex:i];
                    [self.weekArray removeObjectAtIndex:i];
                    [self.subjectArray removeObjectAtIndex:i];
                    [self.groupArray removeObjectAtIndex:i];
                    [self.classroomArray removeObjectAtIndex:i];
                    i--;
                }
                [self.tableView reloadData];
            }
            [self.tableView reloadData];
        });
    });
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
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
    
    switch (section) {
        case 0:
            if ([self.timeArray count]==0) {
                headerLabel.text = @"Первая неделя - занятий нет";
            }else{
                headerLabel.text = @"Первая неделя";
            }
            
            return sectionHeaderView;
            break;
        case 1:
            if ([self.timeArrayWeekTwo count]==0) {
                headerLabel.text = @"Вторая неделя - занятий нет";
            }else{
                headerLabel.text = @"Вторая неделя";
            }
            
            return sectionHeaderView;
            break;
        default:
            break;
    }
    
    return sectionHeaderView;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [self.timeArray count];
        
    }else {
        return [self.timeArrayWeekTwo count];
    }
}

- (NSString*) arrayString:(NSString*) string{
    
    if ([string isEqualToString:@"8:30-10:05"]) {
        return @"1";
    }else if ([string isEqualToString:@"10:20-11:55"]) {
        return @"2";
    }else if ([string isEqualToString:@"12:30-14:05"]) {
        return @"3";
    }else if ([string isEqualToString:@"14:20-15:55"]) {
        return @"4";
    }else if ([string isEqualToString:@"16:10-17:45"]) {
        return @"5";
    }else if ([string isEqualToString:@"18:00-19:35"]) {
        return @"6";
    }else {
        return @"7";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cellTeach";
    TableViewCellContent *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (indexPath.section == 0) {
        cell.num.text = [self arrayString:self.timeArray[indexPath.row]];

        cell.time.text = [NSString stringWithFormat:@"Время: %@",self.timeArray[indexPath.row]];
        cell.subject.text = [NSString stringWithFormat:@"Дисциплина: %@",self.subjectArray[indexPath.row]];
        cell.room.text =[NSString stringWithFormat:@"Аудитория: %@",  self.classroomArray[indexPath.row]];
        cell.teacher.text = [NSString stringWithFormat:@"Группа: %@",self.groupArray[indexPath.row]];
        
    }else{
        cell.num.text = [self arrayString:self.timeArrayWeekTwo[indexPath.row]];
        cell.time.text = [NSString stringWithFormat:@"Время: %@",self.timeArrayWeekTwo[indexPath.row]];
        cell.subject.text = [NSString stringWithFormat:@"Дисциплина: %@",self.subjectArrayWeekTwo[indexPath.row]];
        cell.room.text =[NSString stringWithFormat:@"Аудитория: %@",  self.classroomArrayWeekTwo[indexPath.row]];
        cell.teacher.text = [NSString stringWithFormat:@"Группа: %@",self.groupArrayWeekTwo[indexPath.row]];
        
    }
    return cell;
    
}



@end
