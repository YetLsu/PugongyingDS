//
//  YYCircleChatTableHeaderView.m
//  pugongying
//
//  Created by wyy on 16/6/2.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCircleChatTableHeaderView.h"
#import "YYShowCircleModel.h"


@interface YYCircleChatTableHeaderView (){
    YYShowCircleModel *_circleModel;
}
/**
 *  背景图
 */
@property (nonatomic, weak) UIImageView *bgImageView;
/**
 *  圈子名称Label
 */
@property (nonatomic, weak) UILabel *circleTitleLabel;
/**
 *  圈子介绍Label
 */
@property (nonatomic, weak) UILabel *circleIntroLabel;


@end

@implementation YYCircleChatTableHeaderView

- (instancetype)initWithModel:(YYShowCircleModel *)circleModel andFrame:(CGRect)viewFrame{
    if (self = [super initWithFrame:viewFrame]) {
        _circleModel = circleModel;
       
        // 创建控件，并约束控件位置
        [self addViewsAndConstraintWithHeight:viewFrame.size.height];
        
        //设置控件的内容
        [self setViewsContent];
        
    }
    return self;
}
#pragma mark 创建控件，并约束控件位置
/**
 *  创建控件，并约束控件位置
 */
- (void)addViewsAndConstraintWithHeight:(CGFloat)height{
    //背景图
    UIImageView *bgImageView = [[UIImageView alloc] init];
    [self addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    __weak __typeof(&*self)weakSelf = self;
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf.mas_top).offset(-20);
        make.height.mas_equalTo(height + 20);
    }];
    
    //圈子名称背景图
    UIImageView *circleNameBGImageView = [[UIImageView alloc] init];
    circleNameBGImageView.image = [UIImage imageNamed:@"home_circleNameBg"];
    [self addSubview:circleNameBGImageView];
    [circleNameBGImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf);
        make.centerY.mas_equalTo(weakSelf).offset(5);
        make.size.mas_equalTo(CGSizeMake(175, 50));
    }];
    //圈子名称Label
    UILabel *circleTitleLabel = [[UILabel alloc] init];
    [self addSubview:circleTitleLabel];
    self.circleTitleLabel = circleTitleLabel;
    
    [circleTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(circleNameBGImageView);
    }];
    self.circleTitleLabel.textColor = [UIColor whiteColor];
    self.circleTitleLabel.font = [UIFont boldSystemFontOfSize:22];
    self.circleTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.circleTitleLabel.adjustsFontSizeToFitWidth = YES;
    
    //圈子介绍Label
    UILabel *circleIntroLabel = [[UILabel alloc] init];
    [self addSubview:circleIntroLabel];
    self.circleIntroLabel = circleIntroLabel;
    [circleIntroLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf);
        make.top.mas_equalTo(circleNameBGImageView.mas_bottom);
        make.bottom.mas_equalTo(weakSelf).offset(-10);
    }];
    self.circleIntroLabel.font = [UIFont systemFontOfSize:15.0];
    self.circleIntroLabel.textColor = [UIColor whiteColor];
    self.circleIntroLabel.textAlignment = NSTextAlignmentCenter;
}
#pragma mark  设置控件的内容
/**
 *  设置控件的内容
 */
- (void)setViewsContent{
    self.bgImageView.image = [UIImage imageNamed:@"home_circle_chatBG"];
    self.circleTitleLabel.text = _circleModel.circleTitle;
    self.circleIntroLabel.text = _circleModel.circleIntro;
    
}
@end
