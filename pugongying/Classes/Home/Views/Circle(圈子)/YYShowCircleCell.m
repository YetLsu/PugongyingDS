//
//  YYShowCircleCell.m
//  pugongying
//
//  Created by wyy on 16/5/31.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYShowCircleCell.h"
#import "YYShowCircleModel.h"


@interface YYShowCircleCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIView *circleNameView;
@property (weak, nonatomic) IBOutlet UILabel *circleIntroLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineConstraint;

@end

@implementation YYShowCircleCell
+ (instancetype)showCircleCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"YYShowCircleCell";
    YYShowCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YYShowCircleCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.joinBtn setBackgroundImage:[UIImage imageNamed:@"home_circle_joinBtnBG"] forState:UIControlStateNormal];
    [self.joinBtn setBackgroundImage:[UIImage imageNamed:@"home_circle_joinBtnBG"] forState:UIControlStateHighlighted];
    [self.joinBtn setBackgroundImage:[UIImage imageNamed:@"home_circle_haveJoinBtnBG"] forState:UIControlStateDisabled];
    [self.joinBtn setTitleColor:YYBlueTextColor forState:UIControlStateNormal];
    [self.joinBtn setTitleColor:YYBlueTextColor forState:UIControlStateHighlighted];
    [self.joinBtn setTitleColor:YYGrayLineColor forState:UIControlStateDisabled];

}

- (void)setCirclemodel:(YYShowCircleModel *)circlemodel{
    _circlemodel = circlemodel;
    
//    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:@"http://www.sxeto.com/App/dandelion/course/ali/1_003_b.png"]];
    
    self.iconImageView.image = [UIImage imageNamed:@"home_course"];
    self.circleIntroLabel.text = circlemodel.circleIntro;
    
    
    self.lineView.backgroundColor = YYGrayLineColor;
    
    self.lineConstraint.constant = 0.5;
  
    
}
- (IBAction)joinBtnClick:(UIButton *)sender {
    if (sender.enabled) {
        sender.enabled = NO;
        if ([self.delegate respondsToSelector:@selector(goCircleChatWithShowCircleModel:)]) {
            [self.delegate goCircleChatWithShowCircleModel:self.circlemodel];
        }
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
