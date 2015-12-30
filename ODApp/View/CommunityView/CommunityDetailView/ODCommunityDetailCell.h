//
//  ODCommunityDetailCell.h
//  ODApp
//
//  Created by Odong-YG on 15/12/30.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODCommunityDetailModel.h"

@interface ODCommunityDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

- (IBAction)headButton:(UIButton *)sender;
- (IBAction)replyButton:(UIButton *)sender;
- (IBAction)deleteButton:(UIButton *)sender;

-(void)showDataWithModel:(ODCommunityDetailModel *)model;

@end
