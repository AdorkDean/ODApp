//
//  ODInformViewController.h
//  ODApp
//
//  Created by william on 16/4/8.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODInformViewController : UIViewController

@property (nonatomic, strong) NSString* objectId;
@property (nonatomic, strong) NSString *type;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextView *contentEditView;


@end
