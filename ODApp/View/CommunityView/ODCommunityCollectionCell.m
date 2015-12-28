//
//  ODCommunityCollectionCell.m
//  ODApp
//
//  Created by Odong-YG on 15/12/25.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODCommunityCollectionCell.h"

@implementation ODCommunityCollectionCell

- (void)awakeFromNib {
    
    self.headButton.layer.masksToBounds = YES;
    self.headButton.layer.cornerRadius = 24;
    self.titleLabel.textColor = [ODColorConversion colorWithHexString:@"#484848" alpha:1];
    self.contentLabel.textColor = [ODColorConversion colorWithHexString:@"#8e8e8e" alpha:1];
    self.nameLabel.textColor = [ODColorConversion colorWithHexString:@"#000000" alpha:1];
}

- (IBAction)headButton:(UIButton *)sender {
}

-(void)showDateWithModel:(ODCommunityModel *)model
{
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    self.countLabel.text = [NSString stringWithFormat:@"浏览次数 %@",model.view_num];
}
@end
