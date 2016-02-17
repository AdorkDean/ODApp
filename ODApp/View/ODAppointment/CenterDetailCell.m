//
//  CenterDetailCell.m
//  ODApp
//
//  Created by zhz on 15/12/28.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "CenterDetailCell.h"
#import "UIImageView+WebCache.h"
@implementation CenterDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (iPhone4_4S) {
            self.toRightSpace.constant = 210;
        }else if (iPhone5_5s){
            self.toRightSpace.constant = 210;
        }else if (iPhone6_6s){
            self.toRightSpace.constant = 260;
        }else{
            self.toRightSpace.constant = 300;
            
        }
        
        self.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];

        
        self.coverImageView.layer.masksToBounds = YES;
        self.coverImageView.layer.cornerRadius = 7;
        self.coverImageView.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
        self.coverImageView.layer.borderWidth = 1;
        
        self.timeLabel.textColor = [UIColor colorWithHexString:@"#b1b1b1" alpha:1];
        self.addressLabel.textColor = [UIColor colorWithHexString:@"#b1b1b1" alpha:1];
        
    }
    return self;
}


- (void)setModel:(CenterActivityModel *)model
{
    if (_model != model) {
       
        _model = model;
    }
   
    self.titleLabel.text = model.content;
    self.timeLabel.text = model.date_str;
    self.addressLabel.text = model.address;
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:model.icon_url]];

    
    
    
}




@end
