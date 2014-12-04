//
//  FadeMessageView.h
//  DailyTaskManager
//
//  Created by Carlos Eduardo Arantes Ferreira on 02/12/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FadeMessageView : UIControl

@property (nonatomic, strong) NSString *message;

- (id)initWithView:(UIView *)view;
- (id)initWithTableView:(UITableView *)tableView;

@end
