//
//  TableViewControllerFaculties.m
//  DGTU
//
//  Created by Anton Pavlov on 16.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewControllerFaculties.h"
#import "LeftMenuViewController.h"
#import <HTMLReader.h>




@interface TableViewControllerFaculties ()

@property (strong,nonatomic) NSMutableArray *facul;
@property (strong,nonatomic) NSMutableArray *faculties;
@property (strong,nonatomic) NSMutableArray *faculReferences;
@property (strong,nonatomic) NSString *referenceUniversity;

@end

@implementation TableViewControllerFaculties

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.tableView.separatorColor = [UIColor colorWithRed:0.48 green:0.75 blue:0.97 alpha:1];
    //    self.tableView.separatorColor = [UIColor clearColor];
    
    UIImage *image = [UIImage imageNamed:@"menu-button"];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(slideMenu)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger numberDefaults = [defaults integerForKey:@"number"];
    [SlideNavigationController sharedInstance].enableSwipeGesture = YES;
    if (numberDefaults == 0) {
        self.referenceUniversity = @"http://stud.sssu.ru/";
    } else if(numberDefaults == 1){
        self.referenceUniversity = @"http://umu.sibadi.org/";
    }
    
    [self loadFaculties:[NSString stringWithFormat:@"%@Dek/Default.aspx",self.referenceUniversity]];

}

-(void) slideMenu{
    
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}
- (void) loadFaculties: (NSString*) URLFacul{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.facul= [NSMutableArray array];
        self.faculties= [NSMutableArray array];
        self.faculReferences= [NSMutableArray array];
        NSURL *URL = [NSURL URLWithString:URLFacul];
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
                                                                               [self loadFaculties:URLFacul];
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
                  
                  HTMLElement *div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucFacultets_Grid > tbody > tr:nth-child(%ld) > td:nth-child(1) > a",(long)numFacul]];
                  HTMLElement *facul;
                  
                  while (!(div == nil)) {
                      
                      div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucFacultets_Grid > tbody > tr:nth-child(%ld) > td:nth-child(1) > a",(long)numFacul]];
                      facul = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ctl00_ContentPage_ucFacultets_Grid > tbody > tr:nth-child(%ld) > td:nth-child(2)",(long)numFacul]];
//      old                #_ctl0_ContentPage_ucFacultets_Grid > tbody > tr:nth-child(%ld) > td:nth-child(1) > a
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if (div != nil) {
                              [self.facul addObject:facul.textContent];
                              [self.faculties addObject:div.textContent];
                              [self.faculReferences addObject:div.attributes.allValues.lastObject];
                              [self.tableView reloadData ];
                          }
                      });
                      numFacul++;
                  }
              }
          }] resume];
    });
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.faculties count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellFacul";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = self.facul[indexPath.row];
    cell.detailTextLabel.text = self.faculties[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableViewControllerGroup * tableViewControllerGroup = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewControllerGroup"];
    tableViewControllerGroup.referenceUniversity = self.referenceUniversity;
    tableViewControllerGroup.titleName = self.facul[indexPath.row];
    [tableViewControllerGroup loadGroup:[NSString stringWithFormat:@"%@Dek/Default.aspx%@",tableViewControllerGroup.referenceUniversity,self.faculReferences[indexPath.row]]];
    
    [self.navigationController showViewController:tableViewControllerGroup sender:nil];
    
}


@end
