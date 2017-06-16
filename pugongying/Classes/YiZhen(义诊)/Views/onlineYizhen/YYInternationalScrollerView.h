//
//  YYinternationalScrollerView.h
//  pugongying
//
//  Created by wyy on 16/3/22.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYInternationalScrollerView : UIScrollView
/**
 *  店铺链接/公司全称
 */
@property (nonatomic, weak) UITextField *storeAddressTextField;

/**
 *  店铺装修按钮数组
 */
//@property (nonatomic, strong) NSMutableArray *firstBtnsArray;
/**
 *  是否专人负责数组
 */
//@property (nonatomic, strong) NSMutableArray *secondBtnsArray;
/**
 *  是否推广付费数组
 */
//@property (nonatomic, strong) NSMutableArray *thirdBtnsArray;
/**
 *  店铺操作时间数组
 */
@property (nonatomic, strong) NSMutableArray *fouthBtnsArray;
/**
 *  每周上传产品数量
 */
@property (nonatomic, strong) NSMutableArray *fiveBtnsArray;
/**
 *  是否适用P4P业务
 */
@property (nonatomic, strong) NSMutableArray *sixBtnsArray;
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
