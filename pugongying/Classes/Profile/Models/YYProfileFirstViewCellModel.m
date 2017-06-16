//
//  YYProfileFirstViewCellModel.m
//  pugongying
//
//  Created by wyy on 16/4/18.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYProfileFirstViewCellModel.h"

@implementation YYProfileFirstViewCellModel

- (instancetype)initWithIcon:(UIImage *)iconImage title:(NSString *)title hiddenDian:(BOOL)hiddenDian{
    if (self = [super init]) {
        self.icon = iconImage;
        self.title = title;
        self.hiddenDian = hiddenDian;
    }
    return self;
}
@end
