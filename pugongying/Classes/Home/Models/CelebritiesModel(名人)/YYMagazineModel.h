//
//  YYMagazineModel.h
//  pugongying
//
//  Created by wyy on 16/4/27.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYMagazineModel : NSObject
/**
 *  期刊ID
 */
@property (nonatomic, copy) NSString *magazineID;
/**
 *  分类（'人物刊','企业刊 '）
 */
@property (nonatomic, copy) NSString *magazineCategory;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *magazineTitle;
/**
 *  简介
 */
@property (nonatomic, copy) NSString *magazineIntro;
/**
 *  展示图地址
 */
@property (nonatomic, copy) NSString *magazineShowimgurl;
/**
 *  网页链接
 */
@property (nonatomic, copy) NSString *magazineWebUrl;
/**
 *  访问人次数
 */
@property (nonatomic, copy) NSString *magazineVisitNum;
/**
 *  分享数
 */
@property (nonatomic, copy) NSString *magazineShareNum;

- (instancetype)initWithID:(NSString *)ID category:(NSString *)category title:(NSString *)title intro:(NSString *)intro showimgurl:(NSString *)showimgurl weburl:(NSString *)weburl visitnum:(NSString *)visitnum sharenum:(NSString *)sharenum;
@end
