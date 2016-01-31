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
@interface ODContactAddressController ()<UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , strong) UILabel *centerNameLabe;
@property (nonatomic , strong) UITableView *tableView;

@end

@implementation ODContactAddressController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"联系地址";
    [self createTableView];
}

- (void)createTableView
{
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 , kScreenSize.width, kScreenSize.height - 50) style:UITableViewStylePlain];
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
        return 3;
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

//此方法是UIViewController的编辑方法,让他的根视图上的处于编辑状态
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    
    [super setEditing:editing animated:animated];
    //当Viewcontroller编辑时,让tableView处于可编辑
    [self.tableView setEditing:editing animated:YES];
}

#pragma mark - 编辑(删除,插入)
//设置编辑对象限制;可根据(区号 行号)编辑那些是可编辑,那些不可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}

#pragma mark 在滑动手势删除某一行的时候，显示出更多的按钮
 
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
 
{
    
    // 添加一个删除按钮
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"点击了删除");
        
        
        // 2. 更新UI
        
//        [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }];
    
    
    // 删除一个编辑按钮
    UITableViewRowAction *editeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"点击了置顶");
        
    }];
    
    editeAction.backgroundColor = [UIColor blueColor];
  
    
    
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction, editeAction];
    
    
    
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
