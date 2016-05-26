//
//  WaveView.m
//  Wave
//
//  Created by AChang on 5/25/16.
//  Copyright © 2016 AChang. All rights reserved.
//

#import "WaveView.h"

@interface WaveView ()
{
    CGFloat screenWidth;
    
    float A;    // 振幅
    float t;    // 时间变量
    
    float T;    // 周期
    float K;    // 波长
    
    float axleXOnScreenHeight; // 图形在屏幕中的高度
    
    BOOL change;               // 用来改变振幅的大小，增加节奏感
}
@end


@implementation WaveView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 设置波的基本属性（）
        A = 4;
        t = 0;
        T = 2.0;
        K = 160;
        
        change = NO;
        
        screenWidth = [UIScreen mainScreen].bounds.size.width;
        [self setBackgroundColor:[UIColor clearColor]];
        
        axleXOnScreenHeight = 250;
        
        // 设置刷新图像的频率，0.3秒人眼就很难分辨出来了
        [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
        
    }
    return self;
}

-(void)animateWave
{
    // 这里是时间机器，如果和刷新图像的时间间隔一样，那么就是正常时间的速度
    // 如果大于刷新时间间隔，那么时间就走的很快，是平常的多少倍自己去计算
    // 如果小于刷新时间间隔，那么时间就走的慢
    
    t+=0.05;
    
    [self setNeedsDisplay];
    
    
    if (change) {
        A += 0.1;
    }else{
        A -= 0.1;
    }
    
    if (A<=2) {
        change = YES;
    }
    
    if (A>=6) {
        change = NO;
    }
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    

    float y=axleXOnScreenHeight;
    CGPathMoveToPoint(path, NULL, 0, y);
    
    // 这是将x轴微分单位为1pt，就是每隔1pt计算一个y值，将所有的y值连起来就是一个波图
    // 可以将微分单位设置大一点，有不一样的效果
    // y 值的计算就用推导出来的公式：y = Acos2PI(t/T - Xp/K)
    for(float x=0;x <= screenWidth;x+=2){
        y =  A * cos(2*M_PI * (t / T -  x / K)) + axleXOnScreenHeight;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    

    // 水波填充
    CGPathAddLineToPoint(path, nil, screenWidth, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, axleXOnScreenHeight);
    
    CGContextAddPath(context, path);
    
    CGContextFillPath(context);
    
    // 线条波动描边
//    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
    
    
}


@end
