//
//  ODEvaluationCell.m
//  ODApp
//
//  Created by zhz on 16/1/18.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODEvaluationCell.h"

@implementation ODEvaluationCell


-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addViews];
    }
    return self;
}


- (void)addViews
{
    self.contentLabel = [[UILabel alloc] init];
    
//     self.contentLabel.frame = CGRectMake(10, 10, self.contentView.frame.size.width - 20, 20);
     self.contentLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
     self.contentLabel.textAlignment = NSTextAlignmentLeft;
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];

}


- (void)setModel:(ODEvaluationModel *)model
{
    if (_model != model) {
        _model = model;
    }
    
    // 根据内容更改label的高度
    CGSize commentSize = [model.comment od_sizeWithFontSize:14.0f
                                                    maxSize:CGSizeMake(KScreenWidth - ODLeftMargin * 2, 0)];
    self.contentLabel.frame = CGRectMake(ODLeftMargin, 0, self.contentView.frame.size.width - ODLeftMargin * 2,
                                         commentSize.height + 30 - 14);
    self.contentLabel.text = [NSString stringWithFormat:@"%@" , model.comment];
}


-(void)dealWithModel:(ODSecondEvaluationModel *)model
{
    if ([model.reason isEqualToString:@""]) {
        
        NSString *reason_num = [NSString stringWithFormat:@"%@" , model.reason_num];
        
        if ([reason_num isEqualToString:@"1"]) {
            
            self.contentLabel.text = @"非常不满意";
            
        }else if ([reason_num isEqualToString:@"2"]) {
            
             self.contentLabel.text = @"不满意";
            
        }else if ([reason_num isEqualToString:@"3"]) {
            
            self.contentLabel.text = @"一般";
            
        }else if ([reason_num isEqualToString:@"4"]) {
            
            self.contentLabel.text = @"满意";
            
        }else if ([reason_num isEqualToString:@"5"]) {
            
            self.contentLabel.text = @"非常满意";
            
        }

        
       
    self.contentLabel.frame = CGRectMake(ODLeftMargin, 0, self.contentView.frame.size.width - ODLeftMargin * 2, 30);
        
        
    }else{
        // 根据内容更改label的高度
        CGSize reasonSize = [model.reason od_sizeWithFontSize:14.0f
                                                      maxSize:CGSizeMake(KScreenWidth - ODLeftMargin * 2, 0)];
        self.contentLabel.frame = CGRectMake(ODLeftMargin, 0, self.contentView.frame.size.width - ODLeftMargin * 2,
                                             reasonSize.height + 30 - 14);
        self.contentLabel.text = model.reason;

    }
    
    
    
   
}



+(CGFloat)returnHight:(ODEvaluationModel *)model
{
    //根据内容计算,更改Label的高度
    if (model.comment) {
        CGSize commentSize = [model.comment od_sizeWithFontSize:14.0f
                                                      maxSize:CGSizeMake(KScreenWidth - ODLeftMargin * 2, 0)];
        return (commentSize.height + 30 - 14);
    }else{
        
        return 30;

    }
    
    
}

+ (CGFloat)returnSecondHight:(ODSecondEvaluationModel *)model
{
    
    
    //根据内容计算,更改Label的高度
    if (![model.reason isEqualToString:@""]) {
        CGSize reasonSize = [model.reason od_sizeWithFontSize:14.0f
                                                        maxSize:CGSizeMake(KScreenWidth - ODLeftMargin * 2, 0)];
        return (reasonSize.height + 30 - 14);
    }else{
        
        return 30;
        
    }

    
    
    
}

@end
