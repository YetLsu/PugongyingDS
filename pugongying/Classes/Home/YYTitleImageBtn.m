//
//  YYTitleImageBtn.m
//  pugongying
//
//  Created by wyy on 16/4/21.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYTitleImageBtn.h"

@implementation YYTitleImageBtn
- (instancetype)initWithNorImage:(UIImage *)norImage andSelImage:(UIImage *)selImage andTitle:(NSString *)title{
    if (self = [super init]) {
        [self setImage:norImage forState:UIControlStateNormal];
    }
    return self;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
    [self.imageView sizeToFit];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat scale = YYWidthScreen / 375.0;
    CGFloat btnH = (12 * 2 + 75) * scale;
    CGFloat yMargin = 12 *scale;
    CGFloat btnW = YYWidthScreen/4.0;
    
    CGFloat imageViewW = 42.5 * scale;
    CGFloat imageViewX = (btnW - imageViewW)/2.0;
    self.imageView.frame = CGRectMake(imageViewX, yMargin, imageViewW, imageViewW);
    
    CGFloat titleLabelY = yMargin + imageViewW + 10 *scale;
    CGFloat titleLabelH = 75 - imageViewW - 10*scale;
    self.titleLabel.frame = CGRectMake(0, titleLabelY, btnW, titleLabelH);

    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
