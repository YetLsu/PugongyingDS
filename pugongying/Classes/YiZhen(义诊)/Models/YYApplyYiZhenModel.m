//
//  YYApplyYiZhenModel.m
//  pugongying
//
//  Created by wyy on 16/3/10.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYApplyYiZhenModel.h"

@implementation YYApplyYiZhenModel
- (instancetype)initWithUserName:(NSString *)userName phoneNumber:(NSString *)phoneNumber QQ:(NSString *)QQ storeAddress:(NSString *)storeAddress storeTime:(NSString *)storeTime storeDayTime:(NSString *)storeDayTime platform:(NSString *)platform storeFitment:(NSString *)storeFitment someone:(NSString *)someone{
    if (self = [super init]) {
        self.userName = userName;
        self.phoneNumber = phoneNumber;
        self.QQ = QQ;
        self.storeAddress = storeAddress;
        self.storeTime = storeTime;
        self.storeDayTime = storeDayTime;
        self.platform = platform;
        self.storeFitment = storeFitment;
        self.someone = someone;
    }
    return self;
}
@end
