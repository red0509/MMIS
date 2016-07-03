//
//  TableViewRegisterContent.m
//  DGTU
//
//  Created by Anton Pavlov on 26.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewRegisterContent.h"
#import <HTMLReader.h>
#import "TableViewCellRegister.h"

@interface TableViewRegisterContent ()

@property (strong,nonatomic) NSMutableArray *nameArray;
@property (strong,nonatomic) NSMutableArray *lecArray;
@property (strong,nonatomic) NSMutableArray *praArray;
@property (strong,nonatomic) NSMutableArray *labArray;
@property (strong,nonatomic) NSMutableArray *drArray;
@property (strong,nonatomic) NSMutableArray *totalArray;
@property (strong,nonatomic) NSMutableArray *examArray;
@property (strong,nonatomic) NSMutableArray *examNumArray;
@property (strong,nonatomic) NSMutableArray *projectNameArray;
@property (strong,nonatomic) NSMutableArray *projectExamArray;

@property (strong,nonatomic) HTMLDocument *htmlHome;
@end

@implementation TableViewRegisterContent

#define STATE_EXAM 30
#define PRACTICE 30
#define GRADUATION_WORK 30
#define COURSE_PROJECT 40
#define COURSE_WORK 40

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Ведомости";
    
    [self.segmented removeAllSegments];
    for (int i = 0; i<[self.arrayPage count];i++) {
        [self.segmented insertSegmentWithTitle:self.arrayPage[i] atIndex:i animated:NO];
    }
    
    self.segmented.selectedSegmentIndex = 0;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.viewSeg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"NavBar.png"]];
    self.tableView.estimatedRowHeight = 68.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self firstLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (void) firstLoad{
    if ([self.arrayPage[0] isEqualToString:@"КT 1"]) {
        [self loadReference:
         [NSString stringWithFormat:@"%@Ved/%@",self.referenceUniversity ,self.referenceContent] KT:4];
    }else if ([self.arrayPage[0] isEqualToString:@"Экзамен"] ||
              [self.arrayPage[0] isEqualToString:@"Зачет"]){
        
        NSInteger num;
        switch ([self.arrayPage count]) {
            case 2:
                num = 0;
                break;
            case 3:
                num = 5;
                break;
            case 4:
                num = 10;
                break;
            case 5:
                num = 15;
                break;
            case 6:
                num = 20;
                break;
            case 7:
                num = 25;
                break;
            default:
                break;
        }
        
        [self loadReference:
         [NSString stringWithFormat:@"%@Ved/%@",self.referenceUniversity ,self.referenceContent] KT:num];
    }else if ([self.arrayPage[0] isEqualToString:@"Практика"] ||
              [self.arrayPage[0] isEqualToString:@"ГосЭкзамен"] ||
              [self.arrayPage[0] isEqualToString:@"Выпуская работа"]){
        
        [self loadReference:
         [NSString stringWithFormat:@"%@Ved/%@",self.referenceUniversity ,self.referenceContent] KT:50];
    }else if ([self.arrayPage[0] isEqualToString:@"Курсовой проект"] ||
              [self.arrayPage[0] isEqualToString:@"Курсовая работа"]){
        
        [self loadReference:
         [NSString stringWithFormat:@"%@Ved/%@",self.referenceUniversity ,self.referenceContent] KT:40];
    }

}

