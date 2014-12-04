//
//  UITableViewCell+ConfigureForTask.h
//  DailyTaskManager
//
//  Created by Carlos Eduardo Arantes Ferreira on 26/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class Task;

@interface UITableViewCell (ConfigureForTask)

- (void)configureForTask:(Task *)task;

@end
