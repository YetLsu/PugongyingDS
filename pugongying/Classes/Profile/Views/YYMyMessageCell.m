//
//  YYMyMessageCell.m
//  pugongying
//
//  Created by wyy on 16/4/20.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYMyMessageCell.h"
#import "YYMyMessageFrame.h"
#import "YYMyMessageModel.h"

@interface YYMyMessageCell ()

/**
 *  左边的点的imageView
 */
@property (nonatomic, weak) UIImageView *readImageView;
/**
 *  消息类型的label
 */
@property (nonatomic, weak) UILabel *messageSortLabel;
/**
 *  消息内容的label
 */
@property (nonatomic, weak) UILabel *messageContentLabel;
/**
 *  消息时间的label
 */
@property (nonatomic, weak) UILabel *messageTimeLabel;


@end
@implementation YYMyMessageCell
+ (instancetype)myMessageCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"YYMyMessageCell";
    YYMyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YYMyMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        /**
         *  左边的点的imageView
         */
        UIImageView *readImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:readImageView];
        self.readImageView = readImageView;
        self.readImageView.image = [UIImage imageNamed:@"profile_collectMessage_dian"];
        /**
         *  消息类型的label
         */
        UILabel *messageSortLabel = [[UILabel alloc] init];
        [self.contentView addSubview:messageSortLabel];
        self.messageSortLabel = messageSortLabel;
        self.messageSortLabel.font = [UIFont systemFontOfSize:16.0];
        /**
         *  消息内容的label
         */
        UILabel *messageContentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:messageContentLabel];
        self.messageContentLabel = messageContentLabel;
        self.messageContentLabel.textColor = YYGrayTextColor;
        self.messageContentLabel.font = [UIFont systemFontOfSize:13.0];
        /**
         *  消息时间的label
         */
        UILabel *messageTimeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:messageTimeLabel];
        self.messageTimeLabel = messageTimeLabel;
        self.messageTimeLabel.textAlignment = NSTextAlignmentRight;
        self.messageTimeLabel.textColor = YYGrayTextColor;
        self.messageTimeLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return self;
}

- (void)setModelFrame:(YYMyMessageFrame *)modelFrame{
    _modelFrame = modelFrame;
    YYMyMessageModel *model = modelFrame.model;
    
    /**
     *  左边的点的imageView
     */

    if ([model.disable isEqualToString:@"1"]) {//已读
        self.readImageView.hidden = YES;
    }
    else{
        self.readImageView.hidden = NO;
    }
    self.readImageView.frame = modelFrame.readImageViewF;
    
    /**
     *  消息类型的label
     */
    self.messageSortLabel.frame = modelFrame.messageSortLabelF;
    self.messageSortLabel.text = model.title;
    /**
     *  消息内容的label
     */
    self.messageContentLabel.frame = modelFrame.messageContentLabelF;
    self.messageContentLabel.text = model.content;
    //增加线
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0,modelFrame.cellHeight - 0.5, YYWidthScreen, 0.5) andView:self.contentView];
    /**
     *  消息时间的label
     */
    self.messageTimeLabel.frame = modelFrame.messageTimeLabelF;
    NSString *createTime = [model.createTime substringWithRange:NSMakeRange(5, 5)];
    self.messageTimeLabel.text = createTime;
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
