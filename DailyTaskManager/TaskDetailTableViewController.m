//
//  TaskDetailTableViewController.m
//  DailyTaskManager
//
//  Created by Carlos Eduardo Arantes Ferreira on 27/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import "TaskDetailTableViewController.h"
#import "Task+Management.h"

@implementation TaskDetailTableViewController

@synthesize currentTask = _currentTask;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_currentTask) {
        self.titleTextField.text = self.currentTask.title;
        self.dueDateTextField.text = [self.dateFormatter stringFromDate:self.currentTask.dueDate];
    }
    else {
        //New Task
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClick:)];;
    }
    
}

- (void)cancelButtonClick:(id)sender {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)saveButtonClick:(id)sender {
    
    NSString *taskTitle = self.titleTextField.text;
    NSDate *taskDate = [NSDate date];
    NSString* actionName;
    
    if (!_currentTask) {
        _currentTask = [Task insertTaskWithTitle:taskTitle andDueDate:taskDate];
        actionName = [NSString stringWithFormat:NSLocalizedString(@"Insert \"%@\"", @"Insert undo action name"), _currentTask.title];
    }
    else {
        _currentTask.title = taskTitle;
        _currentTask.dueDate = taskDate;
        actionName = [NSString stringWithFormat:NSLocalizedString(@"Edit \"%@\"", @"Edit undo action name"), _currentTask.title];
    }
    
    [self.undoManager setActionName:actionName];
    
    [_currentTask.managedObjectContext save:nil];
    
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:TRUE completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:true];
    }
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }
    return dateFormatter;
}

#pragma mark Undo Manager

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (NSUndoManager*)undoManager
{
    return self.currentTask.managedObjectContext.undoManager;
}


@end
