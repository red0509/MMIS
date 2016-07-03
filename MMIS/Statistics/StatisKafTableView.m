//
//  StatisKafTableView.m
//  MMIS
//
//  Created by Anton Pavlov on 01.07.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "StatisKafTableView.h"
#import "KafTableView.h"



@interface StatisKafTableView ()

@end

@implementation StatisKafTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Статистика кафедры";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] ;
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Не заполнена КТ";
            cell.detailTextLabel.text = self.noKT;
            if (![self.noKT isEqualToString:@"0"]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
        case 1:
            cell.textLabel.text = @"Не заполнен рейтинг";
            cell.detailTextLabel.text = self.noRating;
            if (![self.noRating isEqualToString:@"0"]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
        case 2:
            cell.textLabel.text = @"Не закрыто";
            cell.detailTextLabel.text = self.noClosed;
            if (![self.noClosed isEqualToString:@"0"]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
        case 3:
            cell.textLabel.text = @"Пустых";
            cell.detailTextLabel.text = self.empty;
            if (![self.empty isEqualToString:@"0"]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
        default:
            break;
    }

    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KafTableView *kaf = [[KafTableView alloc]init];
    switch (indexPath.row) {
        case 0:
            kaf.status = @"Не заполнена КТ";
            kaf.reference = self.noKTRef;
            if (![self.noKT isEqualToString:@"0"]) {
                [self.navigationController pushViewController:kaf animated:YES];
                
            }
            break;
        case 1:
            kaf.status = @"Не заполнен рейтинг";
            kaf.reference = self.noRatingRef;
            if (![self.noRating isEqualToString:@"0"]) {
                [self.navigationController pushViewController:kaf animated:YES];
                
            }
            break;
        case 2:
            kaf.status = @"Не закрыто";
            kaf.reference = self.noClosedRef;
            if (![self.noClosed isEqualToString:@"0"]) {
                [self.navigationController pushViewController:kaf animated:YES];
            }
            break;
        case 3:
            kaf.status = @"Пустых";
            kaf.reference = self.emptyRef;
            if (![self.empty isEqualToString:@"0"]) {
                [self.navigationController pushViewController:kaf animated:YES];
            }
            break;
        default:
            break;
    }
}


@end
