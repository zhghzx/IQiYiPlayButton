//
//  IQiYiPlayButton.m
//  爱奇艺播放按钮动画
//
//  Created by zhangxing on 2017/9/4.
//  Copyright © 2017年 zhangxing. All rights reserved.
//

#import "IQiYiPlayButton.h"

//变形时长
static CGFloat transformanimationDuration = 0.5f;
//线条位移时长
static CGFloat positionAnimationDuration = 0.3f;
//线条颜色
#define LineColor [UIColor colorWithRed:12/255.0 green:190/255.0 blue:6/255.0 alpha:1]

//三角形动画名称
#define TriangleAnimationName @"TriangleAnimationName"
//右侧直线动画名称
#define RightLineAnimationName @"RightLineAnimationName"

@interface IQiYiPlayButton ()<CAAnimationDelegate>

{
    BOOL _isAnimating;//是否正在执行动画
    CAShapeLayer *_rightLineLayer;//右侧竖线
    CAShapeLayer *_leftLineLayer;//左侧竖线
    CAShapeLayer *_triangleLayer;//三角形
    CAShapeLayer *_arcLayer;//弧线
}

@end

@implementation IQiYiPlayButton

- (instancetype)initWithFrame:(CGRect)frame state:(IQiYiPlayButtonState)state {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        if (state == IQiYiPlayButtonStatePlay) {
            self.buttonState = state;
        }
    }
    return self;
}

#pragma mark -
#pragma mark -添加layer
- (void)setupUI {
    _buttonState = IQiYiPlayButtonStatePause;
    [self setLeftLineLayer];
    [self setRightLineLayer];
    [self setTriangleLayer];
    [self setArcLayer];
}

//设置layer属性
- (void)setupLayer:(CAShapeLayer *)layer with:(CGPathRef)path and:(NSString *)lineCap {
    layer.path = path;
    layer.strokeColor = LineColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = [self lineWidth];
    layer.lineCap = lineCap;
    layer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:layer];
}

//设置左侧竖线
- (void)setLeftLineLayer {
    CGFloat a = self.bounds.size.width;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.2*a, 0)];
    [path addLineToPoint:CGPointMake(0.2*a, a)];
    
    _leftLineLayer = [CAShapeLayer layer];
    [self setupLayer:_leftLineLayer with:path.CGPath and:kCALineCapRound];
}

//设置右侧竖线
- (void)setRightLineLayer {
    CGFloat a = self.bounds.size.width;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.8*a, a)];
    [path addLineToPoint:CGPointMake(0.8*a, 0)];
    
    _rightLineLayer = [CAShapeLayer layer];
    [self setupLayer:_rightLineLayer with:path.CGPath and:kCALineCapRound];
}

//设置三角形
- (void)setTriangleLayer {
    CGFloat a = self.bounds.size.width;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.2*a, 0.2*a)];
    [path addLineToPoint:CGPointMake(0.2*a, 0)];
    [path addLineToPoint:CGPointMake(a, 0.5*a)];
    [path addLineToPoint:CGPointMake(0.2*a, a)];
    [path addLineToPoint:CGPointMake(0.2*a, 0.2*a)];
    
    _triangleLayer = [CAShapeLayer layer];
    _triangleLayer.strokeEnd = 0;
    [self setupLayer:_triangleLayer with:path.CGPath and:kCALineCapButt];
}

//设置弧线
- (void)setArcLayer {
    CGFloat a = self.bounds.size.width;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.8*a, 0.8*a)];
    [path addArcWithCenter:CGPointMake(0.5*a, 0.8*a) radius:0.3*a startAngle:0 endAngle:M_PI clockwise:true];
    
    _arcLayer = [CAShapeLayer layer];
    _arcLayer.strokeEnd = 0;
    [self setupLayer:_arcLayer with:path.CGPath and:kCALineCapButt];
}

