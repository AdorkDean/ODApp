//
//  ODContactAddressController.m
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODContactAddressController.h"
#import "ODAddressCell.h"
#import "ODAddAddressController.h"
#import "ODOrderAddressModel.h"
#import "UITableViewRowAction+JZExtension.h"

@interface ODContactAddressController () <UITableViewDataSource, UITableViewDelegate>


@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, copy) NSString *open_id;
@property(nonatomic, strong) NSMutableArray *defaultArray;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, copy) NSString *tableViewReuseIdentifier;

@property(nonatomic, copy) NSString *isAddress;


@end

@implementation ODContactAddressController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.dataArray = [[NSMutableArray alloc] init];
    self.defaultArray = [[NSMutableArray alloc] init];
    self.tableViewReuseIdentifier = NSStringFromClass([UITableViewCell class]);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.open_id = [ODUserInformation sharedODUserInformation].openID;
    [self navigationInit];
    [self getData];


}

- (void)navigationInit {
    self.view.userInteractionEnabled = YES;
    self.navigationItem.title = @"联系地址";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(backAction:) color:nil highColor:nil title:@"返回"];
}

- (void)backAction:(UIButton *)sender {
    if ([self.isAddress isEqualToString:@"1"]) {
        if (self.getAddressBlock) {
            self.getAddressBlock(@"", @"", @"1");
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}


- (void)getData {
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"open_id"] = self.open_id;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlUserAddressList parameters:params modelClass:[ODOrderAddressModel class] success:^(id model)
     {
         [weakSelf.defaultArray removeAllObjects];
         [weakSelf.dataArray removeAllObjects];
         
         // 取出模型
         ODOrderAddressModel *addressModel = [model result];
         // 取出def模型
         ODOrderAddressDefModel *defModel = addressModel.def;
         if (defModel) {
             [weakSelf.defaultArray addObject:defModel];
         }

         [weakSelf.dataArray addObjectsFromArray:addressModel.list];
         
         [weakSelf createTableView];
         [weakSelf.tableView reloadData];
         
     } failure:^(NSError *error) {
     }];
}

- (void)createTableView {


    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, kScreenSize.height - 110) style:UITableViewStylePlain];
    self.tableView.userInteractionEnabled = YES;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ODAddressCell" bundle:nil] forCellReuseIdentifier:@"item"];

    [self.view addSubview:self.tableView];

    UIImageView *addAddressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenSize.height - 50 - ODNavigationHeight, kScreenSize.width, 50)];

    addAddressImageView.image = [UIImage imageNamed:@"button_Add address"];
    addAddressImageView.backgroundColor = [UIColor whiteColor];
    addAddressImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *addAddressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addAddressAction)];
    [addAddressImageView addGestureRecognizer:addAddressTap];
    [self.view addSubview:addAddressImageView];


}

- (void)addAddressAction {
    ODAddAddressController *vc = [[ODAddAddressController alloc] init];
    vc.typeTitle = @"新增地址";
    vc.isAdd = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ODAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"item" forIndexPath:indexPath];


    if (indexPath.section == 0) {
        [cell.lineLabel removeFromSuperview];

        if (self.defaultArray.count == 0) {;
        } else {
            ODOrderAddressDefModel *model = self.defaultArray[0];
            cell.isDefault = @"1";
            cell.model = model;
        }


    }

    if (indexPath.section == 1) {

        if (indexPath.row == self.dataArray.count - 1) {
            [cell.lineLabel removeFromSuperview];
        }
        ODOrderAddressDefModel *model = self.dataArray[indexPath.row];
        cell.isDefault = @"2";
        cell.model = model;


    }


    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.defaultArray.count == 0) {
            return 0;
        } else {
            return 1;
        }
    } else {
        return self.dataArray.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    if (section == 0) {
        if (self.defaultArray.count == 0) {
            return 0;

        } else {
            return 13;

        }
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 0)];
        view.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
        view.userInteractionEnabled = YES;
        return view;

    } else {
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        view.backgroundColor = [UIColor clearColor];
        view.userInteractionEnabled = YES;
        return view;
    }


}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weakSelf
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"icon_shanchu"] handler:^(UITableViewRowAction *_Nullable action, NSIndexPath *_Nullable indexPath) {
        [weakSelf setEditing:false animated:true];

        NSString *address_id = @"";
        if (indexPath.section == 0) {

            ODOrderAddressDefModel *model = self.defaultArray[indexPath.row];
            address_id = [NSString stringWithFormat:@"%@", model.id];
            [weakSelf.defaultArray removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView reloadData];

        } else {

            ODOrderAddressDefModel *model = self.dataArray[indexPath.row];
            address_id = [NSString stringWithFormat:@"%@", model.id];
            [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];


        }


        [weakSelf deleteAddressWithAddress_id:address_id];


    }];
    action1.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];


    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"icon_bianji"] handler:^(UITableViewRowAction *_Nullable action, NSIndexPath *_Nullable indexPath) {
        [weakSelf setEditing:false animated:true];

        ODAddAddressController *vc = [[ODAddAddressController alloc] init];
        vc.typeTitle = @"编辑地址";
        vc.isAdd = NO;
        if (indexPath.section == 0) {
            ODOrderAddressDefModel *model = self.defaultArray[indexPath.row];
            vc.isDefault = YES;
            NSString *addressId = [NSString stringWithFormat:@"%@", model.id];
            vc.addressId = addressId;
            vc.addressModel = model;
            [weakSelf.navigationController pushViewController:vc animated:YES];


        } else {

            ODOrderAddressDefModel *model = self.dataArray[indexPath.row];
            NSString *addressId = [NSString stringWithFormat:@"%@", model.id];
            vc.isDefault = NO;
            vc.addressId = addressId;
            vc.addressModel = model;
            [weakSelf.navigationController pushViewController:vc animated:YES];

        }


    }];
    action2.backgroundColor = [UIColor colorWithHexString:@"#ffd802" alpha:1];

    return @[action1, action2];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ODOrderAddressDefModel *model = self.defaultArray[indexPath.row];
        if (self.getAddressBlock) {
            self.getAddressBlock(model.address, [NSString stringWithFormat:@"%@", model.id], @"2");
        }
    } 
    else {
        ODOrderAddressDefModel *model = self.dataArray[indexPath.row];
        if (self.getAddressBlock) {
            self.getAddressBlock(model.address, [NSString stringWithFormat:@"%@", model.id], @"2");
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)deleteAddressWithAddress_id:(NSString *)address_id {
    NSDictionary *parameters = @{@"user_address_id" : address_id, @"open_id" : self.open_id};
    __weakSelf
    [ODHttpTool getWithURL:ODUrlUserAddressDel parameters:parameters modelClass:[NSObject class] success:^(id model) {
        if ([self.addressId isEqualToString:address_id]) {
            weakSelf.isAddress = @"1";
        } else {
            weakSelf.isAddress = @"2";
        }
        
        [weakSelf getData];
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
    
    
//    [self.deleteManager GET:kDeleteAddressUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//        __weakSelf
//        if ([responseObject[@"status"] isEqualToString:@"success"]) {
//
//            if ([self.addressId isEqualToString:address_id]) {
//                weakSelf.isAddress = @"1";
//            } else {
//                weakSelf.isAddress = @"2";
//            }
//
//            [weakSelf getData];
//
//
//        } else if ([responseObject[@"status"] isEqualToString:@"error"]) {
//
//
//            [ODProgressHUD showInfoWithStatus:responseObject[@"message"]];
//        }
//
//
//    }               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//
//    }];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

@end
