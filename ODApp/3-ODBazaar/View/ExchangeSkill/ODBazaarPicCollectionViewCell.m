//
//  ODBazaarPicCollectionViewCell.m
//  ODApp
//
//  Created by Odong-YG on 16/2/20.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBazaarPicCollectionViewCell.h"

@implementation ODBazaarPicCollectionViewCell

- (void)awakeFromNib
{
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.minimumZoomScale = 1;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.picImageView;
}
@end
