//
//  ODCommunityDetailReplyViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/30.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODCommunityDetailReplyViewController.h"

@interface ODCommunityDetailReplyViewController ()


@end

@implementation ODCommunityDetailReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"回复";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(confirmButtonClick) color:[UIColor colorWithHexString:@"#000000" alpha:1] highColor:nil title:@"确认"];
    [self createRequest];
    [self createTextView];
}


-(void)confirmButtonClick
{
    if (self.textView.text.length>0) {
        [self joiningTogetherParmeters];
    }else{
        [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入回复内容"];
    }
}

#pragma mark - 初始化manager
-(void)createRequest
{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}


#pragma mark - 拼接参数
-(void)joiningTogetherParmeters
{
    NSDictionary *parameter = @{@"bbs_id":self.bbs_id,@"content":self.textView.text,@"parent_id":self.parent_id,@"open_id":[ODUserInformation sharedODUserInformation].openID};
    NSLog(@"+++%@",self.bbs_id);
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self pushDataWithUrl:kCommunityBbsReplyUrl parameter:signParameter];
}

#pragma mark - 提交数据
-(void)pushDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter
{
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        if ([responseObject[@"status"]isEqualToString:@"success"]) {
//
//            NSDictionary *result = responseObject[@"result"];
//            if (weakSelf.myBlock) {
//                weakSelf.myBlock([NSString stringWithFormat:@"refresh"],result);
//            }
//            
//            NSLog(@"--------%@",result);
//            [[NSNotificationCenter defaultCenter]postNotificationName:ODNotificationMyTaskRefresh object:nil];
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//            [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"回复成功"];
//            
//        }
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dict[@"status"]isEqualToString:@"success"]) {
            NSDictionary *result = dict[@"result"];
            ODCommunityDetailModel *model = [[ODCommunityDetailModel alloc]init];
            [model setValuesForKeysWithDictionary:result];
            
            if (weakSelf.myBlock) {
                weakSelf.myBlock([NSString stringWithFormat:@"refresh"],model);
            }
            
            [[NSNotificationCenter defaultCenter]postNotificationName:ODNotificationMyTaskRefresh object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"回复成功"];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}

#pragma mark - 创建textView
-(void)createTextView
{
    self.textView = [ODClassMethod creatTextViewWithFrame:CGRectMake(4, 4 + ODTopY, kScreenSize.width-8, 140) delegate:self tag:0 font:16 color:@"#ffffff" alpha:1 maskToBounds:YES];
    [self.view addSubview:self.textView];
    
    self.label = [ODClassMethod creatLabelWithFrame:CGRectMake(10, 4 + ODTopY, kScreenSize.width-20, 30) text:@"请输入回复TA的内容" font:16 alignment:@"left" color:@"#d0d0d0" alpha:1 maskToBounds:NO];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.userInteractionEnabled = NO;
    [self.view addSubview:self.label];
}

#pragma mark - UITextViewDelegate

NSString *replyTitleText = @"";
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 10){
        textView.text = [textView.text substringToIndex:10];
    }else{
        replyTitleText = textView.text;
    }
    
    if (textView.text.length == 0) {
        self.label.text = @"请输入回复TA的内容";
    }else{
        self.label.text = @"";
    }

}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length) {
        self.label.text = @"";
    }else{
        self.label.text = @"请输入回复TA的内容";
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
