//
//  ODContactAddressController.m
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODContactAddressController.h"
#import "ODAddressCell.h"
#import "ODAddAddressController.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "ODAddressModel.h"
#import "UITableViewRowAction+JZExtension.h"
@interface ODContactAddressController ()<UITableViewDataSource , UITableViewDelegate>


@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) AFHTTPRequestOperationManager *deleteManager;
@property (nonatomic , copy) NSString *open_id;
@property (nonatomic , strong) NSMutableArray *defaultArray;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *tableViewReuseIdentifier;





@end

@implementation ODContactAddressController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"联系地址";
    self.dataArray = [[NSMutableArray alloc] init];
    self.defaultArray = [[NSMutableArray alloc] init];
    self.tableViewReuseIdentifier = NSStringFromClass([UITableViewCell class]);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.open_id = [ODUserInformation sharedODUserInformation].openID;
    self.view.userInteractionEnabled = YES;
    
   
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}

- (void)getData
{
    self.manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"open_id":self.open_id};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:kGetAddressUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            
          
            [self.defaultArray removeAllObjects];
            [self.dataArray removeAllObjects];
            
            
            NSMutableDictionary *dic = responseObject[@"result"];
          
            for (NSMutableDictionary *miniDic in dic) {
                NSString *is_default = [NSString stringWithFormat:@"%@" , miniDic[@"is_default"]];
                
                
                
                
                if ([is_default isEqualToString:@"1"]) {
                    ODAddressModel *model = [[ODAddressModel alloc] init];
                    [model setValuesForKeysWithDictionary:miniDic];
                    [self.defaultArray addObject:model];
                }else{
                    ODAddressModel *model = [[ODAddressModel alloc] init];
                    [model setValuesForKeysWithDictionary:miniDic];
                    [self.dataArray addObject:model];

                }
                
                
                
            }
            
            
        }
        
          [self createTableView];
          [weakSelf.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
        
        
        
        
    }];
    

}

- (void)createTableView
{
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ODTopY , kScreenSize.width, kScreenSize.height - 110) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    
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

- (void)addAddressAction
{
    ODAddAddressController *vc = [[ODAddAddressController alloc] init];
    vc.typeTitle = @"新增地址";
    vc.isAdd = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"item" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        [cell.lineLabel removeFromSuperview];
        
        if (self.defaultArray.count == 0) {
            ;
        }else{
            ODAddressModel *model = self.defaultArray[0];
            cell.nameLabel.text = model.name;
            cell.phoneLabel.text = model.tel;
            
            NSString *str = [NSString stringWithFormat:@"[默认]%@",model.address];
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:str];
            [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff6666" alpha:1] range:NSMakeRange(0, 4)];
            [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#000000" alpha:1] range:NSMakeRange(4, model.address.length)];
            cell.addressLabel.attributedText = noteStr;

        }
     
        
        
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == self.dataArray.count - 1) {
            [cell.lineLabel removeFromSuperview];
        }
        ODAddressModel *model = self.dataArray[indexPath.row];
        cell.nameLabel.text = model.name;
        cell.phoneLabel.text = model.tel;
        cell.addressLabel.text = model.address;
        
       
    }
   
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.defaultArray.count == 0) {
            return 0;
        }else{
            return 1;
        }
    }else{
        return self.dataArray.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section == 0) {
    if (self.defaultArray.count == 0)
    {
        return 0;
        
    }else
    {
       return 20;
        
    }
    }else
    {
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 0)];
        view.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
        return view;

    }else{
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    
 
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weakSelf
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"icon_delete"] handler:^(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath) {
        [weakSelf setEditing:false animated:true];
        
        NSString *address_id = @"";
        if (indexPath.section == 0) {
            
            ODAddressModel *model = self.defaultArray[indexPath.row];
            address_id = [NSString stringWithFormat:@"%@" , model.id];
            [weakSelf.defaultArray  removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView reloadData];
            
        }else{
            
            ODAddressModel *model = self.dataArray[indexPath.row];
            address_id = [NSString stringWithFormat:@"%@" , model.id];
            [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            
            
        }
        
        
        [weakSelf deleteAddressWithAddress_id:address_id];

        

    }];
    action1.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
    
  
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"icon_edit"] handler:^(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath) {
        [weakSelf setEditing:false animated:true];
        
        ODAddAddressController *vc = [[ODAddAddressController alloc] init];
                vc.typeTitle = @"编辑地址";
                vc.isAdd = NO;
                if (indexPath.section == 0) {
                    ODAddressModel *model = self.defaultArray[indexPath.row];
                    vc.isDefault = YES;
                    NSString *addressId = [NSString stringWithFormat:@"%@" , model.id];
                    vc.addressId = addressId;
                    vc.addressModel = model;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
        
        
                }else{
        
                    ODAddressModel *model = self.dataArray[indexPath.row];
                    NSString *addressId = [NSString stringWithFormat:@"%@" , model.id];
                      vc.isDefault = NO;
                    vc.addressId = addressId;
                    vc.addressModel = model;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                    
                }

        
    }];
    action2.backgroundColor = [UIColor colorWithHexString:@"#ffd802" alpha:1];

    return @[action1 , action2];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
         ODAddressModel *model = self.defaultArray[indexPath.row];
        
        __weakSelf
        if (self.getAddressBlock) {
            
       
            
            weakSelf.getAddressBlock(model.address , [NSString stringWithFormat:@"%@" , model.id]);
        }

        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        __weakSelf
        ODAddressModel *model = self.dataArray[indexPath.row];
        if (self.getAddressBlock) {
            weakSelf.getAddressBlock(model.address , [NSString stringWithFormat:@"%@" , model.id]);
        }
        
       [weakSelf.navigationController popViewControllerAnimated:YES];
        
    }
}

- (void)deleteAddressWithAddress_id:(NSString *)address_id
{
    self.deleteManager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"user_address_id":address_id ,@"open_id":self.open_id};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    [self.deleteManager GET:kDeleteAddressUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    [self getData];
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end