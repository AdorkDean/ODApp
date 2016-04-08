//
//  ODInformViewController.m
//  ODApp
//
//  Created by william on 16/4/8.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODInformViewController.h"
#import "ODHttpTool.h"
#import "ODProgressHUD.h"

@implementation ODInformViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"举报";
    [self.sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendButtonClicked:(UIButton *)button {
    
    NSDictionary *params = @{
                             @"type": self.type,
                             @"object_id": self.objectId,
                             @"content":self.contentEditView.text,
                             };
    
    
    __weakSelf
    [ODHttpTool getWithURL:ODUrlOtherInform parameters:params modelClass:[NSObject class] success:^(id model) {
        [ODProgressHUD showInfoWithStatus:@"举报成功，我们将立即处理"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
    }];

}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end