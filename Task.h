//
//  Task.h
//  DailyTaskManager
//
//  Created by Carlos Eduardo Arantes Ferreira on 13/12/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject

@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSString * fullDescription;
@property (nonatomic, retain) NSNumber * isFinished;
@property (nonatomic, retain) NSNumber * isPriority;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * displayOrder;

@end
