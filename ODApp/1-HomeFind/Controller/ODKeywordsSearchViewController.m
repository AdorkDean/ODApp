//
//  ODKeywordsSearchViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/4/5.
//  Copyright © 2016年 Odong Org. All rights reserved.
//
#import "IQKeyboardManager.h"
#import "ODKeywordsSearchViewController.h"
#import "ODAddressKeywordCell.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "ODAddNewAddressViewController.h"

static NSString *cellId = @"ODAddressKeywordCell";

@interface ODKeywordsSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate>

@property (nonatomic ,strong) UITextField *textField;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) AMapSearchAPI * mapSearchAPI;


@end

@implementation ODKeywordsSearchViewController
#pragma lazyload
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"ODAddressKeywordCell" bundle:nil] forCellReuseIdentifier:cellId];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navigationInit];
    self.mapSearchAPI = [[AMapSearchAPI alloc] init];
    self.mapSearchAPI.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager]setEnable:NO];
    [self.textField becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.textField resignFirstResponder];
}
#pragma mark - 初始胡导航
-(void)navigationInit{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width-100, 30)];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 20, 20)];
    imageView.image = [UIImage imageNamed:@"icon_search"];
    [view addSubview:imageView];
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+15, 0, view.frame.size.width-50, 30)];
    self.textField.placeholder = @"请输入你的地址";
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [view addSubview:self.textField];
    self.navigationItem.titleView = view;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLogFunc
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ODAddressKeywordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell showDataWithAMapPOI:self.dataArray[indexPath.row] index:indexPath];
    return cell;
}

#pragma mark - UITabeleDelegate
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    AMapPOI *poi = self.dataArray [indexPath.row];
    
    NSDictionary *dict = @{@"name":poi.name,@"address":poi.address,@"location":poi.location};
    [[NSNotificationCenter defaultCenter]postNotificationName:ODNotificationAddAddress object:self userInfo:dict];
    //    if (self.myBlock) {
    //        self.myBlock(poi.name,poi.address,poi.location);
    //    }
    //
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([NSStringFromClass([vc class]) isEqualToString:NSStringFromClass([ODAddNewAddressViewController class])]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


- (void)onPOISearchDone:(AMapPOIKeywordsSearchRequest *)request response:(AMapPOISearchResponse *)response {
    [self.dataArray removeAllObjects];
    if (response.pois.count == 0) {
        return;
    }
    for (AMapPOI *poi in response.pois) {
        [self.dataArray addObject:poi];
    }
    [self.tableView reloadData];
}


-(void)textFieldDidChange:(UITextField *)textField{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = textField.text;
    request.sortrule = 0;
    request.requireExtension = YES;
    request.city = self.city;
    //发起周边搜索
    [self.mapSearchAPI AMapPOIKeywordsSearch:request];

}





@end
