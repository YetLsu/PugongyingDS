//
//  YYCourseCommentModel.h
//  pugongying
//
//  Created by wyy on 16/2/26.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYCourseCommentModel : NSObject
/**
 *  用户头像的URL
 */
@property (nonatomic, copy) NSString *iconURLStr;
/**
 *  用户昵称
 */
@property (nonatomic, copy) NSString *userName;
/**
 *  评论内容
 */
@property (nonatomic, copy) NSString *commentStr;
/**
 *  时间
 */
@property (nonatomic, copy) NSString *dateStr;
/**
 *  评分
 */
@property (nonatomic, copy) NSString *commentScore;

- (instancetype)initWithiconURL:(NSString *)iconURLStr userName:(NSString *)userName commentStr:(NSString *)commentStr dateStr:(NSString *)dateStr commentScore:(NSString *)commentScore;
@end
