//
//  YYMyAnswerTableViewController.m
//  pugongying
//
//  Created by wyy on 16/3/1.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYMyAnswerTableViewController.h"
#import "YYQuestionStateCell.h"
#import "YYQuestionStateCellFrame.h"
#import "YYQuestionStateModel.h"

@interface YYMyAnswerTableViewController ()
/**
 *  问题的数组
 */
@property (nonatomic, strong) NSMutableArray *questionArray;
@end

@implementation YYMyAnswerTableViewController
- (NSMutableArray *)questionArray{
    if (!_questionArray) {
        YYQuestionStateModel *model = [[YYQuestionStateModel alloc] init];
        model.userName = @"东海龙三太子";
        model.contentText = @"东海龙三太子东海龙三太子东海龙三太子东海龙三太子东海龙三太子东海龙三太子东海龙三太子东海龙三太子";
        model.rewardNumber = @"100";
        model.markText = @"开店  淘宝运营";
        model.dateText = @"1天前";
        model.answerNumber = @"1111";
        model.state = YYQuestionStateFinshed;
        YYQuestionStateCellFrame *cellFrame = [[YYQuestionStateCellFrame alloc] init];
        cellFrame.model = model;
        
        
        YYQuestionStateModel *model1 = [[YYQuestionStateModel alloc] init];
        model1.userName = @"东海龙三太子";
        model1.contentText = @"QQ邮箱,为亿万用户提供高效稳定便捷的电子邮件服务。你可以在电脑网页、iOS/iPad客户端、及Android客户端上使用它,通过邮件发送3G的超大附件,体验文件中转站、日历、户端上使用它,通过邮件发送3G的超";
        model1.rewardNumber = @"100";
        model1.markText = @"开店  淘宝运营";
        model1.dateText = @"1天前";
        model1.answerNumber = @"1111";
        model1.state = YYQuestionStateProgress;
        YYQuestionStateCellFrame *cellFrame1 = [[YYQuestionStateCellFrame alloc] init];
        cellFrame1.model = model1;
        
        YYQuestionStateModel *model2 = [[YYQuestionStateModel alloc] init];
        model2.userName = @"东海龙三太子";
        model2.contentText = @"QQ邮箱,为亿万用户提供高效稳定便捷的电子邮件服务。你可以在电脑网页、iOS/iPad客户端、及Android客户端上使用它,通过邮件发送3G的超大附件,体验文件中转站、日历、户端上使用它,通过邮件发送3G的超";
        model2.rewardNumber = @"100";
        model2.markText = @"开店  淘宝运营";
        model2.dateText = @"1天前";
        model2.answerNumber = @"1111";
        model2.state = YYQuestionStateDisable;
        YYQuestionStateCellFrame *cellFrame2 = [[YYQuestionStateCellFrame alloc] init];
        cellFrame2.model = model2;
        _questionArray = [NSMutableArray array];
        [_questionArray addObject:cellFrame];
        [_questionArray addObject:cellFrame1];
        [_questionArray addObject:cellFrame2];
    }
    return _questionArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的回答";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.questionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYQuestionStateCell *cell = [YYQuestionStateCell questionCellWithTableView:tableView];
    
    YYQuestionStateCellFrame *cellFrame = self.questionArray[indexPath.section];
    
    cell.questionCellFrame = cellFrame;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}
#pragma mark UITableView的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYQuestionStateCellFrame *cellFrame = self.questionArray[indexPath.section];
    return cellFrame.cellRowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
/**
 *  删除单元格
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        YYQuestionStateCellFrame *cellFrame = self.questionArray[indexPath.row];
        [self.questionArray removeObject:cellFrame];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
