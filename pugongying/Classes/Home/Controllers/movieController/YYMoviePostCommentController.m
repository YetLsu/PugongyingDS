//
//  YYMoviePostCommentController.m
//  pugongying
//
//  Created by wyy on 16/4/7.
//  Copyright © 2016年 WYY. All rights reserved.
//
/**
 *  五颗星星的tag值是0，1，2，3，4
 */
#import "YYMoviePostCommentController.h"
#import "YYCourseCollectionCellModel.h"
#import "YYCourseCommentModel.h"
#import "YYUserTool.h"

#define topLabelH 22
#define centerLabelH 20
#define bottomViewH 50
#define YYAddCourseCommentSuccess @"YYAddCourseCommentSuccess"
#define YYCourseSuccessComment @"YYCourseSuccessComment"
@interface YYMoviePostCommentController ()<UITextViewDelegate>{
    CGFloat _scale;             //高度的比例
    CGFloat _yMargin;           //垂直方向上的间隔，一个单位
    CGFloat _topLabelH;         //课程评论Label的高度
    CGFloat _starH;             //星星的高度
    CGFloat _centerLabelH;      //点击为课程评分的Label
    CGFloat _commentCircleH;    //课程评论的框的高度
    CGFloat _bottomViewH;       //底部View的高度
    /**
     *  在textView中占位的占位字符串
     */
    NSString *_placeholderText;
    /**
     *  整体的遮盖层
     */
    UIButton *_bigCoverBtn;
    /**
     *  输入框上的遮盖层
     */
    UIButton *_textViewCoverBtn;
    /**
     * 点击输入框后判断是否要清除文字,yes表示要清除，既未输入文字
     */
    BOOL _write;
    /**
     *  输入框上移的高度
     */
    CGFloat _offsetH;
    /**
     *  判断是否评分过
     */
    CGFloat _comment;
    
    YYCourseCollectionCellModel *_courseModel;
    /**
     *  课程评分，星星数
     */
    NSInteger _starNumber;
}
/**
 *  课程评论的View
 */
@property (nonatomic, weak) UIView *courseCommentView;
/**
 *  课程评价星星的View
 */
@property (nonatomic, weak) UIView *starsView;
/**
 *  点击为课程评分的Label
 */
@property (nonatomic, weak) UILabel *commentLabel;
/**
 *  课程评论的TextView
 */
@property (nonatomic, weak) UITextView *commentTextView;
/**
 *  课程评论的TextView的父View
 */
@property (nonatomic, weak) UIView *commentSuperView;
/**
 *  提交按钮
 */
@property (nonatomic, weak) UIButton *postBtn;
@end

@implementation YYMoviePostCommentController
/**
 *  创建课程的评论
 */
- (instancetype) initWithCourseCommentControllerWithModel:(YYCourseCollectionCellModel *)model{
    if (self = [super init]) {
        _courseModel = model;
        self.title = @"提交评分";
        self.view.backgroundColor = [UIColor whiteColor];
        
        //设置各部分的高度
        [self setViewsHeightAndSetupViews];
        //        增加底部的View
        CGFloat bottomViewY = YYHeightScreen - _bottomViewH;
        [self addBottomViewWithFrame:CGRectMake(0, bottomViewY, YYWidthScreen, bottomViewH)];
        
        //增加上面课程评论的View
        self.courseCommentView = [self addTopCourseCommentView];
        
        //增加五个星星的View
        self.starsView = [self addStarsView];
        
        //增加点击为课程评分的Label
        CGFloat labelY = CGRectGetMaxY(self.starsView.frame) + _yMargin;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, labelY, YYWidthScreen, _centerLabelH)];
        label.text = @"点击为课程评分";
        label.textAlignment =NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = YYGrayTextColor;
        [self.view addSubview:label];
        self.commentLabel = label;
        
        //增加评论的textView
        self.commentSuperView = [self addCommentTextView];
        
        //增加下面的白色View
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, YYHeightScreen, YYWidthScreen, _offsetH)];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bottomView];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
#pragma mark 设置各部分的高度
/**
 *  设置各部分的高度
 */
