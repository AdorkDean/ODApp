//
//  ODAddressCell.m
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODAddressCell.h"

@implementation ODAddressCell

- (void)awakeFromNib {
    // Initialization code
    
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.contentView.userInteractionEnabled = YES;
 
    self.lineonstraint.constant = 0.5;
}


- (void)setModel:(ODOrderAddressDefModel *)model
{
    _model = model;
    self.nameLabel.text = model.name;
    self.phoneLabel.text = model.tel;

    if ([self.isDefault isEqualToString:@"1"]) {
        
        NSString *str = [NSString stringWithFormat:@"[默认]%@",model.address];
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:str];
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff6666" alpha:1] range:NSMakeRange(0, 4)];
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#000000" alpha:1] range:NSMakeRange(4, model.address.length)];
        self.addressLabel.attributedText = noteStr;

    }else{
        
        self.addressLabel.text = model.address;
    }
    
    
    
}




@end
