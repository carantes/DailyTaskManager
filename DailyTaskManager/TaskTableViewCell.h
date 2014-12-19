//
//  TaskTableViewCell.h
//  DailyTaskManager
//
//  Created by Carlos Eduardo Arantes Ferreira on 10/12/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Task;
@class TaskCheckBoxView;
@class TaskTableViewCell;

@protocol TaskTableViewCellDelegate <NSObject>

- (void)moveCell:(TaskTableViewCell *)cell isChecked:(BOOL)isChecked;

@end

@interface TaskTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *contentSubView;

@property (strong, nonatomic) IBOutlet UILabel *taskTittleLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskDueDateLabel;
@property (strong, nonatomic) IBOutlet TaskCheckBoxView *checkBoxView;
@property (retain) id <TaskTableViewCellDelegate> delegate;

- (void)configureForTask:(Task *)task;

@end
