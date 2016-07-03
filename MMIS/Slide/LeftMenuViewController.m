//
//  LeftMenuViewController.m
//  DGTU
//
//  Created by Anton Pavlov on 01.03.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "TableViewCellMenu.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"
#import "TableViewSettings.h"
#import "PlanTableView.h"
#import "StatisTableView.h"


#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController

#pragma mark - UIViewController Methods -

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.slideOutAnimationEnabled = YES;
    
    return [super initWithCoder:aDecoder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    id <SlideNavigationContorllerAnimator> revealAnimator;
    CGFloat animationDuration = 0;

    self.tableView.separatorColor = [UIColor clearColor];
    
    
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    revealAnimator = [[SlideNavigationContorllerAnimatorSlideAndFade alloc] initWithMaximumFadeAlpha:.8 fadeColor:[UIColor blackColor] andSlideMovement:100];
    animationDuration = .19;
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = animationDuration;
    [SlideNavigationController sharedInstance].menuRevealAnimator = revealAnimator;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu.jpg"]];
    self.tableView.backgroundView = imageView;
    
    if ( IDIOM == IPAD ) {
        [SlideNavigationController sharedInstance].portraitSlideOffset = 500.0;
        [SlideNavigationController sharedInstance].landscapeSlideOffset = 500.0;
        [SlideNavigationController sharedInstance].panGestureSideOffset = 500;
    } else {
        [SlideNavigationController sharedInstance].portraitSlideOffset = 120.0;
        [SlideNavigationController sharedInstance].landscapeSlideOffset = 200.0;
        [SlideNavigationController sharedInstance].panGestureSideOffset = 100;
    }


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleData) name:@"reload_data" object:nil];
    
}

-(void)handleData {
    [self.tableView reloadData];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}



#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger numberDefaults = [defaults integerForKey:@"number"];
    NSInteger count;
    if (numberDefaults == 0) {
        count = 9;
    } else if (numberDefaults == 1){
        count = 6;
    }
    return count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{static NSString *identifier = @"leftMenuCell";
    TableViewCellMenu *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger numberDefaults = [defaults integerForKey:@"number"];
    
    if (numberDefaults == 0) {
        switch (indexPath.row)
        {
                
            case 0:
                cell.labelName.text = @"Преподаватели";
                cell.image.image = [UIImage imageNamed:@"social.png"];
                break;
                
            case 1:
                cell.labelName.text = @"Группы";
                cell.image.image = [UIImage imageNamed:@"users.png"];
                break;
                
            case 2:
                cell.labelName.text = @"Избранное";
                cell.image.image = [UIImage imageNamed:@"star.png"];
                break;
                
            case 3:
                cell.labelName.text = @"Кафедры";
                cell.image.image = [UIImage imageNamed:@"tribune.png"];
                break;
                
            case 4:
                cell.labelName.text = @"Планы";
                cell.image.image = [UIImage imageNamed:@"book.png"];
                break;
                
            case 5:
                cell.labelName.text = @"Статистика";
                cell.image.image = [UIImage imageNamed:@"statis.png"];
                break;
                
            case 6:
                cell.labelName.text = @"Настройки";
                cell.image.image = [UIImage imageNamed:@"settings.png"];
                break;
                
            case 7:
                cell.labelName.text = @"Справка";
                cell.image.image = [UIImage imageNamed:@"signs.png"];
                break;
                
            case 8:
                cell.labelName.text = @"О программе";
                cell.image.image = [UIImage imageNamed:@"information-button.png"];
                break;
        }
    } else if (numberDefaults == 1){
        switch (indexPath.row)
        {
                
            case 0:
                cell.labelName.text = @"Учебная группа";
                cell.image.image = [UIImage imageNamed:@"users.png"];
                break;
                
            case 1:
                cell.labelName.text = @"Избранное";
                cell.image.image = [UIImage imageNamed:@"star.png"];
                break;
                
            case 2:
                cell.labelName.text = @"Кафедры";
                cell.image.image = [UIImage imageNamed:@"tribune.png"];
                break;
                
            case 3:
                cell.labelName.text = @"Настройки";
                cell.image.image = [UIImage imageNamed:@"settings.png"];
                break;
                
            case 4:
                cell.labelName.text = @"Справка";
                cell.image.image = [UIImage imageNamed:@"signs.png"];
                break;
                
            case 5:
                cell.labelName.text = @"О программе";
                cell.image.image = [UIImage imageNamed:@"information-button.png"];
                break;
        }
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    UIViewController *vc ;
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger numberDefaults = [defaults integerForKey:@"number"];
    if (numberDefaults == 0) {
        switch (indexPath.row)
        {
                
            case 0:
                
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"TableViewDepartment"];
                break;
                
            case 1:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"TableViewControllerFaculties"];
                break;
                
            case 2:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"TableViewFav"];
                break;
                
            case 3:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"TableViewControllerDept"];
                break;
            case 4:
                vc = [[PlanTableView alloc] init];
                break;
            case 5:
                vc = [[StatisTableView alloc]init];
                break;
            case 6:
                vc = [[TableViewSettings alloc] init];
                break;
                
            case 7:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"TableViewHelp"];
                break;
            case 8:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"InfoController"];
                break;
        }

    } else if (numberDefaults == 1){
        switch (indexPath.row)
        {
                
            case 0:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"TableViewControllerFaculties"];
                break;
                
            case 1:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"TableViewFav"];
                break;
                
            case 2:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"TableViewControllerDept"];
                break;
                
            case 3:
                vc = [[TableViewSettings alloc] init];
                break;
                
            case 4:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"TableViewHelp"];
                break;
            case 5:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"InfoController"];
                break;
        }

    }

    
    
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                             withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                     andCompletion:nil];
}



@end
