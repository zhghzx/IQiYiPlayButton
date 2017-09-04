//
//  ViewController.m
//  爱奇艺播放按钮动画
//
//  Created by zhangxing on 2017/9/4.
//  Copyright © 2017年 zhangxing. All rights reserved.
//

#import "ViewController.h"
#import "IQiYiPlayButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    IQiYiPlayButton *btn = [[IQiYiPlayButton alloc] initWithFrame:CGRectMake(100, 100, 50, 50) state:IQiYiPlayButtonStatePause];
    [btn addTarget:self action:@selector(btnHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnHandle:(IQiYiPlayButton *)btn {
    if (btn.buttonState == IQiYiPlayButtonStatePlay) {
        btn.buttonState = IQiYiPlayButtonStatePause;
    }   else {
        btn.buttonState = IQiYiPlayButtonStatePlay;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
