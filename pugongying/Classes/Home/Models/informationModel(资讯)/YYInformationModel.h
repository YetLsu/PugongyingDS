//
//  YYInformationModel.h
//  pugongying
//
//  Created by wyy on 16/3/3.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYInformationModel : NSObject
/**
*  资讯ID
*/
@property (nonatomic, copy) NSString *newsID;
/**
 *  分类ID
 */
@property (nonatomic, copy) NSString *categoryid;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  简介
 */
@property (nonatomic, copy) NSString *intro;
/**
 *  展示图地址
 */
@property (nonatomic, copy) NSString *showimgurl;
/**
 *  网页链接
 */
@property (nonatomic, copy) NSString *weburl;
/**
 *  评论数
 */
@property (nonatomic, copy) NSString *commentnum;
/**
 *  收藏数
 */
@property (nonatomic, copy) NSString *collectionnum;
/**
 *  分享数
 */
@property (nonatomic, copy) NSString *sharenum;
/**
 *  创建时间time
 */
@property (nonatomic, copy) NSString *createTime;
/**
 * 是否推荐，0不推荐，1推荐
 */
@property (nonatomic, copy) NSString *recommend;
/**
 * 用户ID
 */
@property (nonatomic, copy) NSString *userID;

- (instancetype)initWithID:(NSString *)ID categoryid:(NSString *)categoryid title:(NSString *)title intro:(NSString *)intro showimgurl:(NSString *)showimgurl weburl:(NSString *)weburl commentnum:(NSString *)commentnum collectionnum:(NSString *)collectionnum sharenum:(NSString *)sharenum createTime:(NSString *)createTime recommend:(NSString *)recommend;

/**
 *  tag值为0表示创建的是 资讯  里面的模型
 *  tag值为1表示创建的是 收藏  里面的模型
 */
- (instancetype)initWithTag:(NSInteger)tag;
@end
