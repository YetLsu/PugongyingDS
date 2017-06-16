//
//  YYCourseTableViewCell.m
//  pugongying
//
//  Created by wyy on 16/2/26.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCourseTableViewCell.h"
#import "YYCourseCellModel.h"

@interface YYCourseTableViewCell ()
@property (nonatomic, weak) UILabel *courseTitleLabel;

@property (nonatomic, weak) UILabel *courseIndexLabel;
@end


static NSString *ID = @"YYCourseTableViewCell.h";
@implementation YYCourseTableViewCell
+ (instancetype)courseTableViewCellWithTableView:(UITableView *)tableView{
    YYCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YYCourseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *courseIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(YY18WidthMargin, 0, 40, 40)];
        [self.contentView addSubview:courseIndexLabel];
        self.courseIndexLabel = courseIndexLabel;
        self.courseIndexLabel.font = [UIFont systemFontOfSize:16];
        self.courseIndexLabel.textAlignment = NSTextAlignmentRight;
        
        //增加播放按钮
        CGFloat playBtnX = YYWidthScreen - YY18WidthMargin - 35;
        CGFloat playBtnW = 35;
        UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake(playBtnX, 0, playBtnW, 40)];
        [self.contentView addSubview:playBtn];
        [playBtn setTitle:@"播放" forState:UIControlStateNormal];
        [playBtn setTitleColor:YYBlueTextColor forState:UIControlStateNormal];
        playBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [playBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        //增加标题label
        CGFloat courseTitleLabelW = YYWidthScreen - YY18WidthMargin * 2 - 40 - 8/375.0*YYWidthScreen - 35 - 30/375.0*YYWidthScreen;
        UILabel *courseTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YY18WidthMargin + 40 + 8/375.0*YYWidthScreen, 0, courseTitleLabelW, 40)];
        [self.contentView addSubview:courseTitleLabel];
        self.courseTitleLabel = courseTitleLabel;
        self.courseTitleLabel.font = [UIFont systemFontOfSize:16];
        
        //增加线
        [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, 39.5, YYWidthScreen, 0.5) andView:self.contentView];
    }
    return self;
}

/**
 *  播放按钮被点击
 */
- (void)playBtnClick{
    YYLog(@"播放按钮被点击");
    if ([self.delegate respondsToSelector:@selector(courseTableViewCellPlayClickWithModel:)]) {
        [self.delegate courseTableViewCellPlayClickWithModel:self.model];
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(YYCourseCellModel *)model{
    _model = model;

    NSString *str = [model.courseIndex stringByAppendingString:@"节"];
    self.courseIndexLabel.text = str;
    
    self.courseTitleLabel.text = model.courseTitle;
}
@end
