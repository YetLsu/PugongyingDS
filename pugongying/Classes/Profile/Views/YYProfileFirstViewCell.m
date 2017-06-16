//
//  YYProfileFirstViewCell.m
//  pugongying
//
//  Created by wyy on 16/4/18.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYProfileFirstViewCell.h"
#import "YYProfileFirstViewCellModel.h"

@interface YYProfileFirstViewCell ()

@property (nonatomic, weak) UIImageView *iconImageView;

@property (nonatomic, weak) UILabel *titleLabel;



@end

@implementation YYProfileFirstViewCell

+ (instancetype)profileFirstViewCellWithTable:(UITableView *)tableView{
    static NSString *ID = @"YYProfileFirstViewCell";
    
    YYProfileFirstViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[YYProfileFirstViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat iconX = YY18WidthMargin;
        
        CGFloat rowHeight = 56 /375.0 * YYWidthScreen;
        
        CGFloat iconH = 30;
        CGFloat iconW = 21;
        CGFloat iconY = (rowHeight - iconH)/2.0;
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, iconW, iconH)];
        [self.contentView addSubview:icon];
        self.iconImageView = icon;
        icon.contentMode = UIViewContentModeCenter;
        
        CGFloat labelW = 70;
        CGFloat labelX = CGRectGetMaxX(icon.frame) + YY18WidthMargin;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, iconY, labelW, iconH)];
        [self.contentView addSubview:label];
        self.titleLabel = label;
        
        CGFloat dianW = 7.5;
        
        UIImageView *dianImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), iconY, dianW, dianW)];
        [self.contentView addSubview:dianImageView];
        self.dianImageView = dianImageView;
        self.dianImageView.image = [UIImage imageNamed:@"profile_collectMessage_dian"];
 
    }
    return self;
}

- (void)setModel:(YYProfileFirstViewCellModel *)model{
    _model = model;
    
    self.iconImageView.image = model.icon;
    
    self.titleLabel.text = model.title;
    
    self.dianImageView.hidden = model.hiddenDian;
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
