//
//  DetailViewController.m
//  DBExpr4
//
//  Created by 万延 on 16/4/26.
//  Copyright © 2016年 万延. All rights reserved.
//

#import "DetailViewController.h"
#import "Masonry.h"
#import "FMDB.h"
#import "DBManager.h"

@interface DetailViewController ()

@property (nonatomic, strong) PrintModel *model;
@property (nonatomic, assign) DetailType detailType;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *modifyButton;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *titleText;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UITextField *authorText;
@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, strong) UITextField *yearText;
@property (nonatomic, strong) UILabel *organLabel;
@property (nonatomic, strong) UITextField *organText;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UITextField *addressText;
@property (nonatomic, strong) UILabel *pagenumLabel;
@property (nonatomic, strong) UITextField *pagenumText;

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation DetailViewController

- (instancetype)initWithModel:(PrintModel *)model type:(DetailType)type
{
    if(self = [super init])
    {
        _detailType = type;
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureView];
    [self fillData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
    
    [self.bottomView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view).offset(15);
        make.centerY.equalTo(self.bottomView);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(100);
    }];
    
    [self.bottomView addSubview:self.modifyButton];
    [self.modifyButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.view).offset(-15);
        make.centerY.equalTo(self.bottomView);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(100);
    }];
    
    [self.view addSubview:self.leftView];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(15);
        make.bottom.equalTo(self.bottomView.mas_top);
        make.width.equalTo(self.view).multipliedBy(0.4);
    }];
    
    [self.leftView addSubview:self.titleLabel];
    [self.leftView addSubview:self.authorLabel];
    [self.leftView addSubview:self.yearLabel];
    [self.leftView addSubview:self.organLabel];
    [self.leftView addSubview:self.addressLabel];
    [self.leftView addSubview:self.pagenumLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.leftView);
        make.top.equalTo(self.leftView).offset(20);
        make.right.equalTo(self.leftView);
    }];
    
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.leftView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.right.equalTo(self.leftView);
        make.height.equalTo(self.titleLabel);
    }];
    
    [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.leftView);
        make.top.equalTo(self.authorLabel.mas_bottom).offset(20);
        make.right.equalTo(self.leftView);
        make.height.equalTo(self.titleLabel);
    }];
    
    [self.organLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.leftView);
        make.top.equalTo(self.yearLabel.mas_bottom).offset(20);
        make.right.equalTo(self.leftView);
        make.height.equalTo(self.titleLabel);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.leftView);
        make.top.equalTo(self.organLabel.mas_bottom).offset(20);
        make.right.equalTo(self.leftView);
        make.height.equalTo(self.titleLabel);
    }];

    [self.pagenumLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.leftView);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(20);
        make.right.equalTo(self.leftView);
        make.bottom.equalTo(self.leftView.mas_bottom).offset(-20);
        make.height.equalTo(self.titleLabel);
    }];
    
    [self.view addSubview:self.rightView];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.leftView.mas_right);
        make.right.equalTo(self.view);
        make.top.equalTo(self.leftView);
        make.bottom.equalTo(self.leftView);
    }];
    
    [self.rightView addSubview:self.titleText];
    [self.rightView addSubview:self.authorText];
    [self.rightView addSubview:self.yearText];
    [self.rightView addSubview:self.organText];
    [self.rightView addSubview:self.addressText];
    [self.rightView addSubview:self.pagenumText];
    
    [self.titleText mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.titleLabel);
        make.bottom.equalTo(self.titleLabel);
        make.right.equalTo(self.rightView);
        make.left.equalTo(self.rightView);
    }];
    
    [self.authorText mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.authorLabel);
        make.bottom.equalTo(self.authorLabel);
        make.right.equalTo(self.rightView);
        make.left.equalTo(self.rightView);
    }];
    
    [self.yearText mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.yearLabel);
        make.bottom.equalTo(self.yearLabel);
        make.right.equalTo(self.rightView);
        make.left.equalTo(self.rightView);
    }];
    
    [self.organText mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.organLabel);
        make.bottom.equalTo(self.organLabel);
        make.right.equalTo(self.rightView);
        make.left.equalTo(self.rightView);
    }];
    
    [self.addressText mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.addressLabel);
        make.bottom.equalTo(self.addressLabel);
        make.right.equalTo(self.rightView);
        make.left.equalTo(self.rightView);
    }];
    
    [self.pagenumText mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.pagenumLabel);
        make.bottom.equalTo(self.pagenumLabel);
        make.right.equalTo(self.rightView);
        make.left.equalTo(self.rightView);
    }];
    
}

