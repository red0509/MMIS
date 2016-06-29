//
//  TableViewPageContFav.m
//  DGTU
//
//  Created by Anton Pavlov on 18.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewPageContFav.h"
#import "TableViewCellContent.h"

@interface TableViewPageContFav ()

@property (strong,nonatomic) NSMutableArray *timeArray;
@property (strong,nonatomic) NSMutableArray *weekArray;
@property (strong,nonatomic) NSMutableArray *subjectArray;
@property (strong,nonatomic) NSMutableArray *teacherArray;
@property (strong,nonatomic) NSMutableArray *classroomArray;

@property (strong,nonatomic) NSMutableArray *timeArrayWeekTwo;
@property (strong,nonatomic) NSMutableArray *weekArrayWeekTwo;
@property (strong,nonatomic) NSMutableArray *subjectArrayWeekTwo;
@property (strong,nonatomic) NSMutableArray *teacherArrayWeekTwo;
@property (strong,nonatomic) NSMutableArray *classroomArrayWeekTwo;

@end

@implementation TableViewPageContFav

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewSeg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"NavBar.png"]];
    self.tableView.estimatedRowHeight = 135.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.segmented.selectedSegmentIndex = [self indexDate];
    [self ActionSegmented:self.segmented];
    self.title = @"Расписание";
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (IBAction)ActionSegmented:(id)sender {
    
    switch (self.segmented.selectedSegmentIndex) {
        case 0:
            [self loadGroupReference:self.timeTable day:@"Понедельник"];
            break;
        case 1:
            [self loadGroupReference:self.timeTable day:@"Вторник"];
            break;
        case 2:
            [self loadGroupReference:self.timeTable day:@"Среда"];
            break;
        case 3:
            [self loadGroupReference:self.timeTable day:@"Четверг"];
            break;
        case 4:
            [self loadGroupReference:self.timeTable day:@"Пятница"];
            break;
        case 5:
            [self loadGroupReference:self.timeTable day:@"Суббота"];
            break;
        default:
            break;
    }
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

-(void) loadGroupReference:(NSString*) URLGroup day:(NSString*) weekDay{
    
    HTMLDocument *home = [[HTMLDocument alloc] initWithString:URLGroup];
    
    [self loadTimeTable:home day:weekDay];
}


-(void) loadTimeTable:(HTMLDocument*)home day:(NSString*) weekDay
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.timeArray = [NSMutableArray array];
        self.weekArray = [NSMutableArray array];
        self.subjectArray = [NSMutableArray array];
        self.teacherArray = [NSMutableArray array];
        self.classroomArray = [NSMutableArray array];
        
        self.timeArrayWeekTwo = [NSMutableArray array];
        self.weekArrayWeekTwo = [NSMutableArray array];
        self.subjectArrayWeekTwo = [NSMutableArray array];
        self.teacherArrayWeekTwo = [NSMutableArray array];
        self.classroomArrayWeekTwo = [NSMutableArray array];
        
        
        
        NSInteger dayNum = 2;
        NSNumber *dayRow;
        HTMLElement *day;
        // День недели
        while (YES) {
            day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNum]];
            if ([day.textContent isEqualToString:weekDay]) {
                dayRow = @([day.attributes.allValues.lastObject intValue]);
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
            NSInteger teacherRow;
            NSInteger classroomRow;
            
            for (; section < dayRowInt+dayNum; section++) {
                if (section == dayNum) {
                    timeRow = 2;
                    weekRow = 3;
                    subjectRow = 4;
                    teacherRow = 5;
                    classroomRow = 6;
                }else{
                    timeRow = 1;
                    weekRow = 2;
                    subjectRow = 3;
                    teacherRow = 4;
                    classroomRow = 5;
                }
                HTMLElement *subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)subjectRow]];
                
                
                HTMLElement *teacher = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)teacherRow]];
                
                HTMLElement *time = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)timeRow]];
                HTMLElement *week = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)weekRow]];
                
                HTMLElement *classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)classroomRow]];
                
                if ([week.attributes.allKeys.lastObject isEqual:@"colspan"]) {
                    [self.timeArray addObject:time.textContent];
                    [self.timeArray addObject:time.textContent];
                    
                    [self.weekArray addObject:@"1"];
                    [self.weekArray addObject:@"2"];
                    subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)subjectRow-1]];
                    [self.subjectArray addObject:subject.textContent];
                    [self.subjectArray addObject:subject.textContent];
                    
                    teacher = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)teacherRow-1]];
                    [self.teacherArray addObject:teacher.textContent];
                    [self.teacherArray addObject:teacher.textContent];
                    
                    classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)classroomRow-1]];
                    [self.classroomArray addObject:classroom.textContent];
                    [self.classroomArray addObject:classroom.textContent];
                    
                }else{
                    if ([time.textContent isEqualToString:@"2"]) {
                        
                        [self.timeArray addObject:[self.timeArray objectAtIndex:[self.timeArray count]-1]];
                        [self.weekArray addObject:@"2"];
                        
                        subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)subjectRow-1]];
                        [self.subjectArray addObject:subject.textContent];
                        
                        teacher = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)teacherRow-1]];
                        [self.teacherArray addObject:teacher.textContent];
                        
                        classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)classroomRow-1]];
                        [self.classroomArray addObject:classroom.textContent];
                        
                    }else{
                        
                        [self.timeArray addObject:time.textContent];
                        [self.weekArray addObject:week.textContent];
                        [self.subjectArray addObject:subject.textContent];
                        [self.teacherArray addObject:teacher.textContent];
                        [self.classroomArray addObject:classroom.textContent];
                    }
                }
                if ([subject.attributes.allValues.lastObject isEqual:@"2"] && [subject.attributes.allKeys.lastObject isEqual:@"rowspan"]) {
                    section++;
                    
                    [self.timeArray addObject:self.timeArray.lastObject];
                    [self.weekArray addObject:self.weekArray.lastObject];
                    [self.subjectArray addObject:self.subjectArray.lastObject];
                    
                    
                    teacher = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%d)",(long)section,1]];
                    [self.teacherArray addObject:teacher.textContent];
                    
                    classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%d)",(long)section,2]];
                    [self.classroomArray addObject:classroom.textContent];
                    
                }
                
                if ([self.university isEqual:@1]) {
                    if([week.attributes.allValues.lastObject isEqual:@"2"] && [week.attributes.allKeys.lastObject isEqual:@"rowspan"]&&[week.attributes.allValues.firstObject isEqual:@"center"]){
                        
                        section++;
                        
                        [self.timeArray addObject:self.timeArray.lastObject];
                        [self.weekArray addObject:self.weekArray.lastObject];
                        
                        subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%d)",(long)section,1]];
                        [self.subjectArray addObject:subject.textContent];
                        teacher = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%d)",(long)section,2]];
                        [self.teacherArray addObject:teacher.textContent];
                        
                        classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%d)",(long)section,3]];
                        [self.classroomArray addObject:classroom.textContent];
                        
                    }
                    if([time.attributes.allValues.lastObject isEqual:@"2"] && [time.attributes.allKeys.lastObject isEqual:@"rowspan"]&&[time.attributes.allValues.firstObject isEqual:@"center"]){
                        
                        section++;
                        
                        [self.timeArray addObject:self.timeArray.lastObject];
                        [self.weekArray addObject:self.weekArray.lastObject];
                        
                        subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%d)",(long)section,1]];
                        [self.subjectArray addObject:subject.textContent];
                        teacher = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%d)",(long)section,2]];
                        [self.teacherArray addObject:teacher.textContent];
                        
                        classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%d)",(long)section,3]];
                        [self.classroomArray addObject:classroom.textContent];
                        
                    }
                }
            }
            
            for (NSMutableString *time in self.timeArray) {
                NSRange range = [time rangeOfString:@":"];
                if (time.length>7) {
                    if (time.length == 8) {
                        if (![NSStringFromRange(range) isEqualToString:@"{2, 1}"] && ![NSStringFromRange(range) isEqualToString:@"{1, 1}"]) {
                            [time insertString:@"-" atIndex:time.length-4];
                            [time replaceCharactersInRange:NSMakeRange(time.length-3, 1) withString:@":"];
                            [time replaceCharactersInRange:NSMakeRange(time.length-8, 1) withString:@":"];
                        }
                        
                    }else  {
                        
                        if (![NSStringFromRange(range) isEqualToString:@"{2, 1}"] && ![NSStringFromRange(range) isEqualToString:@"{1, 1}"]) {
                            [time insertString:@"-" atIndex:time.length-5];
                            [time replaceCharactersInRange:NSMakeRange(time.length-3, 1) withString:@":"];
                            [time replaceCharactersInRange:NSMakeRange(time.length-9, 1) withString:@":"];
                        }
                    }
                }
            }
            
            
            for (NSInteger i = 0; i<[self.weekArray count]; i++) {
                if ([self.weekArray[i] isEqual:@"2"]) {
                    [self.timeArrayWeekTwo addObject:self.timeArray[i]];
                    [self.weekArrayWeekTwo addObject:self.weekArray[i]];
                    [self.subjectArrayWeekTwo addObject:self.subjectArray[i]];
                    [self.teacherArrayWeekTwo addObject:self.teacherArray[i]];
                    [self.classroomArrayWeekTwo addObject:self.classroomArray[i]];
                }
                [self.tableView reloadData];
            }
            for (NSInteger i = 0; i<[self.weekArray count]; i++) {
                if ([self.weekArray[i] isEqual:@"2"]) {
                    [self.timeArray removeObjectAtIndex:i];
                    [self.weekArray removeObjectAtIndex:i];
                    [self.subjectArray removeObjectAtIndex:i];
                    [self.teacherArray removeObjectAtIndex:i];
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
    }else if ([string isEqualToString:@"8:20-9:50"]) {
        return @"1";
    }else if ([string isEqualToString:@"10:00-11:30"]) {
        return @"2";
    }else if ([string isEqualToString:@"11:40-13:10"]) {
        return @"3";
    }else if ([string isEqualToString:@"13:45-15:15"]) {
        return @"4";
    }else if ([string isEqualToString:@"15:25-16:55"]) {
        return @"5";
    }else if ([string isEqualToString:@"17:05-18:35"]) {
        return @"6";
    }else{
        return @"7";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cellFavTime";
    TableViewCellContent *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (indexPath.section == 0) {
        cell.num.text = [self arrayString:self.timeArray[indexPath.row]];
        cell.time.text = [NSString stringWithFormat:@"Время: %@",self.timeArray[indexPath.row]];
        cell.subject.text = [NSString stringWithFormat:@"Дисциплина: %@",self.subjectArray[indexPath.row]];
        cell.room.text =[NSString stringWithFormat:@"Аудитория: %@",  self.classroomArray[indexPath.row]];
        cell.teacher.text = [NSString stringWithFormat:@"Преподаватель: %@",self.teacherArray[indexPath.row]];
        
    }else if(indexPath.section == 1){
        cell.num.text = [self arrayString:self.timeArrayWeekTwo[indexPath.row]];
        cell.time.text = [NSString stringWithFormat:@"Время: %@",self.timeArrayWeekTwo[indexPath.row]];
        cell.subject.text = [NSString stringWithFormat:@"Дисциплина: %@",self.subjectArrayWeekTwo[indexPath.row]];
        cell.room.text =[NSString stringWithFormat:@"Аудитория: %@",  self.classroomArrayWeekTwo[indexPath.row]];
        cell.teacher.text = [NSString stringWithFormat:@"Преподаватель: %@",self.teacherArrayWeekTwo[indexPath.row]];
        
    }
    
    return cell;
    
}



@end
