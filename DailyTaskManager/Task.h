//
//  Task.h
//  DailyTaskManager
//
//  Created by Carlos Eduardo Arantes Ferreira on 26/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Task : NSManagedObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSDate *dueDate;

+ (instancetype)insertTaskWithTitle:(NSString *)title
                             andDueDate:(NSDate *)dueDate;

+ (NSFetchedResultsController*)fetchedResultsController;

@end