- (void)setViewsHeightAndSetupViews{
    _topLabelH = 22;
    _centerLabelH = 20;
    _bottomViewH = 50;
    
    CGFloat otherH = 64 + _topLabelH + _centerLabelH + _bottomViewH;
    _scale = (YYHeightScreen - otherH)/(667.0 - otherH);
    
    _starH = 41.5 * _scale;
    _commentCircleH = 290 * _scale;
    
    _yMargin = (YYHeightScreen - otherH - _starH - _commentCircleH)/8;
    
    _write = YES;
    
    //初始化控件
    _placeholderText = @"您宝贵的评价，对我们至关重要，字数上限150字";
    
    /**
     *  整体的遮盖层
     */
    _bigCoverBtn = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_bigCoverBtn addTarget:self action:@selector(bigCoverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bigCoverBtn];
    _bigCoverBtn.backgroundColor = [UIColor clearColor];
    
    CGFloat height = _topLabelH + _starH + _centerLabelH + 5 * _yMargin;
    if (height > _commentCircleH) {
        _offsetH = _commentCircleH;
    }
    else{
        _offsetH = height;
    }
    
    _comment = NO;
}
/**
 *  遮盖层被点击
 *
 */
- (void)bigCoverBtnClick{
    [self.view endEditing:YES];
}
#pragma mark 增加上面课程评论的View
/**
 *  增加上面课程评论的View
 */
- (UIView *)addTopCourseCommentView{
    UIView *commentView = [[UIView alloc] init];
//    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:commentView];
    
    CGFloat commentViewY = 64 + 2 * _yMargin;
    commentView.frame = CGRectMake(0, commentViewY, YYWidthScreen, _topLabelH);
    
    //增加中间的Label
    CGFloat labelW = 90;
    CGFloat labelX = (YYWidthScreen - labelW)/2.0;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 0, labelW, _topLabelH)];
    [commentView addSubview:label];
    label.text = @"课程评价";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = YYGrayLineColor;
    label.font = [UIFont systemFontOfSize:16.0];
    
    //增加左右两条线
    CGFloat lineY = commentView.frame.size.height*0.5;
    CGFloat lineW = (YYWidthScreen - labelW - YY18WidthMargin * 2)/2.0;
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(YY18WidthMargin, lineY, lineW, 0.5) andView:commentView];
    
    CGFloat rightLineX = YY18WidthMargin + lineW + labelW;
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(rightLineX, lineY, lineW, 0.5) andView:commentView];
    
    return commentView;
}

#pragma mark 增加五个星星的View
/**
 *  增加五个星星的View
 */
- (UIView *)addStarsView{
    CGFloat starsViewY = CGRectGetMaxY(self.courseCommentView.frame) + _yMargin * 2;
    UIView *starsView = [[UIView alloc] initWithFrame:CGRectMake(0, starsViewY, YYWidthScreen, _starH)];
    [self.view addSubview:starsView];
    
    CGFloat starW = 45 * _scale;
    CGFloat starMargin = 13.5 * _scale;
    CGFloat firstStarX = (YYWidthScreen - starW * 5 - starMargin * 4)/2.0;
    
    [self addStarToStarsViewWithFrame:CGRectMake(firstStarX, 0, starW, _starH) andSuperView:starsView andTag:0];
    
    [self addStarToStarsViewWithFrame:CGRectMake(firstStarX + (starW + starMargin) * 1, 0, starW, _starH) andSuperView:starsView andTag:1];
    
    [self addStarToStarsViewWithFrame:CGRectMake(firstStarX + (starW + starMargin) * 2, 0, starW, _starH) andSuperView:starsView andTag:2];
    
    [self addStarToStarsViewWithFrame:CGRectMake(firstStarX + (starW + starMargin) * 3, 0, starW, _starH) andSuperView:starsView andTag:3];
    
    [self addStarToStarsViewWithFrame:CGRectMake(firstStarX + (starW + starMargin) * 4, 0, starW, _starH) andSuperView:starsView andTag:4];
    
    return starsView;
}
/**
 *  增加一颗星星
 */