- (IBAction)actionSegmented:(id)sender {
    
    if ([self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"КT 1"]) {
        [self loadRegister:self.htmlHome KT:4];
         
    }else if ([self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"КT 2"]) {
        [self loadRegister:self.htmlHome KT:9];
    
    }else if ([self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"КT 3"]){
        [self loadRegister:self.htmlHome KT:14];
        
    }else if ([self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"КT 4"]){
        [self loadRegister:self.htmlHome KT:19];
        
    }else if ([self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"КT 5"]){
        [self loadRegister:self.htmlHome KT:24];
        
    }else if ([self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"КT 6"]){
        [self loadRegister:self.htmlHome KT:29];
        
    }else if ([self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Экзамен"] ||
              [self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Зачет"]){
        
        NSInteger num;
        switch ([self.arrayPage count]) {
            case 2:
                num = 0;
                break;
            case 3:
                num = 5;
                break;
            case 4:
                num = 10;
                break;
            case 5:
                num = 15;
                break;
            case 6:
                num = 20;
                break;
            case 7:
                num = 25;
                break;
            default:
                break;
        }
        [self loadRegister:self.htmlHome KT:num];
        
    }else if ([self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Практика"] ||
              [self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"ГосЭкзамен"] ||
              [self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Выпуская работа"]){
        [self loadRegister:self.htmlHome KT:50];
        
    }else if ([self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Курсовой проект"] ||
              [self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Курсовая работа"]){
        [self loadRegister:self.htmlHome KT:40];
        
    }
    
}

-(void) loadReference:(NSString*) URLGroup KT:(NSInteger)KT{
    
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
                                                                           [self loadReference:URLGroup KT:KT];
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
                  
                  [self loadRegister:home KT:KT];
              });
              
          }
      }] resume];
}

-(void) loadRegister:(HTMLDocument*) home KT:(NSInteger)KT{
    
    self.nameArray = [NSMutableArray array];
    self.lecArray = [NSMutableArray array];
    self.praArray = [NSMutableArray array];
    self.labArray = [NSMutableArray array];
    self.drArray = [NSMutableArray array];
    self.totalArray = [NSMutableArray array];
    self.examArray = [NSMutableArray array];
    self.examNumArray = [NSMutableArray array];
    self.projectNameArray = [NSMutableArray array];
    self.projectExamArray = [NSMutableArray array];
    
    NSInteger nameNum = 5;
    
    HTMLElement *name;
    
    while (YES) {
        
        name = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(3)",(long)nameNum]];
        
        if (name != nil) {
            [self.nameArray addObject:name.textContent];
            
        }else{
            break;
        }
        [self.tableView reloadData];
        nameNum++;
    }
    nameNum -=5;
    
    HTMLElement *projectName;
    HTMLElement *projectExam;
    
    
    if (KT == 50) {
        for (NSInteger i = 5; i<nameNum+5; i++) {
            
            projectName = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(12)",(long)i]];
            
            if ([projectName.textContent isEqualToString:@""]) {
                projectName = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(10)",(long)i]];
                
                if ([projectName.textContent isEqualToString:@""]) {
                    projectName = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(8)",(long)i]];
                    
                    if ([projectName.textContent isEqualToString:@""]) {
                        projectName = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(5)",(long)i]];
                        if ([projectName.textContent isEqualToString:@""]) {
                            [self.projectExamArray addObject:@" "];
                        }else{
                            [self.projectExamArray addObject:projectName.textContent];
                        }
                        
                    }else{
                        [self.projectExamArray addObject:projectName.textContent];
                    }
                    
                }else{
                    [self.projectExamArray addObject:projectName.textContent];
                }
                
            }else{
                [self.projectExamArray addObject:projectName.textContent];
            }
            [self.tableView reloadData];
        }
    }
    
    if (KT == 40) {
        
        for (NSInteger i = 5; i<nameNum+5; i++) {
            
            projectName = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(13)",(long)i]];
            if ([projectName.textContent isEqualToString:@""]) {
                [self.projectNameArray addObject:@" "];
            }else{
                [self.projectNameArray addObject:projectName.textContent];
            }
            
            projectExam = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(12)",(long)i]];
            
            if ([projectExam.textContent isEqualToString:@""]) {
                projectExam = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(10)",(long)i]];
                
                if ([projectExam.textContent isEqualToString:@""]) {
                    projectExam = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(8)",(long)i]];
                    
                    if ([projectExam.textContent isEqualToString:@""]) {
                        projectExam = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(5)",(long)i]];
                        if ([projectExam.textContent isEqualToString:@""]) {
                            [self.projectExamArray addObject:@" "];
                        }else{
                            [self.projectExamArray addObject:projectExam.textContent];
                        }
                        
                    }else{
                        [self.projectExamArray addObject:projectExam.textContent];
                    }
                    
                }else{
                    [self.projectExamArray addObject:projectExam.textContent];
                }
                
            }else{
                
                [self.projectExamArray addObject:projectExam.textContent];
            }
            [self.tableView reloadData];
            
        }
    }
    
    
    HTMLElement *pred;
    if (KT>=4 && KT<=29) {
        
        for (NSInteger i = 5; i<nameNum+5; i++) {
            
            pred = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)i,(long)KT]];
            if (pred == nil) {
                [self.lecArray addObject:@" "];
            }else{
                [self.lecArray addObject:pred.textContent];
            }
            
            pred = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)i,KT+1]];
            if (pred == nil) {
                [self.praArray addObject:@" "];
            }else{
                [self.praArray addObject:pred.textContent];
            }
            
            pred = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)i,KT+2]];
            if (pred == nil) {
                [self.labArray addObject:@" "];
            }else{
                [self.labArray addObject:pred.textContent];
            }
            
            pred = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)i,KT+3]];
            if (pred == nil) {
                [self.drArray addObject:@" "];
            }else{
                [self.drArray addObject:pred.textContent];
            }
            
            pred = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)i,KT+4]];
            if (pred == nil) {
                [self.totalArray addObject:@" "];
            }else{
                [self.totalArray addObject:pred.textContent];
            }
            
            [self.tableView reloadData];
        }
    }
    
    HTMLElement *examNum;
    HTMLElement *exam;
    
    for (NSInteger i = 5; i<nameNum+5; i++) {
        
        examNum = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)i,10+KT]];
        
        if ([examNum.textContent isEqualToString:@""] || examNum == nil) {
            [self.examNumArray addObject:@" "];
        }else{
            [self.examNumArray addObject:examNum.textContent];
        }
        
        exam = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)i,20+KT]];
        
        if ([exam.textContent isEqualToString:@""] || exam == nil) {
            exam = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)i,18+KT]];
            if ([exam.textContent isEqualToString:@""] || exam == nil) {
                exam = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)i,16+KT]];
                if ([exam.textContent isEqualToString:@""] || exam == nil) {
                    exam = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)i,13+KT]];
                    if ([exam.textContent isEqualToString:@""] || exam == nil) {
                        [self.examArray addObject:@" "];
                    }else{
                        [self.examArray addObject:exam.textContent];
                    }
                }else{
                    [self.examArray addObject:exam.textContent];
                }
            }else{
                [self.examArray addObject:exam.textContent];
            }
        }else{
            [self.examArray addObject:exam.textContent];
        }
        
        [self.tableView reloadData];
    }
    [self.tableView reloadData];
}






