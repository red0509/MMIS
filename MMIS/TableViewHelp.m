//
//  TableViewHelp.m
//  DGTU
//
//  Created by Anton Pavlov on 02.05.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewHelp.h"
#import "LeftMenuViewController.h"


@interface TableViewHelp ()

@end

@implementation TableViewHelp

- (void)viewDidLoad {
    [super viewDidLoad];
      
    self.tableView.estimatedRowHeight = 135.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UIImage *image = [UIImage imageNamed:@"menu-button"];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(slideMenu)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
     [SlideNavigationController sharedInstance].enableSwipeGesture = YES;
}

-(void) slideMenu{
    
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*) weekNum{
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *date = [gregorian dateFromComponents:components];
    
    NSDate *date2 = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString * strintDate = [dateFormatter stringFromDate:date2];
    NSInteger intDate = [strintDate integerValue];
    if (intDate > 8 || intDate == 1) {
        [components setDay:3];
        [components setMonth:9];
        [components setYear:intDate];
    }else{
        [components setDay:3];
        [components setMonth:2];
        [components setYear:intDate];
    }
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:date toDate:date2 options:0];
    NSInteger week = [comp weekOfYear];
    NSString *weekNum;
    if (week%2==0) {
        weekNum = @"Первая";
    }else{
        weekNum = @"Вторая";
    }
    
    return weekNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellHelp";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"%@ неделя",[self weekNum]];
            break;
        case 1:
            cell.textLabel.text = @"Преподаватель - расписание занятий преподавателей";
            break;
        case 2:
            cell.textLabel.text = @"Учебная группа - расписание занятий учебных групп, семестровые графики учебного процесса с датами контрольных точек и экзаменов, и электронные ведомости";
            break;
        case 3:
            cell.textLabel.text = @"Избранное - быстрый доступ к сохраненному расписанию, не используя Интернет-соединения";
            break;
        case 4:
            cell.textLabel.text = @"Кафедры - информация о телефонах, аудиториях кафедр";
            break;
            
        default:
            break;
    }
    
    
    return cell;
    
}


@end