- (void)addStarToStarsViewWithFrame:(CGRect)starFrame andSuperView:(UIView *)starsView andTag:(NSInteger)tag{
    
    UIButton *starBtn = [[UIButton alloc] initWithFrame:starFrame];
    [starsView addSubview:starBtn];
    
    
    [starBtn setImage:[UIImage imageNamed:@"singleStar_kong"] forState:UIControlStateNormal];
    [starBtn setImage:[UIImage imageNamed:@"singleStar_Full"] forState:UIControlStateHighlighted];
    [starBtn setImage:[UIImage imageNamed:@"singleStar_Full"] forState:UIControlStateSelected];
    
    starBtn.tag = tag;
    
    [starBtn addTarget:self action:@selector(starBtnClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
}
/**
 *  其中一颗星星被点击
 */
- (void)starBtnClickWithBtn:(UIButton *)btn{
//    YYLog(@"%@",self.starsView.subviews);
//    YYLog(@"%ld(long)",btn.tag);
    _comment = YES;
    _starNumber = btn.tag + 1;
    for (UIView * btnView in self.starsView.subviews) {
        
        if ([btnView isKindOfClass:[UIButton class]]) {
            UIButton *starBtn = (UIButton *)btnView;
            
            if (starBtn.tag <= btn.tag) starBtn.selected = YES;

            else starBtn.selected = NO;
        }
    }
}
#pragma mark 增加底部的View
- (void)addBottomViewWithFrame:(CGRect)bottomFrame{
    UIView *bottomView = [[UIView alloc] initWithFrame:bottomFrame];
    [self.view addSubview:bottomView];
    
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, 0, YYWidthScreen, 0.5) andView:bottomView];
    CGFloat postBtnX = 25/375.0 * YYWidthScreen;
    CGFloat postBtnW = YYWidthScreen -  postBtnX * 2;
    CGFloat postBtnY = 5;
    CGFloat postBtnH = bottomFrame.size.height - 2 * postBtnY;
    UIButton *postBtn = [[UIButton alloc] initWithFrame:CGRectMake(postBtnX, postBtnY, postBtnW, postBtnH)];
    [bottomView addSubview:postBtn];
    self.postBtn = postBtn;
    [postBtn setTitle:@"提交" forState:UIControlStateNormal];
    [postBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [postBtn setBackgroundImage:[UIImage imageNamed:@"btn_home_movie_post"] forState:UIControlStateNormal];
    
    [postBtn addTarget:self action:@selector(postBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark 增加评论的textView
/**
 *  增加评论的textView,把textView放在View上
 */
- (UIView *)addCommentTextView{
    CGFloat superViewY = CGRectGetMaxY(self.commentLabel.frame) + _yMargin;
    CGFloat superViewW = YYWidthScreen - 2 * YY18WidthMargin;
    UIView *superView = [[UIView alloc] initWithFrame:CGRectMake(YY18WidthMargin, superViewY, superViewW, _commentCircleH)];
    [self.view addSubview:superView];

    //增加背景框
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:superView.bounds];
    bgImageView.image = [UIImage imageNamed:@"home_movie_textViewBG"];
    [superView addSubview:bgImageView];
    
    //增加TextView
    CGFloat margin = 20 * _scale;
    CGFloat textViewW = superViewW - margin * 2;
    CGFloat textViewY = margin;
    CGFloat textViewH = _commentCircleH - margin - 2;
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(margin, textViewY, textViewW, textViewH)];
    [superView addSubview:textView];
    //设置提示文字
    textView.text = _placeholderText;
    textView.textColor = YYGrayLineColor;
    textView.font = [UIFont systemFontOfSize:17.0];
    
    self.commentTextView = textView;
    self.commentTextView.delegate = self;
    
    //创建输入框上的按钮用来删除占位文字
    _textViewCoverBtn = [[UIButton alloc] initWithFrame:bgImageView.frame];
    _textViewCoverBtn.backgroundColor = [UIColor clearColor];
    [superView addSubview:_textViewCoverBtn];
    [_textViewCoverBtn addTarget:self action:@selector(textViewCoverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return superView;
}
/**
 *  textView上的按钮被点击
 */
- (void)textViewCoverBtnClick{
    YYLog(@"textView上的按钮被点击");
    if (_write) {//yes表示要清除
        self.commentTextView.text = nil;
        self.commentTextView.textColor = YYGrayTextColor;
    }
    
    [_textViewCoverBtn removeFromSuperview];
    [self.commentTextView becomeFirstResponder];
}
/**
 *  提交按钮被点击
 */
- (void)postBtnClick{
    if (self.commentTextView.text.length == 0) {
        _write = YES;
    }
    else{
        _write = NO;
    }


    if (!_comment) {
        [MBProgressHUD showError:@"请先评分"];
        return;
    }
    else if (_write){
        [MBProgressHUD showError:@"请输入评论"];
        return;
    }
    [MBProgressHUD showMessage:@"正在提交评论"];
    
    YYLog(@"提交按钮被点击");
    NSURL *url = [NSURL URLWithString:YYHTTPInsertPOST];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    request.HTTPMethod = @"POST";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"11";
    parameters[@"userid"] = [[NSUserDefaults standardUserDefaults]objectForKey:YYUserID];
    parameters[@"courseid"] = _courseModel.courseID;
    NSString *starNumber = [NSString stringWithFormat:@"%ld",(long)_starNumber];
    YYLog(@"评分：%@",starNumber);
    parameters[@"score"] = starNumber;
    
    parameters[@"content"] = self.commentTextView.text;
    YYLog(@"%@评论内容",self.commentTextView.text);
    NSError *error = nil;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
    YYLog(@"打包数据%@",error);
    
    request.HTTPBody = data;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        [MBProgressHUD hideHUD];
        
        if (connectionError) {
            [MBProgressHUD showError:@"网络连接失败"];
            return ;
        }
        YYLog(@"%@",data);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        YYLog(@"返回值%@",dict);
        if ([dict[@"msg"] isEqualToString:@"ok"]) {
            [MBProgressHUD showSuccess:@"成功评论"];
            [self.navigationController popViewControllerAnimated:YES];
  
            //            通知资讯评论列表进行刷新
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            YYUserModel *userModel = [YYUserTool userModel];
            YYCourseCommentModel *commentModel = [[YYCourseCommentModel alloc] initWithiconURL:userModel.headimgurl userName:userModel.nickname commentStr:self.commentTextView.text dateStr:@"1秒前" commentScore:starNumber];
            dic[YYCourseSuccessComment] = commentModel;
            [[NSNotificationCenter defaultCenter] postNotificationName:YYAddCourseCommentSuccess object:self userInfo:dic];
        }
        
    }];

}

#pragma mark textView的代理方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    YYLog(@"开始输入");
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.view.y = -_offsetH;
    }];
    
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    YYLog(@"结束输入");
    __weak typeof(self) weakSelf = self;

    [self.commentSuperView addSubview:_textViewCoverBtn];
    if (self.commentTextView.text.length == 0) {
        self.commentTextView.text = _placeholderText;
        self.commentTextView.textColor = YYGrayLineColor;
        _write = YES;
    }
    else{
        _write = NO;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.view.y = 0;
    }];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    
//    if ([text isEqualToString:@"\n"]) {
//        
//        [textView resignFirstResponder];
//        return NO;
//    }
//    
//    return YES;
//}

@end
