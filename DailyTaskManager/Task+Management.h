//
//  Task+Management.h
//  DailyTaskManager
//
//  Created by Carlos Eduardo Arantes Ferreira on 30/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import "Task.h"

@interface Task (Management)

+ (instancetype)insertTaskWithTitle:(NSString *)title
                         andDueDate:(NSDate *)dueDate;

+ (NSFetchedResultsController*)fetchedResultsController;

@end
