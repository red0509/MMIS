//
//  InfoController.m
//  DGTU
//
//  Created by Anton Pavlov on 04.05.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "InfoController.h"
#import "LeftMenuViewController.h"


@interface InfoController ()

@end

@implementation InfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"О программе";
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
}


@end
