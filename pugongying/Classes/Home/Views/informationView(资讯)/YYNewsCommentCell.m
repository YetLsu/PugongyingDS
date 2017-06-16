//
//  YYNewsCommentCell.m
//  pugongying
//
//  Created by wyy on 16/4/13.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYNewsCommentCell.h"
#import "YYNewsCommentFrame.h"
#import "YYNewsCommentModel.h"


#define userNameH 14
#define userNameFont [UIFont systemFontOfSize:15]

@interface YYNewsCommentCell()
/**
 *  用户头像
 */
@property (nonatomic, weak) UIImageView *iconImageView;
/**
 *  用户昵称
 */
@property (nonatomic, weak) UILabel *userNameLabel;
/**
 *  评论内容
 */
@property (nonatomic, weak) UILabel *commentLabel;
/**
 *  时间
 */
@property (nonatomic, weak) UILabel *dateLabel;
/**
 *  线
 */
@property (nonatomic, weak) UIView *lineView;
@end

static NSString *ID = @"YYNewsCommentCell";

@implementation YYNewsCommentCell
+ (instancetype)newsCommentCellWithTableView:(UITableView *)tableView{
    YYNewsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YYNewsCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:ID]) {
        
        //      用户头像
        CGFloat iconViewH = 50;
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(YY18WidthMargin, YY12HeightMargin, iconViewH, iconViewH)];
        [self.contentView addSubview:iconView];
        self.iconImageView = iconView;
        self.iconImageView.layer.cornerRadius = iconViewH/2.0;
        [self.iconImageView.layer masksToBounds];
        
        //用户昵称
        CGFloat userNameX = YY18WidthMargin + iconViewH + YY12WidthMargin;
        CGFloat userNameY = 16/667.0*YYHeightScreen;
        CGFloat userNameW = YYWidthScreen - iconView.width - 2 *YY18WidthMargin;
        UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(userNameX, userNameY, userNameW, userNameH)];
        [self.contentView addSubview:userNameLabel];
        self.userNameLabel = userNameLabel;
        self.userNameLabel.textColor = YYGrayTextColor;
        self.userNameLabel.font = userNameFont;
        
        //时间label
        CGFloat timeLabelW = 150;
        CGFloat timeLabelX = YYWidthScreen - timeLabelW - YY18WidthMargin;
        CGFloat timeLabelH = 14;
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabelX, userNameY, timeLabelW, timeLabelH)];
        [self.contentView addSubview:timeLabel];
        self.dateLabel = timeLabel;
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.textColor = YYGrayTextColor;
        self.dateLabel.font = [UIFont systemFontOfSize:13];
        
        //用户评论内容
        CGFloat commentLabelX = userNameX;
        CGFloat commentLabelY = CGRectGetMaxY(userNameLabel.frame) + YY10HeightMargin;
        CGFloat commentLabelW = YYWidthScreen - userNameX - YY18WidthMargin;
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(commentLabelX, commentLabelY, commentLabelW, 0)];
        [self.contentView addSubview:commentLabel];
        self.commentLabel = commentLabel;
        
        self.commentLabel.numberOfLines = 0;
        
        //加一条线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(commentLabelX, 0, YYWidthScreen - commentLabelX, 0.5)];
        lineView.backgroundColor = YYGrayLineColor;
        [self.contentView addSubview:lineView];
        self.lineView = lineView;
        
    }
    return self;
}
- (void)setModelFrame:(YYNewsCommentFrame *)modelFrame{
    _modelFrame = modelFrame;
    
    YYNewsCommentModel *model = modelFrame.model;
    
    //    YYLog(@"%@",model.iconURLStr);
    if (model.iconURLStr) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.iconURLStr]];
    }
    else{
        self.iconImageView.image = [UIImage imageNamed:@"profile_iconmoren"];
    }
    
    self.userNameLabel.text = model.userName;
    
    self.commentLabel.text = model.commentStr;
    
    //设置评论高度以及线的y值
    self.commentLabel.height = modelFrame.commentLabelH;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;
    self.commentLabel.font = [UIFont systemFontOfSize:15];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:model.commentStr];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, model.commentStr.length)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, model.commentStr.length)];
    
    self.commentLabel.attributedText = attributedStr;

    //设置时间
 
    self.dateLabel.text = model.dateStr;
    //设置线的y值
    self.lineView.y = CGRectGetMaxY(self.commentLabel.frame) + YY12HeightMargin;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
