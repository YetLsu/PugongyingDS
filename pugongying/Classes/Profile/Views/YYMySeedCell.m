//
//  YYMySeedCell.m
//  pugongying
//
//  Created by wyy on 16/4/19.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYMySeedCell.h"
#import "YYMySeedCellFrame.h"
#import "YYMySeedCellModel.h"


@interface YYMySeedCell ()
/**
 *  种子左侧的图片
 */
@property (nonatomic, weak) UIImageView *seedLeftIconImageView;
/**
 *  种子赠送或消耗原因
 */
@property (nonatomic, weak) UILabel *seedContentLabel;
/**
 *  种子时间
 */
@property (nonatomic, weak) UILabel *timeLabel;
/**
 *  种子增加或减少量
 */
@property (nonatomic, weak) UILabel *seedNumberLabel;

@end

@implementation YYMySeedCell
+ (instancetype)MySeedCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"YYMySeedCell";
    YYMySeedCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YYMySeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        /**
         *  种子左侧的图片
         */
        UIImageView *seedLeftIconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:seedLeftIconImageView];
        self.seedLeftIconImageView = seedLeftIconImageView;
        /**
         *  种子赠送或消耗原因
         */
        UILabel *seedContentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:seedContentLabel];
        self.seedContentLabel = seedContentLabel;
        self.seedContentLabel.textColor = YYGrayTextColor;
        self.seedContentLabel.font = [UIFont systemFontOfSize:14.0];
        /**
         *  种子时间
         */
        UILabel *timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        self.timeLabel.textColor = YYGrayTextColor;
        self.timeLabel.font = [UIFont systemFontOfSize:12.0];
        /**
         *  种子增加或减少量
         */
        UILabel *seedNumberLabel = [[UILabel alloc] init];
        [self.contentView addSubview:seedNumberLabel];
        self.seedNumberLabel = seedNumberLabel;
        self.seedNumberLabel.textColor = YYBlueTextColor;
    }
    return self;
}

- (void)setModelFrame:(YYMySeedCellFrame *)modelFrame{
    _modelFrame = modelFrame;
    
    YYMySeedCellModel *model = modelFrame.model;
    
    /**
     *  种子左侧的图片
     */
    self.seedLeftIconImageView.frame = modelFrame.seedLeftIconF;
    self.seedLeftIconImageView.image = [UIImage imageNamed:@"profile_seed_small"];
    /**
     *  种子赠送或消耗原因
     */
    self.seedContentLabel.frame = modelFrame.seedContentF;
    self.seedContentLabel.text = model.content;
    /**
     *  种子时间
     */
    self.timeLabel.frame = modelFrame.timeF;
    NSString *time = [model.create_dt substringWithRange:NSMakeRange(5, 11)];
    self.timeLabel.text = time;
    /**
     *  种子增加或减少量
     */
    self.seedNumberLabel.frame = modelFrame.seedNumberF;
    int number = model.seednum.intValue;
    if ([model.change isEqualToString:@"1"]) {
        self.seedNumberLabel.text = [NSString stringWithFormat:@"+%d",number];
    }
    else if ([model.change isEqualToString:@"-1"]){
        self.seedNumberLabel.text = [NSString stringWithFormat:@"-%d",number];
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
