//
//  YYCollectNewsCell.m
//  pugongying
//
//  Created by wyy on 16/4/18.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCollectNewsCell.h"
#import "YYCollectNewsFrame.h"
#import "YYInformationModel.h"

@interface YYCollectNewsCell ()
/**
 *  资讯图片
 */
@property (nonatomic, weak) UIImageView *newsIcon;
/**
 *  资讯标题Label
 */
@property (nonatomic, weak) UILabel *newsTitleLabel;
/**
 *  资讯内容Label
 */
@property (nonatomic, weak) UILabel *newsContentLabel;
/**
 *  取消收藏资讯Button
 */
@property (nonatomic, weak) UIButton *newsCancelCollectBtn;
/**
 *  查看资讯Button
 */
@property (nonatomic, weak) UIButton *newsLookBtn;
@end

@implementation YYCollectNewsCell

+ (instancetype)collectNewsCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"YYCollectNewsCell";
    YYCollectNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YYCollectNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        /**
         *  资讯图片
         */
        UIImageView *newsIcon = [[UIImageView alloc] init];
        [self.contentView addSubview:newsIcon];
        self.newsIcon = newsIcon;
        
        /**
         *  资讯标题Label
         */
        UILabel *newsTitleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:newsTitleLabel];
        self.newsTitleLabel = newsTitleLabel;
        /**
         *  资讯内容Label
         */
        UILabel *newsContentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:newsContentLabel];
        self.newsContentLabel = newsContentLabel;
        /**
         *  取消收藏课程Button
         */
        UIButton *courseCancelCollectBtn = [YYPugongyingTool createBtnWithFrame:CGRectMake(0, 0, 100, 50) superView:self.contentView backgroundImage:[UIImage imageNamed:@"profile_loginBtnBg"] titleColor:YYGrayTextColor title:@"取消收藏"];
        self.newsCancelCollectBtn = courseCancelCollectBtn;
        [self.newsCancelCollectBtn addTarget:self action:@selector(newsCancelCollectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        courseCancelCollectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        /**
         *  查看课程Button
         */
        UIButton *courseLookBtn = [YYPugongyingTool createBtnWithFrame:CGRectMake(0, 0, 100, 50) superView:self.contentView backgroundImage:[UIImage imageNamed:@"profile_loginBtnBg"] titleColor:YYGrayTextColor title:@"查看课程"];
        self.newsLookBtn = courseLookBtn;
        [self.newsLookBtn addTarget:self action:@selector(newsSeeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        courseLookBtn.titleLabel.font = [UIFont systemFontOfSize:15];

    }
    return self;
}

- (void)setModelFrame:(YYCollectNewsFrame *)modelFrame{
    _modelFrame = modelFrame;
    
    YYInformationModel *model = modelFrame.model;
    
    /**
     *  资讯图片
     */
    self.newsIcon.frame = modelFrame.newsIconF;
    [self.newsIcon sd_setImageWithURL:[NSURL URLWithString:model.showimgurl] placeholderImage:[UIImage imageNamed:@"news_load2"]];
    
    CGFloat line1Y = CGRectGetMaxY(self.newsIcon.frame) + YY12HeightMargin * 2 - 0.5;
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, line1Y, YYWidthScreen, 0.5) andView:self.contentView];
    /**
     *  资讯标题Label
     */
    self.newsTitleLabel.frame = modelFrame.newsTitleF;
    self.newsTitleLabel.text = model.title;
    /**
     *  资讯内容Label
     */
    self.newsContentLabel.frame = modelFrame.newsContentF;
    self.newsContentLabel.text = model.intro;
    /**
     *  取消收藏资讯Button
     */
    self.newsCancelCollectBtn.frame = modelFrame.newsCancelCollectF;
    /**
     *  查看资讯Button
     */
    self.newsLookBtn.frame = modelFrame.newsLookF;
    
    CGFloat line2Y = CGRectGetMaxY(self.newsLookBtn.frame) + YY12HeightMargin - 0.5;
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, line2Y, YYWidthScreen, 0.5) andView:self.contentView];
    
}

#pragma mark 取消收藏课程Button被点击
- (void)newsCancelCollectBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(cancelCollectNewsBtnClickWithFrame:)]) {
        [self.delegate cancelCollectNewsBtnClickWithFrame:self.modelFrame];
    }
}
#pragma mark 查看课程Button被点击
- (void)newsSeeBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(seeNewsBtnClickWithFrame:)]) {
        [self.delegate seeNewsBtnClickWithFrame:self.modelFrame];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
