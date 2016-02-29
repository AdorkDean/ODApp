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
    self.headButton.layer.borderColor = [UIColor clearColor].CGColor;
    self.headButton.layer.borderWidth = 1;
    self.nickLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    self.signLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
}


-(void)showDateWithModel:(ODCommunityModel *)model
{
    self.timeLabel.text = model.created_at;
    self.contentLabel.text = model.content;
}



@end
