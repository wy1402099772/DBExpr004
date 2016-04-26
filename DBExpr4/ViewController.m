//
//  ViewController.m
//  DBExpr4
//
//  Created by 万延 on 16/4/25.
//  Copyright © 2016年 万延. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"
#import "DBManager.h"
#import "PrintModel.h"
#import "DetailViewController.h"
#import "Masonry.h"

static NSString *identifer = @"identifer";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *modelArray;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) UIButton *addButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resetAction:nil];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 100) style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifer];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view).offset(15);
        make.bottom.equalTo(self.view).offset(-90);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    self.resetButton = [[UIButton alloc] init];
    [self.resetButton setTitle:@"reset" forState:UIControlStateNormal];
    [self.resetButton addTarget:self action:@selector(resetAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.resetButton];
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view).offset(30);
        make.bottom.equalTo(self.view).offset(-20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    
    self.addButton = [[UIButton alloc] init];
    [self.addButton setTitle:@"add" forState:UIControlStateNormal];
    [self.addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.view).offset(-30);
        make.bottom.equalTo(self.view).offset(-20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - action
- (void)resetAction:(UIButton *)sender
{
    FMDatabase *db = [DBManager sharedInstance].db;
    
    FMResultSet *resultSet = [db executeQuery:@"select * from print;"];
    NSMutableArray *tmpArray = [NSMutableArray array];
    while ([resultSet next]) {
        PrintModel *model = [[PrintModel alloc] initWithResultSet:resultSet];
        [tmpArray addObject:model];
    }
    self.modelArray = [tmpArray copy];
    [self.tableView reloadData];
}

- (void)addAction:(UIButton *)sender
{
    DetailViewController *controller = [[DetailViewController alloc] initWithModel:[[PrintModel alloc] init] type:DetailTypeAdd];
    [self presentViewController:controller animated:NO completion:nil];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *controller = [[DetailViewController alloc] initWithModel:(PrintModel *)self.modelArray[indexPath.row] type:DetailTypeEdit];
    [self presentViewController:controller animated:NO completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifer];
    PrintModel *model = (PrintModel *)self.modelArray[indexPath.row];
    cell.textLabel.text = model.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}



@end
