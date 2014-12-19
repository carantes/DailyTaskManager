//
//  TaskCheckBoxView.m
//  DailyTaskManager
//
//  Created by Carlos Eduardo Arantes Ferreira on 10/12/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import "TaskCheckBoxView.h"

@interface TaskCheckBoxView ()

@property (nonatomic, strong) UIImageView *checkImageView;

@end

@implementation TaskCheckBoxView

static const NSInteger DEFAULT_MARGIN = 2;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self setupViews];
    
    return self;
}

- (void)awakeFromNib {
    [self setupViews];
}

- (void)setupViews
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor clearColor];
    [self addTarget:self action:@selector(checkBoxViewClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *circleLayer = [CALayer layer];
    circleLayer.backgroundColor = [UIColor whiteColor].CGColor;
    circleLayer.cornerRadius = 5.0f;
    circleLayer.borderColor = [UIColor lightGrayColor].CGColor;
    circleLayer.borderWidth = 0.7f;
    circleLayer.frame = CGRectMake(DEFAULT_MARGIN, DEFAULT_MARGIN, self.frame.size.width - (DEFAULT_MARGIN*2), self.frame.size.height - (DEFAULT_MARGIN*2));
    [self.layer addSublayer:circleLayer];
    
    _checkImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self.checkImageView setImage:[UIImage imageNamed:@"check_icon.png"]];
    [self addSubview:self.checkImageView];
    [self updateViewState];
    
}

- (void)checkBoxViewClick:(id)sender {
    _isChecked = !_isChecked;

    [self updateViewState];
}

- (void)setIsChecked:(BOOL)isChecked {
    _isChecked = isChecked;
    
    [self updateViewState];
}

- (void)updateViewState {
    if (_isChecked) {
        [self.checkImageView setAlpha:1.0];
    }
    else
        [self.checkImageView setAlpha:0];
}

@end
