//
//  IQiYiPlayButton.h
//  爱奇艺播放按钮动画
//
//  Created by zhangxing on 2017/9/4.
//  Copyright © 2017年 zhangxing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    IQiYiPlayButtonStatePause = 0,
    IQiYiPlayButtonStatePlay
} IQiYiPlayButtonState;

@interface IQiYiPlayButton : UIButton


@property (nonatomic, assign) IQiYiPlayButtonState buttonState;

- (instancetype)initWithFrame:(CGRect)frame state:(IQiYiPlayButtonState)state;


@end
