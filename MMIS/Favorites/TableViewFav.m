//
//  MasterViewController.m
//  AAA
//
//  Created by Anton Pavlov on 12.02.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewFav.h"
#import "TableViewControllerSelFav.h"
#import "TabBarTeacher.h"
#import "TableViewControllerClamping.h"
#import "LeftMenuViewController.h"

@interface TableViewFav ()



@end

@implementation TableViewFav

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Избранное";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.editButtonItem.title = @"Правка";
    
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
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (editing){
        self.editButtonItem.title = @"Готово";
        [SlideNavigationController sharedInstance].enableSwipeGesture = NO;
    }else{
        self.editButtonItem.title = @"Правка";
         [SlideNavigationController sharedInstance].enableSwipeGesture = YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSManagedObjectContext*) managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [[DataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellFav" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Favorites *favorites = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = favorites.name;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Удалить";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
       
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Favorites *favorites = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([favorites.graph isEqualToString:@"teacher"]) {
        TabBarTeacher *favTeacher = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarTeacher"];
        favTeacher.name = favorites.name;
        favTeacher.graph = favorites.graph;
        favTeacher.tableTime = favorites.tableTime;
        
        [self.navigationController pushViewController:favTeacher animated:YES];
    }else{
        TableViewControllerSelFav *fav = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewControllerSelFav"];
        
        fav.name = favorites.name;
        fav.graph = favorites.graph;
        fav.tableTime = favorites.tableTime;
        fav.semester = favorites.semester;
        fav.university = favorites.university;
        [self.navigationController pushViewController:fav animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    if (destinationIndexPath.section == sourceIndexPath.section) {
        NSMutableArray *objectArray = [[[self fetchedResultsController] fetchedObjects] mutableCopy];
        NSManagedObject *objectToMove = [objectArray objectAtIndex:sourceIndexPath.row];
        [objectArray removeObjectAtIndex:sourceIndexPath.row];
        [objectArray insertObject:objectToMove atIndex:destinationIndexPath.row];
        NSLog(@"move22");
        for (int i=0; i<[objectArray count]; i++)
        {
            [(NSManagedObject *)[objectArray objectAtIndex:i] setValue:[NSNumber numberWithInt:i] forKey:@"positionCount"];
        }
    }
    
}
#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    fetchRequest.entity = [NSEntityDescription entityForName:@"Favorites" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"positionCount" ascending:YES]];
    fetchRequest.fetchBatchSize = 20;
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"begin");

    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            NSLog(@"sec in");
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            NSLog(@"sec del");
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            NSLog(@"Insert");
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            NSLog(@"Delete");

            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            NSLog(@"update");

            [tableView reloadRowsAtIndexPaths:@[indexPath]  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeMove:
            NSLog(@"move");
            
            if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_8_4) {
                [tableView reloadRowsAtIndexPaths:@[indexPath]  withRowAnimation:UITableViewRowAnimationAutomatic];
            }else{
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            }

            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"end");
    [self.tableView endUpdates];
    
}



@end
