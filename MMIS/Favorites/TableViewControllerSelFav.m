//
//  TableViewControllerFav.m
//  DGTU
//
//  Created by Anton Pavlov on 14.02.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewControllerSelFav.h"
#import "TableViewPageContFav.h"
#import "TableViewGraphFav.h"

@interface TableViewControllerSelFav ()

@end

@implementation TableViewControllerSelFav

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.name;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0) {

        TableViewPageContFav *viewControllerPageContent = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewPageContFav"];
        viewControllerPageContent.timeTable = self.tableTime;
        viewControllerPageContent.university = self.university;
        
        [self.navigationController pushViewController:viewControllerPageContent animated:YES];

    }else if (indexPath.row == 1){
        
        TableViewGraphFav *tableViewGraphFav = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewGraphFav"];
        if ([self.university isEqual:@0]) {
            [tableViewGraphFav loadGraph:self.graph sem:self.semester];
        }else if([self.university isEqual:@1]){
            [tableViewGraphFav loadGraph1:self.graph];
        }
        tableViewGraphFav.university = self.university;
        [self.navigationController pushViewController:tableViewGraphFav animated:YES];
        
    }
}






@end
