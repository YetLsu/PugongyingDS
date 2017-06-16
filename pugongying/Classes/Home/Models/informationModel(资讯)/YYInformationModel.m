//
//  YYInformationModel.m
//  pugongying
//
//  Created by wyy on 16/3/3.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYInformationModel.h"


@interface YYInformationModel ()
@property (nonatomic, assign) NSInteger tag;

@end

@implementation YYInformationModel

/**
 *  tag值为0表示创建的是 资讯  里面的模型
 *  tag值为1表示创建的是 收藏  里面的模型
 */
- (instancetype)initWithTag:(NSInteger)tag{
    if (self = [super init]) {
        self.tag = tag;
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if (self.tag == 0) {
        if ([key isEqualToString:@"id"]) {
            self.newsID = value;
          
        }
    }
    else if(self.tag == 1){
        if ([key isEqualToString:@"unid"]) {
            self.newsID = value;
           
        }
    }
    if ([key isEqualToString:@"create_dt"]) {
        self.createTime = value;
    }
}

- (instancetype)initWithID:(NSString *)ID categoryid:(NSString *)categoryid title:(NSString *)title intro:(NSString *)intro showimgurl:(NSString *)showimgurl weburl:(NSString *)weburl commentnum:(NSString *)commentnum collectionnum:(NSString *)collectionnum sharenum:(NSString *)sharenum createTime:(NSString *)createTime recommend:(NSString *)recommend{
    if (self = [super init]) {
        self.newsID = ID;
        self.categoryid = categoryid;
        self.title = title;
        self.intro = intro;
        self.showimgurl = showimgurl;
        self.weburl = weburl;
        self.commentnum = commentnum;
        self.collectionnum = collectionnum;
        self.sharenum = sharenum;
        self.createTime = createTime;
        self.recommend = recommend;
    }
    return self;
}
@end
