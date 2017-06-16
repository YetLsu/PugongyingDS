//
//  YYMagazineModel.m
//  pugongying
//
//  Created by wyy on 16/4/27.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYMagazineModel.h"

@implementation YYMagazineModel
- (instancetype)initWithID:(NSString *)ID category:(NSString *)category title:(NSString *)title intro:(NSString *)intro showimgurl:(NSString *)showimgurl weburl:(NSString *)weburl visitnum:(NSString *)visitnum sharenum:(NSString *)sharenum{
    if (self = [super init]) {
        self.magazineID = ID;
        self.magazineCategory = category;
        self.magazineTitle = title;
        self.magazineIntro = intro;
        self.magazineShowimgurl = showimgurl;
        self.magazineWebUrl = weburl;
        self.magazineVisitNum = visitnum;
        self.magazineShareNum = sharenum;
    }
    return self;
}
@end
