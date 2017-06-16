//
//  YYPullDownMenuView.h
//  pugongying
//
//  Created by wyy on 16/4/13.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYPullDownMenuView;

@protocol YYPullDownMenuViewDelegate <NSObject>

@required
- (void)pullDownMenuViewCellClickWithCellText:(NSString *)cellText;

@end

@interface YYPullDownMenuView : UIView

@property (nonatomic, weak) id<YYPullDownMenuViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)menuFrame andCellHeight:(CGFloat)cellH;
@end
