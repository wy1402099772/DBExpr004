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
#import "UIView+Toast.h"
#import "PrintTableViewCell.h"

static NSString *identifer = @"identifer";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, DetailViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *modelArray;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *queryButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resetAction:nil];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.056 green:0.997 blue:0.915 alpha:0.800];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 100) style:UITableViewStylePlain];
    [self.tableView registerClass:[PrintTableViewCell class] forCellReuseIdentifier:identifer];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.cornerRadius = 20.0f;
    self.tableView.layer.borderColor = [UIColor colorWithRed:0.365 green:1.000 blue:0.925 alpha:1.000].CGColor;
    self.tableView.layer.borderWidth = 1.0f;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.073 green:0.744 blue:1.000 alpha:1.000];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view).offset(15);
        make.bottom.equalTo(self.view).offset(-90);
        make.left.equalTo(self.view).offset(5);
        make.right.equalTo(self.view).offset(-5);
    }];
    
    self.resetButton = [[UIButton alloc] init];
    [self.resetButton setImage:[UIImage imageNamed:@"image_refresh"] forState:UIControlStateNormal];
    [self.resetButton addTarget:self action:@selector(resetAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.resetButton.layer.masksToBounds = YES;
    self.resetButton.layer.cornerRadius = 10.0f;
    self.resetButton.layer.borderColor = [UIColor purpleColor].CGColor;
    self.resetButton.layer.borderWidth = 5.0f;
    [self.view addSubview:self.resetButton];
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view).offset(30);
        make.bottom.equalTo(self.view).offset(-20);
//        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    
    self.addButton = [[UIButton alloc] init];
    [self.addButton setImage:[UIImage imageNamed:@"image_add"] forState:UIControlStateNormal];
    [self.addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addButton];
    self.addButton.layer.masksToBounds = YES;
    self.addButton.layer.cornerRadius = 10.0f;
    self.addButton.layer.borderColor = [UIColor purpleColor].CGColor;
    self.addButton.layer.borderWidth = 5.0f;
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.view).offset(-30);
        make.bottom.equalTo(self.view).offset(-20);
        make.width.equalTo(self.resetButton);
        make.height.mas_equalTo(50);
    }];
    
    self.queryButton = [[UIButton alloc] init];
    [self.queryButton setImage:[UIImage imageNamed:@"image_find"] forState:UIControlStateNormal];
    [self.queryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.queryButton addTarget:self action:@selector(queryAction:) forControlEvents:UIControlEventTouchUpInside];
    self.queryButton.layer.masksToBounds = YES;
    self.queryButton.layer.cornerRadius = 10.0f;
    self.queryButton.layer.borderColor = [UIColor purpleColor].CGColor;
    self.queryButton.layer.borderWidth = 5.0f;
    [self.view addSubview:self.queryButton];
    [self.queryButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.addButton.mas_left).offset(-15);
        make.left.equalTo(self.resetButton.mas_right).offset(15);
        make.bottom.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(50);
        make.width.equalTo(self.resetButton);
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
    controller.delegate = self;
    [self presentViewController:controller animated:NO completion:nil];
}

- (void)queryAction:(UIButton *)sender
{
    DetailViewController *controller = [[DetailViewController alloc] initWithModel:[[PrintModel alloc] init] type:DetailTypeQuery];
    controller.delegate = self;
    [self presentViewController:controller animated:NO completion:nil];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *controller = [[DetailViewController alloc] initWithModel:(PrintModel *)self.modelArray[indexPath.row] type:DetailTypeEdit];
    controller.delegate = self;
    [self presentViewController:controller animated:NO completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 180;
    return 90;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *likeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        DetailViewController *controller = [[DetailViewController alloc] initWithModel:(PrintModel *)self.modelArray[indexPath.row] type:DetailTypeEdit];
        controller.delegate = self;
        [self presentViewController:controller animated:NO completion:nil];
    }];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {

        PrintTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        PrintModel *model = cell.model;
        NSMutableArray *muta = [NSMutableArray arrayWithArray:self.modelArray];
        [muta removeObject:model];
        self.modelArray = [muta copy];
        FMDatabase *db = [DBManager sharedInstance].db;
        BOOL result =  [db executeUpdate:@"delete from print where title = ?;", cell.model.title];
        if(!result)
        {
            [self.view makeToast:@"删除操作出现了一些错误，操作失败" duration:2.0f position:CSToastPositionCenter];
        }
        else
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    }];
    
    return @[deleteAction, likeAction];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrintTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifer];
    PrintModel *model = (PrintModel *)self.modelArray[indexPath.row];
    [cell loadModel:model];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - DetailViewController
- (void)successDeal:(DetailType)detailType
{
    if(detailType == DetailTypeAdd || detailType == DetailTypeEdit)
    {
        [self resetAction:nil];
    }
}

- (void)successQuery:(FMResultSet *)resultSet
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    while ([resultSet next]) {
        PrintModel *model = [[PrintModel alloc] initWithResultSet:resultSet];
        [tmpArray addObject:model];
    }
    self.modelArray = [tmpArray copy];
    [self.tableView reloadData];
}

@end
