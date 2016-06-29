//
//  TableViewControllerDept.m
//  DGTU
//
//  Created by Anton Pavlov on 29.02.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewControllerDept.h"
#import <HTMLReader.h>
#import "TableViewCellDept.h"
#import "LeftMenuViewController.h"


@interface TableViewControllerDept ()
@property (strong,nonatomic) NSMutableArray *name;
@property (strong,nonatomic) NSMutableArray *zavDept;
@property (strong,nonatomic) NSMutableArray *number;
@property (strong,nonatomic) NSMutableArray *cab;
@property (strong,nonatomic) NSMutableArray *ref;
@property (nonatomic, strong) NSString *nameSize;

@end

@implementation TableViewControllerDept

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 68.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.title = @"Кафедры";
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger numberDefaults = [defaults integerForKey:@"number"];
    
    NSString *referenceUniversity;
    
    [SlideNavigationController sharedInstance].enableSwipeGesture = YES;
    
    if (numberDefaults == 0) {
        referenceUniversity = @"http://stud.sssu.ru/";
    } else if(numberDefaults == 1){
        referenceUniversity = @"http://umu.sibadi.org/";
    }
    
    [self loadDept:referenceUniversity];
    UIImage *image = [UIImage imageNamed:@"menu-button"];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(slideMenu)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
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
}


-(void) loadDept: (NSString*) reference{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.name = [NSMutableArray array];
        self.zavDept = [NSMutableArray array];
        self.number = [NSMutableArray array];
        self.cab = [NSMutableArray array];
        self.ref = [NSMutableArray array];
        
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@Dek/Default.aspx?mode=kaf",reference]];
        
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
                                                                               [self loadDept:reference];
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
                  
                  if ([reference isEqualToString:@"http://stud.sssu.ru/"]) {
                      [self universityZero:home];
                  } else if([reference isEqualToString:@"http://umu.sibadi.org/"]){
                      [self universityOne:home];
                  }
                  

              }
          }] resume];
    });
}

- (void) universityZero: (HTMLDocument*) home{
    

    NSInteger numFacul = 2;
    
    HTMLElement *div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(1) > a",(long)numFacul]];
    HTMLElement *zav;
    HTMLElement *num;
    HTMLElement *cab;
    
    
    while (!(div == nil)) {
        
        div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(1) > a",(long)numFacul]];
        
        zav = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(3)",(long)numFacul]];
        num = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(4)",(long)numFacul]];
        cab = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(5)",(long)numFacul]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (div != nil) {
                
                [self.name addObject:div.textContent];
                //                              [self.ref addObject:div.attributes.allValues.firstObject];
                [self.zavDept addObject:zav.textContent];
                [self.number addObject:num.textContent];
                [self.cab addObject:cab.textContent];
                [self.tableView reloadData];
            }
        });
        numFacul++;
    }
}

- (void) universityOne: (HTMLDocument*) home{
    
    
    NSInteger numFacul = 2;
    
    HTMLElement *div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(2)",(long)numFacul]];
    HTMLElement *zav;
    HTMLElement *num;
    HTMLElement *cab;
    
    
    while (!(div == nil)) {
        
        div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(2)",(long)numFacul]];
        zav = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(4)",(long)numFacul]];
        num = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(5)",(long)numFacul]];
        cab = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(6)",(long)numFacul]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (div != nil) {
                
                [self.name addObject:div.textContent];
                [self.zavDept addObject:zav.textContent];
                [self.number addObject:num.textContent];
                [self.cab addObject:cab.textContent];
                [self.tableView reloadData];
            }
        });
        numFacul++;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.name count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellDept";
    TableViewCellDept *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.labelName.text = self.name[indexPath.row];
    cell.labelZav.text =  [NSString stringWithFormat:@"Зав. Кафедрой: %@",self.zavDept[indexPath.row]];
    cell.labelNum.text = [NSString stringWithFormat:@"Телефон: %@",self.number[indexPath.row]];
    cell.labelCab.text = [NSString stringWithFormat:@"Аудитория: %@",self.cab[indexPath.row]];
    
    return cell;
    
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSURL *url = [NSURL URLWithString:self.ref[indexPath.row]];
//    
//    if (![[UIApplication sharedApplication] openURL:url]) {
//    }}

@end
