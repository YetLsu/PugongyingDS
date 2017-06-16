//
//  YYProfileFirstViewCellModel.h
//  pugongying
//
//  Created by wyy on 16/4/18.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYProfileFirstViewCellModel : NSObject

@property (nonatomic, strong) UIImage *icon;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL hiddenDian;

- (instancetype)initWithIcon:(UIImage *)iconImage title:(NSString *)title hiddenDian:(BOOL)hiddenDian;
@end
