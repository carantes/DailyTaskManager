//
//  Task.m
//  DailyTaskManager
//
//  Created by Carlos Eduardo Arantes Ferreira on 26/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import "Task.h"
#import "Store.h"

@implementation Task

@dynamic title;
@dynamic dueDate;


+ (NSString*)entityName
{
    return @"Task";
}

+ (instancetype)insertTaskWithTitle:(NSString *)title andDueDate:(NSDate *)dueDate
{
    Store *store = [[Store alloc] init];
    Task *task = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                               inManagedObjectContext:store.defaultManagedObjectContext];
    
    task.title = title;
    task.dueDate = dueDate;
    
    return task;
}

+ (NSFetchedResultsController*)fetchedResultsController
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:[self.class entityName]];
    
    //request.predicate = [NSPredicate predicateWithFormat:@"parent = %@", self];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dueDate" ascending:NO]];
    
    Store *store = [[Store alloc] init];
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:store.defaultManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

@end
