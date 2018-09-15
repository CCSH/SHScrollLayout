//
//  SHContentViewController.m
//  ScrollLayout
//
//  Created by CSH on 2018/9/7.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHContentViewController.h"

@interface SHContentViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SHContentViewController

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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 30;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!self.canScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    
    //子 tableview 到顶部了
    if (scrollView.contentOffset.y <= 0) {
        //到顶通知父视图改变状态
        self.canScroll = NO;
        scrollView.contentOffset = CGPointZero;
        [[NSNotificationCenter defaultCenter] postNotificationName:self.topNot object:nil];
    }
}

@end
