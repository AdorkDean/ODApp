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
@interface ODContactAddressController ()<UITableViewDataSource , UITableViewDelegate>


@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) AFHTTPRequestOperationManager *deleteManager;
@property (nonatomic , copy) NSString *open_id;
@property (nonatomic , strong) NSMutableArray *defaultArray;
@property (nonatomic , strong) NSMutableArray *dataArray;






@end

@implementation ODContactAddressController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"联系地址";
    self.dataArray = [[NSMutableArray alloc] init];
    self.defaultArray = [[NSMutableArray alloc] init];
    
    self.open_id = [ODUserInformation sharedODUserInformation].openID;
    [self getData];
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
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 , kScreenSize.width, kScreenSize.height - 64 - 50) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ODAddressCell" bundle:nil] forCellReuseIdentifier:@"item"];
    
    [self.view addSubview:self.tableView];
    
    UIImageView *addAddressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenSize.height - 50, kScreenSize.width, 50)];
    
    addAddressImageView.backgroundColor = [UIColor whiteColor];
    addAddressImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *addAddressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addAddressAction)];
    [addAddressImageView addGestureRecognizer:addAddressTap];
    UIImageView *add = [[UIImageView alloc] initWithFrame:CGRectMake(addAddressImageView.center.x - 60, 12, 20, 20)];
    add.image = [UIImage imageNamed:@"发布任务icon"];
    [addAddressImageView addSubview:add];
    
    UIButton *addAddressButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addAddressButton.frame = CGRectMake(addAddressImageView.center.x - 40, 12, 100, 20);
    [addAddressButton setTitle:@"新增收货地址" forState:UIControlStateNormal];
    [addAddressButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    addAddressButton.titleLabel.font = [UIFont systemFontOfSize: 15];
    addAddressButton.userInteractionEnabled = NO;
  
    
    [addAddressImageView addSubview:addAddressButton];
    
    [self.view addSubview:addAddressImageView];

    
}

- (void)addAddressAction
{
    ODAddAddressController *vc = [[ODAddAddressController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"item" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        [cell.lineLabel removeFromSuperview];
        
        ODAddressModel *model = self.defaultArray[0];
        cell.nameLabel.text = model.name;
        cell.phoneLabel.text = model.tel;
        
        NSString *str = [NSString stringWithFormat:@"[默认]%@",model.address];
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:str];
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff6666" alpha:1] range:NSMakeRange(0, 4)];
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#000000" alpha:1] range:NSMakeRange(4, model.address.length)];
        cell.addressLabel.attributedText = noteStr;

        
        
    }
    
    if (indexPath.section == 1) {
        
        
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
        return 1;
    }else{
        return self.dataArray.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return 20;
    }else {
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


- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        return NO;
    }else{
        return YES;
    }
}

#pragma mark 在滑动手势删除某一行的时候，显示出更多的按钮
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
 
{
    
    // 添加一个删除按钮
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        
        NSString *address_id = @"";
        
        
        if (indexPath.section == 0) {
            
            ODAddressModel *model = self.defaultArray[0];
            address_id = [NSString stringWithFormat:@"%@" , model.id];
            
            
              [self.defaultArray  removeObjectAtIndex:indexPath.row];
            
        }else{
            
            ODAddressModel *model = self.dataArray[indexPath.row];
            address_id = [NSString stringWithFormat:@"%@" , model.id];
            [self.dataArray removeObjectAtIndex:indexPath.row];
            
        }
        
        
       [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        [self deleteAddressWithAddress_id:address_id];
        
  
        
    }];
    
    
 
    UITableViewRowAction *editeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"点击了置顶");
        
    }];
    
    editeAction.backgroundColor = [UIColor blueColor];
  
    
    
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction, editeAction];
    
    
    
}

- (void)deleteAddressWithAddress_id:(NSString *)address_id
{
    self.deleteManager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"user_address_id":address_id ,@"open_id":self.open_id};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    __weak typeof (self)weakSelf = self;
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
