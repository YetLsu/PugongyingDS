//
//  YYAliScrollerView.h
//  pugongying
//
//  Created by wyy on 16/3/22.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYAliScrollerView : UIScrollView
/**
 *  公司全称/账号ID
 */
@property (nonatomic, weak) UITextField *storeAddressTextField;
/**
 *  店铺主营产品
 */
@property (nonatomic, weak) UITextField *storeSellTextField;
/**
 *  店铺装修按钮数组
 */
//@property (nonatomic, strong) NSMutableArray *firstBtnsArray;
/**
 *  是否专人负责数组
 */
//@property (nonatomic, strong) NSMutableArray *secondBtnsArray;
/**
 *  是否有请美工数组
 */
@property (nonatomic, strong) NSMutableArray *thirdBtnsArray;
/**
 *  是否参加活动
 */
//@property (nonatomic, strong) NSMutableArray *fouthBtnsArray;
/**
 *  店铺操作时间数组
 */
@property (nonatomic, strong) NSMutableArray *fiveBtnsArray;

/**
 * 店铺情况补充
 */
@property (nonatomic, weak) UITextView *textView;
/**
 *  检测是否有输入的文字，yes表示有，no表示没有
 */
@property (nonatomic, assign,getter=isHaveWriteText) BOOL haveWriteText;
/**
 *  是否是输入框在输入
 */
@property (nonatomic, assign) BOOL textViewWrite;

@end
