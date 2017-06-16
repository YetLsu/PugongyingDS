//
//  YYPostQuestionViewController.m
//  pugongying
//
//  Created by wyy on 16/3/1.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYPostQuestionViewController.h"
//选择照片要使用的
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"

@interface YYPostQuestionViewController ()<TZImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
/**
 *  输入的文字
 */
@property (nonatomic, weak) UITextView *textView;
/**
 *  检测是否是第一次输入文字
 */
@property (nonatomic, assign,getter=isFirstWrite) BOOL firstWrite;
/**
 *  蒙版按钮
 */
@property (nonatomic, strong) UIButton *coverBtn;
/******************************--选择照片用到的属性---------*********************/
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, assign) CGFloat itemWH;
@property (nonatomic, assign) CGFloat margin;

@end
static NSString *placeholderStr = @"请你试着尽量将问题描述的清晰完整，这样回答者才能更高质量和准确的为你解答";
@implementation YYPostQuestionViewController
/******************************--选择照片--开始---------*********************/
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _margin = 4;
        _itemWH = (self.view.tz_width - 2 * _margin - 4) / 3 - _margin;
        layout.itemSize = CGSizeMake(_itemWH, _itemWH);
        layout.minimumInteritemSpacing = _margin;
        layout.minimumLineSpacing = _margin;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_margin, 64 + 160 + 30, self.view.tz_width - 2 * _margin, 400) collectionViewLayout:layout];
        CGFloat rgb = 244 / 255.0;
        _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
        _collectionView.contentInset = UIEdgeInsetsMake(4, 0, 0, 2);
        _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self.view addSubview:_collectionView];

    }
    return _collectionView;
}
- (NSMutableArray *)selectedAssets{
    if (!_selectedAssets) {
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}
- (NSMutableArray *)selectedPhotos{
    if (!_selectedPhotos) {
        _selectedPhotos = [NSMutableArray array];
    }
    return _selectedPhotos;
}

#pragma mark UICollectionView的数据源方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    if (indexPath.row == self.selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn"];
    } else {
        cell.imageView.image = self.selectedPhotos[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.selectedPhotos.count) [self pickPhotoButtonClick:nil];
}
#pragma mark Click Event

- (void)pickPhotoButtonClick:(UIButton *)sender {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
        
    }];
    
    // Set the appearance
    // 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // Set allow picking video & originalPhoto or not
    // 设置是否可以选择视频/原图
    // imagePickerVc.allowPickingVideo = NO;
    // imagePickerVc.allowPickingOriginalPhoto = NO;
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

/// User finish picking photo，if assets are not empty, user picking original photo.
/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    [self.selectedPhotos addObjectsFromArray:photos];
    [self.collectionView reloadData];
    self.collectionView.contentSize = CGSizeMake(0, ((self.selectedPhotos.count + 2) / 3 ) * (self.margin + self.itemWH));
}

/// User finish picking video,
/// 用户选择好了视频
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    [self.selectedPhotos addObjectsFromArray:@[coverImage]];
    [self.collectionView reloadData];
    self.collectionView.contentSize = CGSizeMake(0, ((self.selectedPhotos.count + 2) / 3 ) * (self.margin + self.itemWH));
}
/******************************--选择照片---结束---------*********************/
/**
 *  蒙版按钮懒加载
 */
