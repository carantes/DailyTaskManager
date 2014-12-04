//
//  TaskDetailTableViewController.h
//  DailyTaskManager
//
//  Created by Carlos Eduardo Arantes Ferreira on 27/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class Task;

@interface TaskDetailTableViewController : UITableViewController

@property (nonatomic) Task *currentTask;

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;

@property (strong, nonatomic) IBOutlet UITextField *dueDateTextField;

@end
