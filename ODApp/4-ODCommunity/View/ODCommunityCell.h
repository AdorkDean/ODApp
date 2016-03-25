//
//  ODCommunityCell.h
//  ODApp
//
//  Created by Odong-YG on 16/3/24.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ODCommunityBbsModel.h"
#import "ODOthersInformationController.h"

@interface ODCommunityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *picView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picConstraintHeight;

@property(nonatomic,copy)NSString *open_id;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)ODCommunityBbsListModel *model;
-(void)showDataWithModel:(ODCommunityBbsListModel *)model dict:(NSMutableDictionary *)dict index:(NSIndexPath *)index;

@end
