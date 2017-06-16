//
//  YYPullDownMenuView.m
//  pugongying
//
//  Created by wyy on 16/4/13.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYPullDownMenuView.h"

@interface YYPullDownMenuView ()<UITableViewDelegate, UITableViewDataSource>{
    CGFloat _cellH;
    CGFloat _topMargin;
    CGFloat _tableViewXMargin;
    CGFloat _tableViewYMargin;
}
@property (nonatomic, weak) UIImageView *bgImageView;

@property (nonatomic, weak) UITableView *tableView;
@end

@implementation YYPullDownMenuView
- (instancetype)initWithFrame:(CGRect)menuFrame andCellHeight:(CGFloat)cellH{
    if (self = [super initWithFrame:menuFrame]) {
        _topMargin = 7;
        _tableViewXMargin = 2;
        _tableViewYMargin = 2;
        
        _cellH = cellH - _tableViewYMargin;
        
        //增加背景图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = [UIImage imageNamed:@"home_information_add_bottom"];
        [self addSubview:imageView];
        self.bgImageView = imageView;
        //增加tableView
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
        self.tableView = tableView;
        self.tableView.scrollEnabled = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.bgImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    CGFloat tableViewX = _tableViewXMargin;
    CGFloat tableViewY = _topMargin + _tableViewYMargin;
    CGFloat tableViewW = frame.size.width - _tableViewXMargin * 2;
    CGFloat tableViewH = frame.size.height - _topMargin - _tableViewYMargin * 2;
    self.tableView.frame = CGRectMake(tableViewX,tableViewY, tableViewW, tableViewH);
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"收藏文章";
        [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, _cellH - 0.5, YYWidthScreen, 0.5) andView:cell.contentView];
    }
    else if (indexPath.row == 1){
        cell.textLabel.text = @"分享文章";
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cellH;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *labelText = nil;
    if (indexPath.row == 0) {
        labelText = @"收藏";
    }
    else if (indexPath.row == 1){
        labelText = @"分享";
    }
    
    if ([self.delegate respondsToSelector:@selector(pullDownMenuViewCellClickWithCellText:)]) {
        [self.delegate pullDownMenuViewCellClickWithCellText:labelText];
    }
}
@end
