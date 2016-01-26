//
//  ActivityDetailView.m
//  ODApp
//
//  Created by zhz on 15/12/29.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ActivityDetailView.h"

@implementation ActivityDetailView

+(instancetype)getView
{
    ActivityDetailView *view =  [[[NSBundle mainBundle] loadNibNamed:@"ActivityDetailView" owner:nil options:nil] firstObject];
    
    
   view.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    
    if (iPhone4_4S) {
       view.imageHight.constant = 200;
    }else if (iPhone5_5s)
    {
        view.imageHight.constant = 200;
    }else if (iPhone6_6s)
    {
       view.imageHight.constant = 250;
    }else {
        view.imageHight.constant = 270;
    }
    
   view.frame = CGRectMake(0, 0, kScreenSize.width, 250 + view.imageHight.constant);

    
    view.informationLabel.layer.masksToBounds = YES;
    view.informationLabel.layer.cornerRadius = 5;
    view.informationLabel.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    view.informationLabel.layer.borderWidth = 1;
    view.informationLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    
    
    
    view.baoMingButton.layer.masksToBounds = YES;
    view.baoMingButton.layer.cornerRadius = 5;
    view.baoMingButton.layer.borderColor = [UIColor blackColor].CGColor;
    view.baoMingButton.layer.borderWidth = 1;

    view.disitionLabel.layer.masksToBounds = YES;
    view.disitionLabel.layer.cornerRadius = 5;
    view.disitionLabel.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    view.disitionLabel.layer.borderWidth = 1;
    view.disitionLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    
    
    view.titleLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    view.beginTimeLabel.textColor = [UIColor colorWithHexString:@"#8f8f8f" alpha:1];
    view.endTimeLabel.textColor = [UIColor colorWithHexString:@"#8f8f8f" alpha:1];
    view.addressLabel.textColor = [UIColor colorWithHexString:@"#015afe" alpha:1];

    
    [view.centerNameButton setTitleColor:[UIColor colorWithHexString:@"#015afe" alpha:1] forState:UIControlStateNormal];

    if (iPhone4_4S) {
       view.beginTimeLabel.font = [UIFont systemFontOfSize:13];
        view.endTimeLabel.font = [UIFont systemFontOfSize:13];
        
        
    }else if (iPhone5_5s) {
        
       view.beginTimeLabel.font = [UIFont systemFontOfSize:13];
       view.endTimeLabel.font = [UIFont systemFontOfSize:13];
    }else if (iPhone6_6s){
        view.beginTimeLabel.font = [UIFont systemFontOfSize:16];
       view.endTimeLabel.font = [UIFont systemFontOfSize:16];
    }else {
        
       view.beginTimeLabel.font = [UIFont systemFontOfSize:16];
       view.endTimeLabel.font = [UIFont systemFontOfSize:16];
        
    }

    
    
    return view;
    
    
    
}

@end
