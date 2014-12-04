//
//  UITableViewCell+ConfigureForTask.m
//  DailyTaskManager
//
//  Created by Carlos Eduardo Arantes Ferreira on 26/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import "UITableViewCell+ConfigureForTask.h"
#import "Task.h"

@implementation UITableViewCell (ConfigureForTask)

- (void)configureForTask:(Task *)task {
    
    self.textLabel.text = task.title;
    self.detailTextLabel.text = [self.dateFormatter stringFromDate:task.dueDate];
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

@end
