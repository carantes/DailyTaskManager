//
//  FadeMessageView.m
//  DailyTaskManager
//
//  Created by Carlos Eduardo Arantes Ferreira on 02/12/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import "FadeMessageView.h"

@interface FadeMessageView ()

@property (nonatomic, strong) UIButton *messageButton;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FadeMessageView

static const NSInteger DEFAULT_HEIGHT = 50;
static const NSInteger DEFAULT_MARGIN_X = 20;
static const NSInteger DEFAULT_MARGIN_Y = 30;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self setupViews];
    
    return self;
}


- (id)initWithView:(UIView *)view
{
    self = [super initWithFrame:CGRectMake(0, 0, view.frame.size.width-(DEFAULT_MARGIN_X*2), DEFAULT_HEIGHT)];
    if (!self) return nil;
    
    [self setupViews];
    
    return self;
}

- (id)initWithTableView:(UITableView*)tableView
{
    self = [super initWithFrame:CGRectMake(0, 0, tableView.frame.size.width-(DEFAULT_MARGIN_X*2), DEFAULT_HEIGHT)];
    if (self) {
        self.tableView = tableView;
        self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, CGRectGetHeight(self.bounds), 0.0);
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, CGRectGetHeight(self.bounds), 0.0);
        
        [self.tableView addObserver:self
                         forKeyPath:@"contentOffset"
                            options:0
                            context:NULL];

        [self setupViews];
    }
    return self;
}

- (void)dealloc
{
    if (self.tableView) {
        [self.tableView removeObserver:self forKeyPath:@"frame"];
    }
}

- (void)setupViews
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self.layer setMasksToBounds:YES];
    self.layer.cornerRadius = 7.0f;
    self.backgroundColor = [UIColor blackColor];
    
    self.alpha = 0;
}

- (UIButton *)messageButton
{
    if (!_messageButton) {
        _messageButton = [[UIButton alloc] initWithFrame:self.bounds];
        _messageButton.titleLabel.numberOfLines = 2;
        _messageButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _messageButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _messageButton.backgroundColor = [UIColor clearColor];
        [_messageButton addTarget:self action:@selector(messageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_messageButton];
    }
    
    return _messageButton;
}

- (void)setMessage:(NSString *)message
{
    _message = message;

    
    NSMutableAttributedString *messageString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", message]];
    
    [messageString addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-thin" size:14],
                                NSForegroundColorAttributeName: [UIColor whiteColor]
                                }
                        range:NSMakeRange(0, messageString.length)];
    
    [self.messageButton setAttributedTitle:messageString forState:UIControlStateNormal];
    [self startFadeAnimation];
}

- (void)messageButtonClick:(id)sender {
    [self.layer removeAllAnimations];
    [self setAlpha:1.f];
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)startFadeAnimation {
    [self setAlpha:0.f];
    [UIView animateWithDuration:2.f delay:0.5f options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [self setAlpha:1.f];
                     } completion:^(BOOL finished){
                         if (finished) {
                             [self setAlpha:0.f];
                         }
                     }
     
     ];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (([keyPath isEqualToString:@"frame"]) || ([keyPath isEqualToString:@"contentOffset"])) {
        [self adjustFloatingViewFrame];
    }
}

- (void)adjustFloatingViewFrame
{
    CGRect newFrame = self.frame;
    
    newFrame.origin.x = DEFAULT_MARGIN_X;
    newFrame.origin.y = self.tableView.contentOffset.y + CGRectGetHeight(self.tableView.bounds) - (CGRectGetHeight(self.bounds)+DEFAULT_MARGIN_Y);
    
    self.frame = newFrame;
    [self.tableView bringSubviewToFront:self];
}


@end
