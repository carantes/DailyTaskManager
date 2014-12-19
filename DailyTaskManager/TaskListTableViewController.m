//
//  TaskListTableViewController.m
//  DailyTaskManager
//
//  Created by Carlos Eduardo Arantes Ferreira on 26/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import "TaskListTableViewController.h"
#import "TaskTableViewCell.h"
#import "TaskDetailTableViewController.h"
#import "FetchedResultsControllerDataSource.h"
#import "Task+Management.h"
#import "FadeMessageView.h"

static NSString * const TaskCellIdentifier = @"taskCell";

@interface TaskListTableViewController () <FetchedResultsControllerDataSourceDelegate, TaskTableViewCellDelegate>

@property (nonatomic, strong) FetchedResultsControllerDataSource *dataSource;
@property (nonatomic, strong) FadeMessageView *fadeMessageView;
@property (nonatomic, strong) UIButton *undoMessageButton;

@end

@implementation TaskListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *bgImage = [UIImage imageNamed:@"wood_background"];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:bgImage];
    
    [self setupFetchedResultsController];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Perform Fetch and reload data
    self.dataSource.paused = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //Prevent BUG when fetch multiple FetchedResultsController 
    self.dataSource.paused = YES;
}

- (void)setupFetchedResultsController
{
    self.dataSource = [[FetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
    
    self.dataSource.fetchedResultsController = [Task fetchedResultsController];
    self.dataSource.delegate = self;
    self.dataSource.reuseIdentifier = @"taskCell";
    self.dataSource.sortField = @"displayOrder";
}

- (void)showPopOverActionText:(NSString *)message {
    
    if (!_fadeMessageView) {
        self.fadeMessageView = [[FadeMessageView alloc] initWithTableView:self.tableView];
        self.fadeMessageView.backgroundColor = [UIColor colorWithRed:(51/255.0) green:(73/255.0) blue:(93/255.0) alpha:1.0];
        [self.fadeMessageView addTarget:self action:@selector(undoMessageClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_fadeMessageView];
    }
    
    self.fadeMessageView.message = message;
}

- (void)undoMessageClick:(id)sender {
    self.fadeMessageView.alpha = 0;
    [self.undoManager undo];
    [self.managedObjectContext save:nil];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:editing animated:animated];
    
    self.addButton.enabled = !editing;
}

#pragma mark Fetched Results Controller Delegate

- (void)configureCell:(id)theCell withObject:(id)object
{
    TaskTableViewCell* cell = theCell;
    cell.delegate = self;
    Task *task = object;
    [cell configureForTask:task];
}

- (void)deleteObject:(id)object
{
    Task *task = object;
    
    NSString* actionName = [NSString stringWithFormat:@"Excluir %@", task.title];
    
    // Save Changes
    NSError *error = nil;
    [self.managedObjectContext deleteObject:object];
    [self.managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"Error %@ with user info %@.", error, error.userInfo);
    }
    else {
        [self.undoManager setActionName:actionName];
        [self showPopOverActionText:[NSString stringWithFormat:@"Clique aqui para desfazer a ação %@", actionName]];
    }
}

#pragma mark TaskTableViewCell Delegate

- (void)moveCell:(TaskTableViewCell *)cell isChecked:(BOOL)isChecked {
    
    NSIndexPath *fromIndexPath = [self.tableView indexPathForCell:cell];
    Task *task = [self.dataSource.fetchedResultsController objectAtIndexPath:fromIndexPath];
    
    task.isFinished = [NSNumber numberWithBool:isChecked];
    
    NSIndexPath *toIndexPath;
    
    if (isChecked) {
        toIndexPath = [NSIndexPath indexPathForItem:0 inSection:1];
    } else {
        id <NSFetchedResultsSectionInfo> sectionInfo = self.dataSource.fetchedResultsController.sections[0];
        toIndexPath = [NSIndexPath indexPathForItem:[sectionInfo numberOfObjects]-1 inSection:0];
    }
    
    [self.dataSource reorderObjectListFromIndexPath:fromIndexPath toIndexPath:toIndexPath];
    
    [[self managedObjectContext] save:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if ([segue.identifier isEqualToString:@"taskListToTaskDetailSegue"]) {
        
        TaskDetailTableViewController *taskDetailController = segue.destinationViewController;
        
        Task * task = [self.dataSource selectedItem];
        
        taskDetailController.currentTask = task;
        
        taskDetailController.title = task.title;
    }
    else {
    
        UINavigationController *navigationController = segue.destinationViewController;
        
        TaskDetailTableViewController *taskDetailController = (TaskDetailTableViewController *)navigationController.topViewController;
        
        taskDetailController.title = @"Nova Tarefa";
    }
}

#pragma mark Undo Manager

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (NSUndoManager*)undoManager
{
    return [self managedObjectContext].undoManager;
}

- (NSManagedObjectContext *)managedObjectContext {
    return self.dataSource.fetchedResultsController.managedObjectContext;
}


@end