- (void)fillData
{
    if(self.detailType != DetailTypeEdit)
        return ;
    self.titleText.text = self.model.title;
    self.authorText.text = self.model.author;
    self.yearText.text = self.model.year;
    self.organText.text = self.model.organ;
    self.addressText.text = self.model.address;
    self.pagenumText.text = [NSString stringWithFormat:@"%d",(int)self.model.pagenum];
}

#pragma mark - action
- (void)cancelAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)modifyAction:(UIButton *)sender
{
    NSString *title = self.titleText.text;
    NSString *author = self.authorText.text;
    NSString *year = self.yearText.text;;
    NSString *organ = self.organText.text;;
    NSString *address = self.addressText.text;;
    NSInteger pagenum = self.pagenumText.text.intValue;
    FMDatabase *db = [DBManager sharedInstance].db;
    [db executeUpdate:@"insert into print values (?, ?, ?, ?, ?, ?);", title, author, year, organ, address, @(pagenum)];
}

#pragma mark - getter
- (UIButton *)cancelButton
{
    if(!_cancelButton)
    {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        _cancelButton.backgroundColor = [UIColor grayColor];
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)modifyButton
{
    if(!_modifyButton)
    {
        _modifyButton = [[UIButton alloc] init];
        [_modifyButton setTitle:@"修改" forState:UIControlStateNormal];
        _modifyButton.backgroundColor = [UIColor grayColor];
        [_modifyButton addTarget:self action:@selector(modifyAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modifyButton;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"书名：";
        [_titleLabel setFont:[UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:30]];
    }
    return _titleLabel;
}

- (UITextField *)titleText
{
    if(!_titleText)
    {
        _titleText = [[UITextField alloc] init];
    }
    return _titleText;
}


- (UILabel *)authorLabel
{
    if(!_authorLabel)
    {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.text = @"作者：";
        [_authorLabel setFont:[UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:30]];
    }
    return _authorLabel;
}

- (UITextField *)authorText
{
    if(!_authorText)
    {
        _authorText = [[UITextField alloc] init];
    }
    return _authorText;
}

- (UILabel *)yearLabel
{
    if(!_yearLabel)
    {
        _yearLabel = [[UILabel alloc] init];
        _yearLabel.text = @"出版年份：";
        [_yearLabel setFont:[UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:30]];
    }
    return _yearLabel;
}

- (UITextField *)yearText
{
    if(!_yearText)
    {
        _yearText = [[UITextField alloc] init];
    }
    return _yearText;
}


- (UILabel *)organLabel
{
    if(!_organLabel)
    {
        _organLabel = [[UILabel alloc] init];
        _organLabel.text = @"组织：";
        [_organLabel setFont:[UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:30]];
    }
    return _organLabel;
}

- (UITextField *)organText
{
    if(!_organText)
    {
        _organText = [[UITextField alloc] init];
    }
    return _organText;
}

- (UILabel *)addressLabel
{
    if(!_addressLabel)
    {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.text = @"地址：";
        [_addressLabel setFont:[UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:30]];
    }
    return _addressLabel;
}

- (UITextField *)addressText
{
    if(!_addressText)
    {
        _addressText = [[UITextField alloc] init];
    }
    return _addressText;
}


- (UILabel *)pagenumLabel
{
    if(!_pagenumLabel)
    {
        _pagenumLabel = [[UILabel alloc] init];
        _pagenumLabel.text = @"页数：";
        [_pagenumLabel setFont:[UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:30]];
    }
    return _pagenumLabel;
}

- (UITextField *)pagenumText
{
    if(!_pagenumText)
    {
        _pagenumText = [[UITextField alloc] init];
    }
    return _pagenumText;
}

- (UIView *)leftView
{
    if(!_leftView)
    {
        _leftView = [[UIView alloc] init];
    }
    return _leftView;
}

- (UIView *)rightView
{
    if(!_rightView)
    {
        _rightView = [[UIView alloc] init];
    }
    return _rightView;
}

- (UIView *)bottomView
{
    if(!_bottomView)
    {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}


@end
