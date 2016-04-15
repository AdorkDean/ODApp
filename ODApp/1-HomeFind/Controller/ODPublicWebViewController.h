//
//  ODPublicWebViewController.h
//  ODApp
//
//  Created by 刘培壮 on 16/3/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"

@interface ODPublicWebViewController : ODBaseViewController

/** 导航栏标题 */
@property (nonatomic,copy) NSString *navigationTitle;

/** 网页链接地址 */
@property (nonatomic,copy) NSString *webUrl;

/** 是否显示进度条 默认为NO */
@property (nonatomic,assign) BOOL isShowProgress;

/** 网页视图 */
@property (nonatomic,strong) UIWebView *webView;

/** 背景色 */
@property (nonatomic,strong) UIColor *bgColor;

@end
