//
//  YYCerebritiesTableViewCell.m
//  pugongying
//
//  Created by wyy on 16/3/7.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYMagazineModelTableViewCell.h"
#import "YYMagazineModel.h"

@interface YYMagazineModelTableViewCell ()
/**
 *  图片的ImageView
 */
@property (nonatomic, weak) UIImageView *cereImageView;
/**
 *  图片上的按钮
 */
//@property (nonatomic, weak) UIButton *imageBtn;
@end

@implementation YYMagazineModelTableViewCell
+ (instancetype)cerebritiesTableViewCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"YYMagazineModelTableViewCell";
    
    YYMagazineModelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YYMagazineModelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 图片的ImageView
        CGFloat cereImageViewH = 210/667.0*YYHeightScreen;
        UIImageView *cereImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, YYWidthScreen, cereImageViewH)];
        [self.contentView addSubview:cereImageView];
        self.cereImageView = cereImageView;
    
    }
    return self;
}

- (void)setModel:(YYMagazineModel *)model{
    _model = model;
    
    NSURL *url = [NSURL URLWithString:model.magazineShowimgurl];
    [self.cereImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"person_load1"]];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