#pragma mark -
#pragma mark -竖线动画
//暂停->播放
- (void)positiveLineAnimation {
    CGFloat a = self.bounds.size.width;
    //左侧竖线缩放
    UIBezierPath *leftPath = [UIBezierPath bezierPath];
    [leftPath moveToPoint:CGPointMake(0.2*a, 0.4*a)];
    [leftPath addLineToPoint:CGPointMake(0.2*a, a)];
    _leftLineLayer.path = leftPath.CGPath;
    [_leftLineLayer addAnimation:[self pathAnimationWithDuration:positionAnimationDuration/2] forKey:nil];
    //右侧竖线位移
    UIBezierPath *rightPath = [UIBezierPath bezierPath];
    [rightPath moveToPoint:CGPointMake(0.8*a, 0.8*a)];
    [rightPath addLineToPoint:CGPointMake(0.8*a, -0.2*a)];
    _rightLineLayer.path = rightPath.CGPath;
    [_rightLineLayer addAnimation:[self pathAnimationWithDuration:positionAnimationDuration/2] forKey:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(positionAnimationDuration/2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //左侧竖线位移
        UIBezierPath *leftPath = [UIBezierPath bezierPath];
        [leftPath moveToPoint:CGPointMake(0.2*a, 0.2*a)];
        [leftPath addLineToPoint:CGPointMake(0.2*a, 0.8*a)];
        _leftLineLayer.path = leftPath.CGPath;
        [_leftLineLayer addAnimation:[self pathAnimationWithDuration:positionAnimationDuration/2] forKey:nil];
        //右侧竖线缩放
        UIBezierPath *rightPath = [UIBezierPath bezierPath];
        [rightPath moveToPoint:CGPointMake(0.8*a, 0.8*a)];
        [rightPath addLineToPoint:CGPointMake(0.8*a, 0.2*a)];
        _rightLineLayer.path = rightPath.CGPath;
        [_rightLineLayer addAnimation:[self pathAnimationWithDuration:positionAnimationDuration/2] forKey:nil];
    });
}

//播放->暂停
- (void)inverseLineAnimation {
    CGFloat a = self.bounds.size.width;
    //左侧竖线位移
    UIBezierPath *leftPath = [UIBezierPath bezierPath];
    [leftPath moveToPoint:CGPointMake(0.2*a, 0.4*a)];
    [leftPath addLineToPoint:CGPointMake(0.2*a, a)];
    _leftLineLayer.path = leftPath.CGPath;
    [_leftLineLayer addAnimation:[self pathAnimationWithDuration:positionAnimationDuration/2] forKey:nil];
    //右侧竖线缩放
    UIBezierPath *rightPath = [UIBezierPath bezierPath];
    [rightPath moveToPoint:CGPointMake(0.8*a, 0.8*a)];
    [rightPath addLineToPoint:CGPointMake(0.8*a, -0.2*a)];
    _rightLineLayer.path = rightPath.CGPath;
    [_rightLineLayer addAnimation:[self pathAnimationWithDuration:positionAnimationDuration/2] forKey:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(positionAnimationDuration/2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //左侧竖线缩放
        UIBezierPath *leftPath = [UIBezierPath bezierPath];
        [leftPath moveToPoint:CGPointMake(0.2*a, 0)];
        [leftPath addLineToPoint:CGPointMake(0.2*a, a)];
        _leftLineLayer.path = leftPath.CGPath;
        [_leftLineLayer addAnimation:[self pathAnimationWithDuration:positionAnimationDuration/2] forKey:nil];
        //右侧竖线位移
        UIBezierPath *rightPath = [UIBezierPath bezierPath];
        [rightPath moveToPoint:CGPointMake(0.8*a, a)];
        [rightPath addLineToPoint:CGPointMake(0.8*a, 0)];
        _rightLineLayer.path = rightPath.CGPath;
        [_rightLineLayer addAnimation:[self pathAnimationWithDuration:positionAnimationDuration/2] forKey:nil];
    });
}

- (CABasicAnimation *)pathAnimationWithDuration:(CGFloat)duration {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.duration = duration;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    return animation;
}