#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Экзамен"] ||
        [self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Зачет"]) {
        
        return 2.f;
        
    }else if ([self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Практика"] ||
              [self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"ГосЭкзамен"] ||
              [self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Выпуская работа"]) {
        
        return 2.f;
    }else if ([self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Курсовой проект"] ||
              [self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Курсовая работа"]) {
        
        return 2.f;
    }else{
        return 30.f;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if ([self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Экзамен"] ||
        [self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Зачет"]) {
        
        return 2.f;
        
    }else if ([self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Практика"] ||
              [self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"ГосЭкзамен"] ||
              [self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Выпуская работа"]) {
        
        return 2.f;
    }else if ([self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Курсовой проект"] ||
              [self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Курсовая работа"]) {
        
        return 2.f;
    }else{
        return 30.f;
        
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if ([self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Экзамен"] ||
        [self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Зачет"]) {
        
        return nil;
        
    }else if ([self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Практика"] ||
              [self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"ГосЭкзамен"] ||
              [self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Выпуская работа"]) {
        
        return nil;
    }else if ([self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Курсовой проект"] ||
              [self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Курсовая работа"]) {
        
        return nil;
    }else{
        UIView *sectionHeaderView = [[UIView alloc] initWithFrame:
                                     CGRectMake(0, 0, tableView.frame.size.width, 20)];
        //        sectionHeaderView.backgroundColor = [UIColor colorWithRed:100.0f/255.0f green:181.0f/255.0f blue:246.0f/255.0f alpha:1.f];
        sectionHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"NavBar.png"]];
        UILabel *lec = [[UILabel alloc] initWithFrame:
                        CGRectMake(130, 10, 50, 15)];
        UILabel *pra = [[UILabel alloc] initWithFrame:
                        CGRectMake(180, 10, 50, 15)];
        UILabel *lab = [[UILabel alloc] initWithFrame:
                        CGRectMake(230, 10, 50, 15)];
        UILabel *dr = [[UILabel alloc] initWithFrame:
                       CGRectMake(280, 10, 50, 15)];
        
        
        lec.textColor = [UIColor whiteColor];
        lec.backgroundColor = [UIColor clearColor];
        lec.textAlignment = NSTextAlignmentLeft;
        [lec setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        
        pra.textColor = [UIColor whiteColor];
        pra.backgroundColor = [UIColor clearColor];
        pra.textAlignment = NSTextAlignmentLeft;
        [pra setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        
        lab.textColor = [UIColor whiteColor];
        lab.backgroundColor = [UIColor clearColor];
        lab.textAlignment = NSTextAlignmentLeft;
        [lab setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        
        dr.textColor = [UIColor whiteColor];
        dr.backgroundColor = [UIColor clearColor];
        dr.textAlignment = NSTextAlignmentLeft;
        [dr setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        
        [sectionHeaderView addSubview:lec];
        [sectionHeaderView addSubview:pra];
        [sectionHeaderView addSubview:lab];
        [sectionHeaderView addSubview:dr];
        
        lec.text = @"Лек.";
        pra.text = @"Пр.";
        lab.text = @"Лаб.";
        dr.text = @"Др.";
        
        return sectionHeaderView;
        
    }
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.nameArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = nil;
    TableViewCellRegister *cell = nil;
    
    if ([self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Экзамен"] ||
        [self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Зачет"]){
        identifier = @"cellExam";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.nameLabel.text = self.nameArray[indexPath.row];
        cell.examNumLabel.text =  [NSString stringWithFormat:@"Итоговый Рейтинг: %@",self.examNumArray[indexPath.row]];
        cell.examLabel.text =  [NSString stringWithFormat:@"Итог: %@",self.examArray[indexPath.row]];
        
    }else if([self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Практика"] ||
             [self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"ГосЭкзамен"] ||
             [self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Выпуская работа"]){
        
        identifier = @"cellPra";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.NamePra.text = self.nameArray[indexPath.row];
        cell.numPra.text =[NSString stringWithFormat:@"Оценка: %@",self.projectExamArray[indexPath.row]];
        
    }else if([self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Курсовой проект"] ||
             [self.arrayPage[self.segmented.selectedSegmentIndex] isEqualToString:@"Курсовая работа"]){
        
        identifier = @"cellProject";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.projectNameLabel.text = self.nameArray[indexPath.row];
        cell.projectNumLabel.text =[NSString stringWithFormat:@"Оценка: %@",self.projectExamArray[indexPath.row]];
        cell.project.text =[NSString stringWithFormat:@"Тема: %@",self.projectNameArray[indexPath.row]];
    }   else  {
        identifier = @"cellRegister";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.nameLabel.text = self.nameArray[indexPath.row];
        cell.lecLabel.text = self.lecArray[indexPath.row];
        cell.praLabel.text = self.praArray[indexPath.row];
        cell.labLabel.text = self.labArray[indexPath.row];
        cell.drLabel.text = self.drArray[indexPath.row];
        cell.totalLabel.text = self.totalArray[indexPath.row];
        cell.totalLabel.text = [NSString stringWithFormat:@"Итог по КТ: %@" ,self.totalArray[indexPath.row]];
        
    }
    
    return cell;
}




@end
