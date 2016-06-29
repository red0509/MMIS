//
//  TableViewDepartment.m
//  DGTU
//
//  Created by Anton Pavlov on 01.05.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewDepartment.h"
#import <HTMLReader.h>
#import "TableViewTeacher.h"
#import "LeftMenuViewController.h"


@interface TableViewDepartment ()

@property (strong,nonatomic) NSMutableArray *name;
@property (strong,nonatomic) NSMutableArray *ref;


@end

@implementation TableViewDepartment

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 68.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.title = @"Кафедры";
    [SlideNavigationController sharedInstance].leftBarButtonItem = self.navigationItem.leftBarButtonItem;
    [SlideNavigationController sharedInstance].enableSwipeGesture = YES;
    
    [self loadDept];
    
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
    // Dispose of any resources that can be recreated.
}


-(void) loadDept{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.name= [NSMutableArray array];
        self.ref= [NSMutableArray array];
        NSURL *URL = [NSURL URLWithString:@"http://stud.sssu.ru/Dek/Default.aspx?mode=kaf"];
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
                  
                  NSString *contentType = nil;
                  if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                      NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
                      contentType = headers[@"Content-Type"];
                  }
                  
                  HTMLDocument *home = [HTMLDocument documentWithData:data
                                                    contentTypeHeader:contentType];
                  NSInteger numFacul = 2;
                  
                  HTMLElement *div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(1) > a",(long)numFacul]];
                  HTMLElement *ref;
                                    
                  while (!(div == nil)) {
                      
                      div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(1) > a",(long)numFacul]];
                      ref = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(2) > a",(long)numFacul]];
                     
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if (div != nil) {
                              
                              [self.name addObject:div.textContent];
                              [self.ref addObject:ref.attributes.allValues.firstObject];

                              [self.tableView reloadData];
                          }
                      });
                      
                      numFacul++;
                      
                  }
                }
          }] resume];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.name count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellDepTeach";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = self.name[indexPath.row];

    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableViewTeacher * tableViewTeacher = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewTeacher"];
    
    tableViewTeacher.nameSize = [NSString stringWithFormat:@"http://stud.sssu.ru%@",self.ref[indexPath.row]];
    
    [self.navigationController pushViewController:tableViewTeacher animated:YES];
    
}

@end
