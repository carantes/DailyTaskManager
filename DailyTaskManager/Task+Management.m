//
//  Task+Management.m
//  DailyTaskManager
//
//  Created by Carlos Eduardo Arantes Ferreira on 30/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import "Task+Management.h"
#import "Store.h"

@implementation Task (Management)

+ (NSString*)entityName
{
    return @"Task";
}

+ (instancetype)insertTaskWithTitle:(NSString *)title andDueDate:(NSDate *)dueDate
{
    
    Task *task = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                               inManagedObjectContext:Store.defaultManagedObjectContext];
    
    task.title = title;
    task.dueDate = dueDate;
    task.isFinished = [NSNumber numberWithBool:NO];
    
    return task;
}

+ (NSFetchedResultsController*)fetchedResultsController
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:[self.class entityName]];
    
    //request.predicate = [NSPredicate predicateWithFormat:@"parent = %@", self];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"isFinished" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"displayOrder" ascending:YES]];
    
    [request setFetchLimit:50];
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:Store.defaultManagedObjectContext sectionNameKeyPath:@"isFinishedDescription" cacheName:nil];
}

- (NSString *)isFinishedDescription {
    return [self.isFinished boolValue] == true ? @"FINISHED" : @"IN PROGRESS";
}

@end