- (UIButton *)coverBtn{
    if (!_coverBtn) {
        CGFloat textViewH = 160;
        CGFloat textViewY = YY12HeightMargin + 64;
        CGFloat tableViewY =textViewY + textViewH;
        CGFloat tableViewH = YYHeightScreen -tableViewY;
        _coverBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, tableViewY, YYWidthScreen, tableViewH)];
        _coverBtn.backgroundColor = [UIColor clearColor];
        [_coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _coverBtn;
}
//蒙版按钮被点击
- (void)coverBtnClick{
    [self.coverBtn removeFromSuperview];
    [self.textView resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请描述你的问题";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //增加取消和下一步按钮
    [self addCancelBtnAndNextBtn];
    
    //增加输入框
    CGFloat textViewH = 160;
    CGFloat textViewW = YYWidthScreen - 2 * YY18WidthMargin;
    CGFloat textViewY = YY12HeightMargin + 64;
    [self addTextViewWithFrame:CGRectMake(YY18WidthMargin, textViewY, textViewW, textViewH)];
    //增加底部的View
    CGFloat bottomViewHeight = 48;
    [self addBottomViewWithHeight:bottomViewHeight];
    
    //注册UICollectionViewCell
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    
}
#pragma mark 监听输入框的方法
/**
 *  输入框开始输入
 */
- (void)beginWrite{
    YYLog(@"beginWrite");
    if (self.isFirstWrite) return;
    
    self.textView.text = nil;
    self.textView.textColor = [UIColor blackColor];
    
}
/**
 *  输入框正在输入
 */
- (void)nowWrite{
    YYLog(@"输入框长在输入");
    self.firstWrite = YES;
}
/**
 *  输入框结束输入
 */
- (void)endWrite{
    YYLog(@"结束输入");
    if (self.firstWrite) return;
    
    self.textView.text = placeholderStr;
    self.textView.textColor = [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1];
}

#pragma mark 增加取消和下一步按钮
- (void)addCancelBtnAndNextBtn{
    //增加取消按钮
    CGFloat cancelBtnH = 17;
    UIButton *btn = [[UIButton alloc] init];
    btn.width = 60;
    btn.height = cancelBtnH;
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    //增加下一步按钮
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.width = 60;
    nextBtn.height = cancelBtnH;
    [nextBtn setTitleColor:[UIColor colorWithRed:197/255.0 green:100/255.0 blue:208/255.0 alpha:1] forState:UIControlStateNormal];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextBtn];
}
#pragma mark 增加输入框
- (void)addTextViewWithFrame:(CGRect)textViewFrame{
    
    UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame];
    [self.view addSubview:textView];
    self.textView = textView;
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.text = placeholderStr;
    self.textView.textColor = [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1];
    //监听输入框开始输入文字
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginWrite) name:UITextViewTextDidBeginEditingNotification object:nil];
    //监听输入框正在输入文字
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowWrite) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endWrite) name:UITextViewTextDidEndEditingNotification object:nil];
#warning 背景颜色
//    self.textView.backgroundColor = [UIColor yellowColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textView.returnKeyType = UIReturnKeyDone;
    //添加遮盖层
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
}
/**
 *  键盘弹出添加遮盖层
 */
- (void)keyboardWillShow{
    [self.view addSubview:self.coverBtn];
}
/**
 *  取消按钮被点击
 */
- (void)cancelBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  下一步按钮被点击
 */
- (void)nextBtnClick{
    YYLog(@"下一步按钮被点击");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma maek 增加底部的View
- (void)addBottomViewWithHeight:(CGFloat)viewHeight{
    CGFloat viewY = YYHeightScreen - viewHeight;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, viewY, YYWidthScreen, viewHeight)];
    [self.view addSubview:bottomView];
    //增加线
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, 0, YYWidthScreen, 0.5) andView:bottomView];
    
    // 增加拍照按钮
    CGFloat cameraBtnH = 35;
    CGFloat cameraBtnY = (viewHeight - cameraBtnH)/2.0;
    UIButton *cameraBtn = [[UIButton alloc] initWithFrame:CGRectMake(YY18WidthMargin, cameraBtnY, cameraBtnH, cameraBtnH)];
    [bottomView addSubview:cameraBtn];
    [cameraBtn setImage:[UIImage imageNamed:@"home_question_6"] forState:UIControlStateNormal];
    [cameraBtn addTarget:self action:@selector(cameraBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //增加金币按钮
    CGFloat coinBtnX = YYWidthScreen - YY18WidthMargin - cameraBtnH;
    UIButton *coinBtn = [[UIButton alloc] initWithFrame:CGRectMake(coinBtnX, cameraBtnY, cameraBtnH, cameraBtnH)];
    [bottomView addSubview:coinBtn];
    [coinBtn setImage:[UIImage imageNamed:@"home_question_7"] forState:UIControlStateNormal];
    [coinBtn addTarget:self action:@selector(coinBtnClick) forControlEvents:UIControlEventTouchUpInside];

    
}
#pragma mark 下面两个按钮被点击
/**
 *  相机按钮被点击
 */
- (void)cameraBtnClick{
    YYLog(@"相机按钮被点击");
}
/**
 *  金币按钮被点击
 */
- (void)coinBtnClick{
    YYLog(@"金币按钮被点击");

}

@end
