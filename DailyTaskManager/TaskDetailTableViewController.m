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
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClick:)];
        self.dueDateTextField.text = [self.dateFormatter stringFromDate:[NSDate date]];
    }
    
    [self setupDueDateTextField];

}

#pragma mark User Interaction

- (void)cancelButtonClick:(id)sender {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)saveButtonClick:(id)sender {
    
    NSString *taskTitle = self.titleTextField.text;
    UIDatePicker *datePicker = (UIDatePicker*)self.dueDateTextField.inputView;
    
    //Picker Date without Time
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[datePicker date]];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *taskDate = [calendar dateFromComponents:components];
    
    NSString* actionName;
    
    if (!_currentTask) {
        _currentTask = [Task insertTaskWithTitle:taskTitle andDueDate:taskDate];
        actionName = @"Insert";
    }
    else {
        _currentTask.title = taskTitle;
        _currentTask.dueDate = taskDate;
        actionName = @"Edit";
    }
    
    [self.undoManager setActionName:[NSString stringWithFormat:NSLocalizedString(@"%@ \"%@\"", @"Insert Edit undo action name"), actionName, _currentTask.title]];
    
    [_currentTask.managedObjectContext save:nil];
    
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:TRUE completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:true];
    }
}

- (void)pickerDoneButtonClick:(id)sender {
    [self.dueDateTextField resignFirstResponder];
}

#pragma mark Date Picker

- (void)setupDueDateTextField {
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateDueDateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.dueDateTextField setInputView:datePicker];
    
    UIToolbar *pickerNavToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [pickerNavToolbar setTranslucent:false];
    [pickerNavToolbar setBackgroundColor:[UIColor blackColor]];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneButtonClick:)];
    
    [pickerNavToolbar setItems:[[NSArray alloc] initWithObjects: space, doneButton, nil]];
    
    [self.dueDateTextField setInputAccessoryView:pickerNavToolbar];
}

- (void)updateDueDateTextField:(id)sender {
    UIDatePicker *picker = (UIDatePicker*)self.dueDateTextField.inputView;
    self.dueDateTextField.text = [self.dateFormatter stringFromDate:picker.date];
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
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
