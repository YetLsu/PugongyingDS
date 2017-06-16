//
//  YYMainDataModel.m
//  pugongying
//
//  Created by wyy on 16/5/10.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYMainDataModel.h"

@implementation YYMainDataModel
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.todayThing = [aDecoder decodeObjectForKey:@"todayThing"];
       
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.todayThing forKey:@"todayThing"];
}
@end
