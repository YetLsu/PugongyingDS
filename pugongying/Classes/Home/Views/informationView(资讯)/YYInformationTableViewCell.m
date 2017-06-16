//
//  YYInformationTableViewCell.m
//  pugongying
//
//  Created by wyy on 16/3/3.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYInformationTableViewCell.h"
#import "YYInformationFrame.h"
#import "YYInformationModel.h"

@interface YYInformationTableViewCell ()

/**
*  图片ImageView
*/
@property (nonatomic, weak) UIImageView *iconImageView;
/**
 *  分类和标题的Label
 */
@property (nonatomic, weak) UILabel *sortTitleLabel;
/**
 *  内容Label
 */
@property (nonatomic, weak) UILabel *contentTextLabel;
/**
 *  时间Label
 */
@property (nonatomic, weak) UILabel *timeLabel;
/**
 *  评论左边的图标
 */
//@property (nonatomic, weak) UIImageView *commentImageView;
/**
 *  底部的线条View
 */
@property (nonatomic, weak) UIView *lineView;
@end

@implementation YYInformationTableViewCell
+ (instancetype)informationCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"YYInformationTableViewCell";
    YYInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[YYInformationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        /**
         *  添加图片ImageView
         */
        UIImageView *iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        
        /**
         *  添加分类和标题的Label
         */
        UILabel *sortTitleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:sortTitleLabel];
        self.sortTitleLabel = sortTitleLabel;
        self.sortTitleLabel.textColor = YYGrayTextColor;
        self.sortTitleLabel.font = [UIFont systemFontOfSize:15];
        /**
         *  添加内容Label
         */
        UILabel *contentTextLabel = [[UILabel alloc] init];
        [self.contentView addSubview:contentTextLabel];
        self.contentTextLabel = contentTextLabel;
        self.contentTextLabel.textColor = YYGrayText140Color;
        self.contentTextLabel.numberOfLines = 0;
        self.contentTextLabel.font = [UIFont systemFontOfSize:13];
        /**
         *  添加时间Label
         */
        UILabel *timeLabel= [[UILabel alloc] init];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        self.timeLabel.font = [UIFont systemFontOfSize:13];
        self.timeLabel.textColor = YYBlueTextColor;
        self.timeLabel.textAlignment = NSTextAlignmentRight;
//        /**
//         *  添加评论左边的图标
//         */
//        UIImageView *commentImageView = [[UIImageView alloc] init];
//        [self.contentView addSubview:commentImageView];
//        self.commentImageView = commentImageView;
//        self.commentImageView.image = [UIImage imageNamed:@"home_information_3"];
        
        /**
         *  底部的线条View
         */
        UIView *lineView = [[UIView alloc] init];
        [self.contentView addSubview:lineView];
        self.lineView = lineView;
        self.lineView.backgroundColor = YYGrayLineColor;
    }
    return self;
}

- (void)setInformationFrame:(YYInformationFrame *)informationFrame{
    _informationFrame = informationFrame;
    
    YYInformationModel *model = informationFrame.model;
    //设置控件的Frame
    self.iconImageView.frame = informationFrame.iconImageViewF;
    self.sortTitleLabel.frame = informationFrame.sortTitleLabelF;
    self.contentTextLabel.frame = informationFrame.contentTextLabelF;
    self.timeLabel.frame = informationFrame.timeLabelF;
//    self.commentImageView.frame = informationFrame.commentImageViewF;
    self.lineView.frame = informationFrame.lineViewF;
    //设置数据
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.showimgurl] placeholderImage:[UIImage imageNamed:@"news_load2"]];

//    NSString *sortTitle = [NSString stringWithFormat:@"%@ | %@",model.sortStr, model.title];
    NSString *sortTitle = model.title;
    self.sortTitleLabel.text = sortTitle;
    
    self.contentTextLabel.text = model.intro;
//    NSInteger commentNumber = model.commentNumber.integerValue;
//    if (commentNumber >999) {
//        self.commentNumberLabel.text = @"999+";
//    }
//    else{
//        self.commentNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)commentNumber];
//    }
    //设置时间
    
    NSString *createTime = [model.createTime substringFromIndex:5];
    NSUInteger toIndex = createTime.length - 3;
    NSString *newCreateTime = [createTime substringToIndex:toIndex];
    self.timeLabel.text = newCreateTime;
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
