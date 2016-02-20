//
//  ODDrawbackBuyerController.m
//  ODApp
//
//  Created by 代征钏 on 16/2/20.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODDrawbackBuyerController.h"


NSString * const ODDrawbackBuyerCELL = @"ODDrawbackBuyerCELL";
@interface ODDrawbackBuyerController ()

@end

@implementation ODDrawbackBuyerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"退款";
    [self createScrollView];
}


- (void)createScrollView
{

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight - ODNavigationHeight)];
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    [self.view addSubview:self.scrollView];
    
    float drawBackHeight = 43;
    self.drawbackMoneyLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, 0, KScreenWidth, drawBackHeight) text:[NSString stringWithFormat:@"您的退款金额：%.1f元",0.4] font:13.5 alignment:@"center" color:@"#000000" alpha:1];
    self.drawbackMoneyLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.drawbackMoneyLabel];
    
    self.drawbackReasonLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(self.drawbackMoneyLabel.frame), KScreenWidth, 22) text:@"      退款原因" font:12 alignment:@"left" color:@"#8e8e8e" alpha:1];
    [self.scrollView addSubview:self.drawbackReasonLabel];
    
    float drawBackReasonHeight = 40;
    self.drawbackReasonOneLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(self.drawbackReasonLabel.frame), KScreenWidth, drawBackReasonHeight) text:@"卖家自身原因无法服务" font:13.5 alignment:@"left" color:@"#000000" alpha:1];
    self.drawbackReasonOneLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.drawbackReasonOneLabel];
    
    self.drawbackReasonTwoLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(self.drawbackReasonOneLabel.frame) + 1, KScreenWidth, drawBackReasonHeight) text:@"对服务质量不满意" font:13.5 alignment:@"left" color:@"#000000" alpha:1];
    self.drawbackReasonTwoLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.drawbackReasonTwoLabel];
    
    self.drawbackReasonThreeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(self.drawbackReasonTwoLabel.frame) + 1, KScreenWidth, drawBackReasonHeight) text:@"未按时交付服务" font:13.5 alignment:@"left" color:@"#000000" alpha:1];
    self.drawbackReasonThreeLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.drawbackReasonThreeLabel];
    
    self.drawbackReasonFourLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(self.drawbackReasonThreeLabel.frame) + 1, KScreenWidth, drawBackReasonHeight) text:@"双方已协商好退款" font:13.5 alignment:@"left" color:@"#000000" alpha:1];
    self.drawbackReasonFourLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.drawbackReasonFourLabel];
    
    self.drawbackReasonOtherLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(self.drawbackReasonFourLabel.frame) + 1, KScreenWidth, drawBackReasonHeight) text:@"其它" font:13.5 alignment:@"left" color:@"#000000" alpha:1];
    self.drawbackReasonOtherLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.drawbackReasonOtherLabel];
    
    self.drawbackStateLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(self.drawbackReasonOtherLabel.frame), KScreenWidth, 22) text:@"      退款原因" font:12 alignment:@"left" color:@"#8e8e8e" alpha:1];
    [self.scrollView addSubview:self.drawbackStateLabel];
    
    self.drawbackStateTextField = [ODClassMethod creatTextFieldWithFrame:CGRectMake(0, CGRectGetMaxY(self.drawbackStateLabel.frame), KScreenWidth, 150) placeHolder:@"    请输入适当的退款理由" delegate:self tag:0];
    
    [self.scrollView addSubview:self.drawbackStateTextField];
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}









@end
