//
//  SHViewController.m
//  ScrollLayout
//
//  Created by CSH on 2018/9/7.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHViewController.h"
#import "SHTableView.h"

@interface SHViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 50 + arc4random()%10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld--%ld",(long)self.view.tag,(long)indexPath.row];
    return cell;
}

#pragma mark - 主要方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
     //处理内容滑动
    if ([scrollView isEqual:self.tableView]) {
        [self.mainTableView handleChildScrollWithScroll:self.tableView];
    }
}

@end
