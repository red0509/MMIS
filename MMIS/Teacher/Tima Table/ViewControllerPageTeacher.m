//
//  ViewControllerPageTeacher.m
//  DGTU
//
//  Created by Anton Pavlov on 25.03.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "ViewControllerPageTeacher.h"

@interface ViewControllerPageTeacher ()

@property(strong,nonatomic) TableViewPageContTeacher * content;
@property(assign,nonatomic) NSInteger index;

@end

@implementation ViewControllerPageTeacher

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    self.pageTitles = @[@"Понедельник", @"Вторник", @"Среда", @"Четверг",@"Пятница",@"Суббота"];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.view.backgroundColor = [UIColor clearColor];
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"EEEE"];
    NSString * strintDate = [dateFormatter stringFromDate:date];
    if ([strintDate isEqualToString:@"понедельник"]) {
        self.index=0;
    }else if([strintDate isEqualToString:@"вторник"]){
        self.index=1;
    }else if([strintDate isEqualToString:@"среда"]){
        self.index=2;
    }else if([strintDate isEqualToString:@"четверг"]){
        self.index=3;
    }else if([strintDate isEqualToString:@"пятница"]){
        self.index=4;
    }else if([strintDate isEqualToString:@"суббота"]){
        self.index=5;
    }else{
        self.index=0;
    }
    TableViewPageContTeacher *startingViewController = [self viewControllerAtIndex:self.index];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
//    self.pageViewController.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 100);
//    
//    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
//         self.pageViewController.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 100);
//    }else if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])){
//         self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height - 100);
//    }
    
    [self OrientationDidChange];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
    
   
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];

}

-(void)OrientationDidChange
{
    UIDeviceOrientation Orientation=[[UIDevice currentDevice]orientation];
    
    if(Orientation==UIDeviceOrientationLandscapeLeft || Orientation==UIDeviceOrientationLandscapeRight){
         self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height - 70);
    }else if(Orientation==UIDeviceOrientationPortrait || Orientation == UIDeviceOrientationFaceUp){
        self.pageViewController.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 100);
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (TableViewPageContTeacher *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    TableViewPageContTeacher *viewControllerPageContent = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewPageContTeacher"];

    viewControllerPageContent.titleText = self.pageTitles[index];
    viewControllerPageContent.pageIndex = index;
    viewControllerPageContent.tableTime = self.tableTime;
    viewControllerPageContent.graph = self.graph;
    viewControllerPageContent.reference = self.reference;
    return viewControllerPageContent;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TableViewPageContTeacher*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TableViewPageContTeacher*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    
    return self.index;
}


@end
