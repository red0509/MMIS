//
//  TableViewSettings.m
//  DGTU
//
//  Created by Anton Pavlov on 07.05.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewSettings.h"
#import "TableViewSettingsUniversity.h"
#import "LeftMenuViewController.h"


@interface TableViewSettings ()

@end

@implementation TableViewSettings

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Настройки";
    
    UIImage *image = [UIImage imageNamed:@"menu-button"];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(slideMenu)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleData) name:@"reload_data" object:nil];
    [SlideNavigationController sharedInstance].enableSwipeGesture = YES;
}

-(void)handleData {
    [self.tableView reloadData];
}

-(void) slideMenu{
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger numberDefaults = [defaults integerForKey:@"number"];
    static NSString *identifier = @"cellSet";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = @"Университет";
    switch (numberDefaults) {
        case 0:
            cell.detailTextLabel.text = @"ИСОиП (филиала) ДГТУ";
            break;
        case 1:
            cell.detailTextLabel.text = @"ФГБОУ ВО СибАДИ";
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController * university = [mainStoryboard   instantiateViewControllerWithIdentifier:@"TableViewSettingsUniversity"] ;
    UINavigationController *navigation = [mainStoryboard   instantiateViewControllerWithIdentifier:@"nav"];
    (void) [navigation initWithRootViewController:university];
    switch (indexPath.row) {
        case 0:
            [self.navigationController  presentViewController:navigation animated:YES completion:nil];
            break;
        default:
            break;
    }
}

@end
