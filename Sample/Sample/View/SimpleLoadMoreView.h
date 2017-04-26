//
//  SimpleLoadMoreView.h
//  Sample
//
//  Created by guangbool on 2017/4/25.
//  Copyright © 2017年 bool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BOOLoadMoreController.h"

@interface SimpleLoadMoreView : UIView <BOOLoadMoreControlProtocol>

@property (nonatomic, copy) NSString *textForPulling;
@property (nonatomic, copy) NSString *textForIdle;

- (CGSize)intrinsicContentSize;

@end
