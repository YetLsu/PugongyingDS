//
//  YYYiZhenAnswerView.h
//  pugongying
//
//  Created by wyy on 16/3/10.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYYiZhenAnswerFrame.h"

@interface YYYiZhenAnswerView : UIView

@property (nonatomic, strong) YYYiZhenAnswerFrame *answerModelFrame;

+ (instancetype) yiZhenAnswerViewWithFrame:(CGRect)viewFrame;
@end
