//
//  TaskTableViewCell.m
//  DailyTaskManager
//
//  Created by Carlos Eduardo Arantes Ferreira on 10/12/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import "TaskTableViewCell.h"
#import "Task.h"
#import "TaskCheckBoxView.h"

@implementation TaskTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib {
    self.contentSubView.layer.cornerRadius = 5.0f;
    self.contentSubView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.9];
}

- (void)configureForTask:(Task *)task {
    
    self.taskTittleLabel.text = task.title;
    self.taskDueDateLabel.text = [self.dateFormatter stringFromDate:task.dueDate];
    [self.checkBoxView addTarget:self action:@selector(checkBoxViewClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.checkBoxView.isChecked = [task.isFinished boolValue];
    
    [self setupLabelFont];
}

- (void)checkBoxViewClick:(id)sender {
    [self setupLabelFont];
    
    if (self.checkBoxView.isChecked) {
        self.contentSubView.alpha = 0.8f;
    }
    else
        self.contentSubView.alpha = 1.0f;
    
    [self.delegate moveCell:self isChecked:self.checkBoxView.isChecked];
}

- (void)setupLabelFont
{
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.taskTittleLabel.text];
    
    if (self.checkBoxView.isChecked)
    {
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:[NSNumber numberWithInt:2]
                                range:(NSRange){0,[attributeString length]}];
        self.contentSubView.alpha = 0.8f;
    }
    else
    {
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributeString length])];
        self.contentSubView.alpha = 1.0f;
    }
    
    self.taskTittleLabel.attributedText = attributeString;
}


- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
    }
    return dateFormatter;
}


@end
