//
//  YYYiZhenQuestionView.h
//  pugongying
//
//  Created by wyy on 16/3/9.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYYiZhenQuestionFrame.h"

@interface YYYiZhenQuestionView : UIView

@property (nonatomic, strong) YYYiZhenQuestionFrame *modelFrame;

+ (instancetype) yiZhenQuestionViewWithFrame:(CGRect)viewFrame;
@end
