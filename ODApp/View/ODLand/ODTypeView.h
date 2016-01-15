//
//  ODTypeView.h
//  ODApp
//
//  Created by zhz on 16/1/12.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODTypeView : UIView

+(instancetype)getView;



@property (weak, nonatomic) IBOutlet UIImageView *allTaskImageView;
@property (weak, nonatomic) IBOutlet UIImageView *watingTaskImageView;
@property (weak, nonatomic) IBOutlet UIImageView *waitingCompleteImageView;
@property (weak, nonatomic) IBOutlet UIImageView *completeTaskImageView;
@property (weak, nonatomic) IBOutlet UIImageView *overdueTaskImageView;
@property (weak, nonatomic) IBOutlet UIImageView *violationsTaskImageView;


@end
