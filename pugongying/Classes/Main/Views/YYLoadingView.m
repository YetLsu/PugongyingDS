//
//  YYLoadingView.m
//  pugongying
//
//  Created by wyy on 16/5/6.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYLoadingView.h"

@implementation YYLoadingView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGFloat width = 30;
        CGFloat height = width;
        CGFloat activityX = (YYWidthScreen - width)/2.0;
        CGFloat activityY = (YYHeightScreen - height)/2.0;
        activityView.frame = CGRectMake(activityX, activityY, width, height);
        activityView.hidesWhenStopped = YES;
        
        [self addSubview:activityView];
        
        [activityView startAnimating];
    }
    return self;
}
@end
