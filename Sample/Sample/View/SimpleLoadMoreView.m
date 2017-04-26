//
//  SimpleLoadMoreView.m
//  Sample
//
//  Created by guangbool on 2017/4/25.
//  Copyright © 2017年 bool. All rights reserved.
//

#import "SimpleLoadMoreView.h"

@interface SimpleLoadMoreView ()

@property (nonatomic) UILabel *label;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation SimpleLoadMoreView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.label];
    [self addSubview:self.activityIndicator];
    
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(CGRectGetWidth(self.frame), 40);
}

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.textColor = [UIColor grayColor];
        _label.font = [UIFont systemFontOfSize:14];
    }
    return _label;
}

- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.hidesWhenStopped = YES;
    }
    return _activityIndicator;
}

#pragma mark - BOOLoadMoreControlProtocol

- (void)stateWillChangeFromCurrent:(BOOLoadMoreControlState)fromCurrentState toState:(BOOLoadMoreControlState)toState {
    
}

- (void)stateDidChangedFromOld:(BOOLoadMoreControlState)fromOldState toCurrentState:(BOOLoadMoreControlState)toCurrentState {
    if (toCurrentState == BOOLoadMoreControlStateIdle) {
        self.label.text = self.textForIdle;
        [self.activityIndicator stopAnimating];
    } else if (toCurrentState == BOOLoadMoreControlPulling) {
        self.label.text = self.textForPulling;
        [self.activityIndicator stopAnimating];
    } else if (toCurrentState == BOOLoadMoreControlLoading) {
        self.label.text = nil;
        [self.activityIndicator startAnimating];
    }
}

- (void)animateWhenFinishRefresh {
    
}

- (void)pullingPercentChangeTo:(CGFloat)pullingPercent {
    
}

@end