#pragma mark -
#pragma mark -三角形弧线动画
//暂停->播放
- (void)positiveTransformAnimation {
    //三角形
    [self strokeEndAnimationFrom:0 to:1 onLayer:_triangleLayer name:TriangleAnimationName duration:transformanimationDuration delegate:self];
    //右侧竖线
    [self strokeEndAnimationFrom:1 to:0 onLayer:_rightLineLayer name:RightLineAnimationName duration:transformanimationDuration/4 delegate:self];
    //弧线
    [self strokeEndAnimationFrom:0 to:1 onLayer:_arcLayer name:nil duration:transformanimationDuration/4 delegate:nil];
    //逆向弧线
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transformanimationDuration*0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self arcStartAnimationFrom:0 to:1];
    });
    //左侧竖线缩短
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transformanimationDuration*0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self strokeEndAnimationFrom:1 to:0 onLayer:_leftLineLayer name:nil duration:transformanimationDuration/2 delegate:nil];
    });
}

//播放->暂停
- (void)inverseTransformAnimation {
    //三角形
    [self strokeEndAnimationFrom:1 to:0 onLayer:_triangleLayer name:TriangleAnimationName duration:transformanimationDuration delegate:self];
    //左侧竖线
    [self strokeEndAnimationFrom:0 to:1 onLayer:_leftLineLayer name:nil duration:transformanimationDuration/2 delegate:nil];
    //弧线
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transformanimationDuration*0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self arcStartAnimationFrom:1 to:0];
    });
    //逆向弧线 右侧竖线放大
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transformanimationDuration*0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //右侧竖线
        [self strokeEndAnimationFrom:0 to:1 onLayer:_rightLineLayer name:RightLineAnimationName duration:transformanimationDuration/4 delegate:self];
        //弧线
        [self strokeEndAnimationFrom:1 to:0 onLayer:_arcLayer name:nil duration:transformanimationDuration/4 delegate:nil];
    });
}

- (CABasicAnimation *)strokeEndAnimationFrom:(CGFloat)from to:(CGFloat)to onLayer:(CALayer *)layer name:(NSString *)animationName duration:(CGFloat)duration delegate:(id)delegate {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = duration;
    animation.fromValue = @(from);
    animation.toValue = @(to);
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setValue:animationName forKey:@"animationName"];
    animation.delegate = delegate;
    [layer addAnimation:animation forKey:nil];
    return animation;
}

- (void)arcStartAnimationFrom:(CGFloat)from to:(CGFloat)to {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation.duration = transformanimationDuration/4;
    animation.fromValue = @(from);
    animation.toValue = @(to);
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [_arcLayer addAnimation:animation forKey:nil];
}

//线条宽度
- (CGFloat)lineWidth {
    return self.bounds.size.width * 0.2;
}

#pragma mark -
#pragma mark -CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim {
    NSString *name = [anim valueForKey:@"animationName"];
    BOOL isTriangle = [name isEqualToString:TriangleAnimationName];
    BOOL isRightLine = [name isEqualToString:RightLineAnimationName];
    if (isTriangle) {
        _triangleLayer.lineCap = kCALineCapRound;
    } else if (isRightLine) {
        _rightLineLayer.lineCap = kCALineCapRound;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *name = [anim valueForKey:@"animationName"];
    BOOL isTriangle = [name isEqualToString:TriangleAnimationName];
    BOOL isRightLine = [name isEqualToString:RightLineAnimationName];
    if (isRightLine && _buttonState == IQiYiPlayButtonStatePlay) {
        _rightLineLayer.lineCap = kCALineCapButt;
    } else if (isTriangle) {
        _triangleLayer.lineCap = kCALineCapButt;
    }
}

- (void)setButtonState:(IQiYiPlayButtonState)buttonState {
    if (_isAnimating) {
        return;
    }
    _buttonState = buttonState;
    if (buttonState == IQiYiPlayButtonStatePause) {
        //播放->暂停
        _isAnimating = YES;
        [self inverseTransformAnimation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transformanimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self inverseLineAnimation];
        });
        
    }   else if (buttonState == IQiYiPlayButtonStatePlay) {
        //暂停->播放
        _isAnimating = YES;
        //竖线正向动画
        [self positiveLineAnimation];
        //三角形弧线
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(positionAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self positiveTransformAnimation];
        });
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(positionAnimationDuration + transformanimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _isAnimating = NO;
    });
}

@end
