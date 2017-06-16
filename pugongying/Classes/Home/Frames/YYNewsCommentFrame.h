//
//  YYNewsCommentFrame.h
//  pugongying
//
//  Created by wyy on 16/4/13.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYNewsCommentModel;
@interface YYNewsCommentFrame : NSObject

@property (nonatomic, strong) YYNewsCommentModel *model;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) CGFloat commentLabelH;

@end
