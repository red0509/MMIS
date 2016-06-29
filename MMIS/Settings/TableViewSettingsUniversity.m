//
//  TableViewSettings.m
//  DGTU
//
//  Created by Anton Pavlov on 06.05.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewSettingsUniversity.h"


@interface TableViewSettingsUniversity ()
@property (assign,nonatomic) NSInteger yesNo;
@property UIBarButtonItem *rightBarButtonItem;
@property UIBarButtonItem *leftBarButtonItem;
@end

@implementation TableViewSettingsUniversity

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Университет";
    self.yesNo = 1;
    
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Готово" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    self.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Отмена" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
    
    
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger numberDefaults = [defaults integerForKey:@"number"];
    NSIndexPath *index = [NSIndexPath indexPathForRow:numberDefaults inSection:0];
    
    [self tableView:self.tableView willSelectRowAtIndexPath:index];
}

-(void) done{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger numberDefaults = [defaults integerForKey:@"number"];
    
    NSIndexPath *oldIndex = [self.tableView indexPathForSelectedRow];
    
    if (numberDefaults != oldIndex.row) {
        [defaults setInteger:oldIndex.row forKey:@"number"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void) cancel{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cellSettings";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"ИСОиП (филиала) ДГТУ в г. Шахты";
            break;
        case 1:
            cell.textLabel.text = @"ФГБОУ ВО СибАДИ";
            break;
        default:
            break;
    }
    return cell;
}




-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *oldIndex;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger numberDefaults = [defaults integerForKey:@"number"];
    if (self.yesNo == 1) {
        oldIndex =[NSIndexPath indexPathForRow:numberDefaults inSection:0];
        self.yesNo = 2;
    }else if(self.yesNo == 2){
        oldIndex =[NSIndexPath indexPathForRow:numberDefaults inSection:0];
        self.yesNo = 3;
        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    }else if(self.yesNo == 3){
        oldIndex = [self.tableView indexPathForSelectedRow];
    }
    
    [self.tableView cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
    [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    return indexPath;
    
}



@end
