//
//  YYNONetViewBtn.m
//  pugongying
//
//  Created by wyy on 16/5/6.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYNoNetViewBtn.h"

@implementation YYNoNetViewBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
   
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat imageW = 109.5;
        CGFloat imageH = 110.5;
        CGFloat imageX = (YYWidthScreen - imageW)/2.0;
        CGFloat imageY = (YYHeightScreen - imageH)/2.0;
        UIImageView *noNetImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        noNetImageView.image = [UIImage imageNamed:@"noNet"];
        [self addSubview:noNetImageView];
        //增加文字label
        CGFloat labelX = 0;
        CGFloat labelY = imageY + imageH + 10;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, YYWidthScreen, 20)];
        label.text = @"点击屏幕，重新加载";
        label.textColor = YYGrayLineColor;
        [self addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

@end
