//
//  YYMySeedCellModel.m
//  pugongying
//
//  Created by wyy on 16/4/19.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYMySeedCellModel.h"

@implementation YYMySeedCellModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.seedID = value;
    }
}
@end
