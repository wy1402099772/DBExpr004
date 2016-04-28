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
#import "UIView+Toast.h"

@interface DetailViewController () <UITextFieldDelegate>
{
    BOOL isOr;
    UITextField *activeText;
}

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
@property (nonatomic, strong) UIView *switchView;

@property (nonatomic, strong) UISwitch *titleSwitch;
@property (nonatomic, strong) UISwitch *authorSwitch;
@property (nonatomic, strong) UISwitch *yearSwitch;
@property (nonatomic, strong) UISwitch *organSwitch;
@property (nonatomic, strong) UISwitch *addressSwitch;
@property (nonatomic, strong) UISwitch *pagenumSwitch;

@property (nonatomic, strong) UITextField *minYear;
@property (nonatomic, strong) UITextField *maxYear;
@property (nonatomic, strong) UITextField *minPage;
@property (nonatomic, strong) UITextField *maxPage;

@property (nonatomic, strong) UISwitch *orAndSwitch;
@property (nonatomic, strong) UIView *keyboardView;

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
    [self configureKeyboardNotification];
    [self fillData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)configureView
{
    [self.view setUserInteractionEnabled:YES];
    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:pan];
    
    switch (self.detailType) {
        case DetailTypeNone: {
            self.view.backgroundColor = [UIColor whiteColor];
            break;
        }
        case DetailTypeEdit: {
            self.view.backgroundColor = [UIColor colorWithRed:0.637 green:0.788 blue:1.000 alpha:1.000];
            break;
        }
        case DetailTypeAdd: {
            self.view.backgroundColor = [UIColor colorWithRed:0.056 green:0.997 blue:0.915 alpha:0.800];
            break;
        }
        case DetailTypeQuery: {
            self.view.backgroundColor = [UIColor colorWithRed:0.073 green:0.744 blue:1.000 alpha:1.000];
            break;
        }
    }
    [self.view addSubview:self.keyboardView];
    [self.keyboardView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(0);
    }];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.keyboardView.mas_top);
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
    
    [self.view addSubview:self.switchView];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.leftView);
        make.bottom.equalTo(self.leftView);
        if(self.detailType == DetailTypeQuery)
            make.width.mas_equalTo(50);
        else
            make.width.mas_equalTo(0);
    }];
    
    [self.view addSubview:self.rightView];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.leftView.mas_right);
        make.right.equalTo(self.switchView.mas_left).offset(-5);
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
    
    if(DetailTypeQuery == self.detailType)
    {
        [self.switchView addSubview:self.titleSwitch];
        [self.titleSwitch mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(self.switchView);
            make.centerY.equalTo(self.titleText);
        }];
        
        [self.switchView addSubview:self.authorSwitch];
        [self.authorSwitch mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(self.switchView);
            make.centerY.equalTo(self.authorText);
        }];
        
        [self.switchView addSubview:self.yearSwitch];
        [self.yearSwitch mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(self.switchView);
            make.centerY.equalTo(self.yearText);
        }];

        [self.switchView addSubview:self.organSwitch];
        [self.organSwitch mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(self.switchView);
            make.centerY.equalTo(self.organText);
        }];

        [self.switchView addSubview:self.addressSwitch];
        [self.addressSwitch mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(self.switchView);
            make.centerY.equalTo(self.addressText);
        }];

        [self.switchView addSubview:self.pagenumSwitch];
        [self.pagenumSwitch mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(self.switchView);
            make.centerY.equalTo(self.pagenumText);
        }];
        
        [self.rightView addSubview:self.minYear];
        [self.rightView addSubview:self.maxYear];
        [self.rightView addSubview:self.minPage];
        [self.rightView addSubview:self.maxPage];
        
        [self.minPage mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.pagenumText);
            make.left.equalTo(self.pagenumText);
            make.bottom.equalTo(self.pagenumText);
        }];
        
        [self.maxPage mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.pagenumText);
            make.right.equalTo(self.pagenumText);
            make.bottom.equalTo(self.pagenumText);
            make.width.equalTo(self.minPage);
            make.left.equalTo(self.minPage.mas_right).offset(10);
        }];
        
        [self.minYear mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.yearText);
            make.left.equalTo(self.yearText);
            make.bottom.equalTo(self.yearText);
        }];
        
        [self.maxYear mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.yearText);
            make.right.equalTo(self.yearText);
            make.bottom.equalTo(self.yearText);
            make.width.equalTo(self.minYear);
            make.left.equalTo(self.minYear.mas_right).offset(10);
        }];
        
        self.minYear.hidden = YES;
        self.maxYear.hidden = YES;
        self.minPage.hidden = YES;
        self.maxPage.hidden = YES;
        
        [self.bottomView addSubview:self.orAndSwitch];
        [self.orAndSwitch mas_makeConstraints:^(MASConstraintMaker *make){
            make.center.equalTo(self.bottomView);
        }];
        
    }
    
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
    [self removeNotification];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)modifyAction:(UIButton *)sender
{
    NSString *title = self.titleText.text;
    NSString *author = self.authorText.text;
    NSString *year = self.yearText.text;;
    NSString *organ = self.organText.text;;
    NSString *address = self.addressText.text;;
    NSString *pagenum = self.pagenumText.text;
    if((DetailTypeAdd == self.detailType || DetailTypeEdit == self.detailType) && !title.length && !author.length)
    {
        [self.view makeToast:@"书名与作者不能同时为空" duration:1.0f position:CSToastPositionCenter];
        return;
    }
    FMDatabase *db = [DBManager sharedInstance].db;
    if(DetailTypeAdd == self.detailType)
    {
        BOOL result =  [db executeUpdate:@"insert into print values (?, ?, ?, ?, ?, ?);", title, author, year, organ, address, @(pagenum.intValue)];
        if(result)
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(successDeal:)])
            {
                [self.delegate successDeal:self.detailType];
            }
            [self removeNotification];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else if(DetailTypeEdit == self.detailType)
    {
        if([title isEqualToString:self.model.title] && [author isEqualToString:self.model.author])
        {
            BOOL result =  [db executeUpdate:@"update print set year = ?, organ = ?, address = ?, pagenum = ? where title = ? and author = ?;", year, organ, address, @(pagenum.intValue), title, author];
            if(result)
            {
                [self.delegate successDeal:self.detailType];
                [self removeNotification];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
        else
        {
            [db beginTransaction];
            BOOL result1 = [db executeUpdate:@"delete from print where title = ? and author = ?;", self.model.title, self.model.author];
            BOOL result2 = [db executeUpdate:@"insert into print values (?, ?, ?, ?, ?, ?);", title, author, year, organ, address, @(pagenum.intValue)];
            [db commit];
            
            if(result1 && result2)
            {
                [self.delegate successDeal:self.detailType];
                [self removeNotification];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }
    else if(DetailTypeQuery == self.detailType)
    {
        BOOL start = NO;
        NSMutableString *sql = [NSMutableString stringWithString:@"select * from print "];
        if(title.length > 0)
        {
            if(!start)
            {
                [sql appendString:@"where "];
                start = YES;
            }
            if(self.titleSwitch.isOn)
                [sql appendString:[NSString stringWithFormat:@"title = '%@' ", title]];
            else
                [sql appendString:[NSString stringWithFormat:@"title like '%%%@%%' ", title]];
        }
        if(author.length > 0)
        {
            if(!start)
            {
                [sql appendString:@"where "];
                start = YES;
            }
            else
            {
                if(isOr)
                    [sql appendString:@"or "];
                else
                    [sql appendString:@"and "];
            }
            if(self.authorSwitch.isOn)
                [sql appendString:[NSString stringWithFormat:@"author = '%@' ", author]];
            else
                [sql appendString:[NSString stringWithFormat:@"author like '%%%@%%' ", author]];
            
        }
        if(year.length > 0 && !self.yearSwitch.isOn)
        {
            if(!start)
            {
                [sql appendString:@"where "];
                start = YES;
            }
            else
            {
                if(isOr)
                    [sql appendString:@"or "];
                else
                    [sql appendString:@"and "];
            }
            [sql appendString:[NSString stringWithFormat:@"year = '%@' ", year]];
        }
        else if((self.minYear.text.length + self.maxYear.text.length > 0) && self.yearSwitch.isOn)
        {
            if(!start)
            {
                [sql appendString:@"where "];
                start = YES;
            }
            else
            {
                if(isOr)
                    [sql appendString:@"or "];
                else
                    [sql appendString:@"and "];
            }
            [sql appendString:@"("];
            NSString *tmp1 = [NSString stringWithFormat:@"year >= '%@'", self.minYear.text];
            NSString *tmp2 = [NSString stringWithFormat:@"year <= '%@'", self.maxYear.text];
            NSString *result;
            if(self.minYear.text.length && self.maxYear.text.length)
                result = [NSString stringWithFormat:@"%@ and %@ ", tmp1, tmp2];
            else if(self.minYear.text.length)
                result = tmp1;
            else if(self.maxYear.text.length)
                result = tmp2;
            [sql appendString:[NSString stringWithFormat:@"%@) ", result]];
        }
        if(organ.length > 0)
        {
            if(!start)
            {
                [sql appendString:@"where "];
                start = YES;
            }
            else
            {
                if(isOr)
                    [sql appendString:@"or "];
                else
                    [sql appendString:@"and "];
            }
            if(self.organSwitch.isOn)
                [sql appendString:[NSString stringWithFormat:@"organ = '%@' ", organ]];
            else
                [sql appendString:[NSString stringWithFormat:@"organ like '%%%@%%' ", organ]];
        }
        if(address.length > 0)
        {
            if(!start)
            {
                [sql appendString:@"where "];
                start = YES;
            }
            else
            {
                if(isOr)
                    [sql appendString:@"or "];
                else
                    [sql appendString:@"and "];
            }
            if(self.addressSwitch.isOn)
                [sql appendString:[NSString stringWithFormat:@"address = '%@' ", address]];
            else
                [sql appendString:[NSString stringWithFormat:@"address like '%%%@%%' ", address]];
        }
        if(pagenum.length > 0 && !self.pagenumSwitch.isOn)
        {
            if(!start)
            {
                [sql appendString:@"where "];
                start = YES;
            }
            else
            {
                if(isOr)
                    [sql appendString:@"or "];
                else
                    [sql appendString:@"and "];
            }
            [sql appendString:[NSString stringWithFormat:@"pagenum = '%@' ", @(pagenum.intValue)]];
        }
        else if((self.minPage.text.length + self.maxPage.text.length > 0) && self.pagenumSwitch.isOn)
        {
            if(!start)
            {
                [sql appendString:@"where "];
                start = YES;
            }
            else
            {
                if(isOr)
                    [sql appendString:@"or "];
                else
                    [sql appendString:@"and "];
            }
            [sql appendString:@"("];
            NSString *tmp1 = [NSString stringWithFormat:@"pagenum >= '%d'", self.minPage.text.intValue];
            NSString *tmp2 = [NSString stringWithFormat:@"pagenum <= '%d'", self.maxPage.text.intValue];
            NSString *result;
            if(self.minPage.text.length && self.maxPage.text.length)
                result = [NSString stringWithFormat:@"%@ and %@ ", tmp1, tmp2];
            else if(self.minPage.text.length)
                result = tmp1;
            else if(self.maxPage.text.length)
                result = tmp2;
            [sql appendString:[NSString stringWithFormat:@"%@) ", result]];
        }
        [sql appendString:@";"];
        FMResultSet *resultSet = [db executeQuery:sql];
        
        if(resultSet)
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(successQuery:)])
                [self.delegate successQuery:resultSet];
            [self removeNotification];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            
    }
}

- (void)switchAction:(UISwitch *)sender
{
    NSString *message;
    if(sender.tag == 2)
    {
        self.minYear.hidden = !sender.isOn;
        self.maxYear.hidden = !sender.isOn;
        self.yearText.hidden = sender.isOn;
        if(sender.isOn)
            message = @"输入出版年份的最小值与最大值";
        else
            message = @"输入年份,如 1994";
    }
    else if(sender.tag == 5)
    {
        self.minPage.hidden = !sender.isOn;
        self.maxPage.hidden = !sender.isOn;
        self.pagenumText.hidden = sender.isOn;
        if(sender.isOn)
            message = @"输入页数的最小值与最大值";
        else
            message = @"输入页数,如 512";
    }
    else if(sender.tag == 6)
    {
        isOr = sender.isOn;
        if(sender.isOn)
            message = @"切换到 或 模式";
        else
            message = @"切换到 与 模式";
    }
    else
    {
        if(sender.isOn)
            message = @"精确查询";
        else
            message = @"模糊查询";
    }
    [self.view makeToast:message duration:1.0f position:CSToastPositionCenter];
}

- (void)tapAction:(UIPanGestureRecognizer *)sender
{
    [activeText resignFirstResponder];
}

#pragma mark - KeyboardNotification
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    CGFloat heightOfkeyboard = keyboardFrame.size.height;
    
    [self.keyboardView mas_updateConstraints:^(MASConstraintMaker *make){
        make.height.mas_equalTo(heightOfkeyboard);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self.keyboardView mas_updateConstraints:^(MASConstraintMaker *make){
        make.height.mas_equalTo(0);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeText = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(self.titleText == textField)
    {
        [self.authorText becomeFirstResponder];
    }
    else if (self.authorText == textField)
    {
        [self.yearText becomeFirstResponder];
    }
    else if(self.yearText == textField)
    {
        [self.organText becomeFirstResponder];
    }
    else if(self.organText == textField)
    {
        [self.addressText becomeFirstResponder];
    }
    else if (self.addressText == textField)
    {
        [self.pagenumText becomeFirstResponder];
    }
    else if(self.pagenumText == textField)
    {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - getter
- (UIButton *)cancelButton
{
    if(!_cancelButton)
    {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        [_cancelButton setImage:[UIImage imageNamed:@"image_cancel"] forState:UIControlStateNormal];
        _cancelButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.layer.cornerRadius = 10.0f;
    }
    return _cancelButton;
}

- (UIButton *)modifyButton
{
    if(!_modifyButton)
    {
        _modifyButton = [[UIButton alloc] init];
        NSString *complete;
        switch (self.detailType) {
            case DetailTypeNone: {
                complete = @"image_modify";
                break;
            }
            case DetailTypeEdit: {
                complete = @"image_modify";
                break;
            }
            case DetailTypeAdd: {
                complete = @"image_add";
                break;
            }
            case DetailTypeQuery: {
                complete = @"image_find";
                break;
            }
        }
        [_modifyButton setImage:[UIImage imageNamed:complete] forState:UIControlStateNormal];
        _modifyButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        _modifyButton.layer.masksToBounds = YES;
        _modifyButton.layer.cornerRadius = 10.0f;
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
        _titleLabel.textColor = [UIColor colorWithRed:0.851 green:0.310 blue:0.276 alpha:1.000];
    }
    return _titleLabel;
}

- (UITextField *)titleText
{
    if(!_titleText)
    {
        _titleText = [[UITextField alloc] init];
        _titleText.borderStyle = UITextBorderStyleBezel;
        _titleText.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        _titleText.delegate = self;
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
        _authorLabel.textColor = [UIColor colorWithRed:0.851 green:0.310 blue:0.276 alpha:1.000];
    }
    return _authorLabel;
}

- (UITextField *)authorText
{
    if(!_authorText)
    {
        _authorText = [[UITextField alloc] init];
        _authorText.borderStyle = UITextBorderStyleBezel;
        _authorText.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        _authorText.delegate = self;
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
        _yearText.borderStyle = UITextBorderStyleBezel;
        _yearText.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        _yearText.delegate = self;
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
        _organText.borderStyle = UITextBorderStyleBezel;
        _organText.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];\
        _organText.delegate = self;
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
        _titleText.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    }
    return _addressLabel;
}

- (UITextField *)addressText
{
    if(!_addressText)
    {
        _addressText = [[UITextField alloc] init];
        _addressText.borderStyle = UITextBorderStyleBezel;
        _addressText.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        _addressText.delegate = self;
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
        _pagenumText.borderStyle = UITextBorderStyleBezel;
        _pagenumText.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        _pagenumText.delegate = self;
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

- (UIView *)switchView
{
    if(!_switchView)
    {
        _switchView = [[UIView alloc] init];
    }
    return _switchView;
}

- (UISwitch *)titleSwitch
{
    if(!_titleSwitch)
    {
        _titleSwitch = [[UISwitch alloc] init];
        _titleSwitch.tag = 0;
        [_titleSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleSwitch;
}

- (UISwitch *)authorSwitch
{
    if(!_authorSwitch)
    {
        _authorSwitch = [[UISwitch alloc] init];
        _authorSwitch.tag = 1;
        [_authorSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _authorSwitch;
}

- (UISwitch *)yearSwitch
{
    if(!_yearSwitch)
    {
        _yearSwitch = [[UISwitch alloc] init];
        _yearSwitch.tag = 2;
        [_yearSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _yearSwitch;
}

- (UISwitch *)organSwitch
{
    if(!_organSwitch)
    {
        _organSwitch = [[UISwitch alloc] init];
        _organSwitch.tag = 3;
        [_organSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _organSwitch;
}

- (UISwitch *)addressSwitch
{
    if(!_addressSwitch)
    {
        _addressSwitch = [[UISwitch alloc] init];
        _addressSwitch.tag = 4;
        [_addressSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addressSwitch;
}

- (UISwitch *)pagenumSwitch
{
    if(!_pagenumSwitch)
    {
        _pagenumSwitch = [[UISwitch alloc] init];
        _pagenumSwitch.tag = 5;
        [_pagenumSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pagenumSwitch;
}

- (UITextField *)minYear
{
    if(!_minYear)
    {
        _minYear = [[UITextField alloc] init];
        _minYear.borderStyle = UITextBorderStyleBezel;
        _minYear.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        _minYear.placeholder = @"min";
    }
    return _minYear;
}

- (UITextField *)maxYear
{
    if(!_maxYear)
    {
        _maxYear = [[UITextField alloc] init];
        _maxYear.borderStyle = UITextBorderStyleBezel;
        _maxYear.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        _maxYear.placeholder = @"max";
    }
    return _maxYear;
}

- (UITextField *)minPage
{
    if(!_minPage)
    {
        _minPage = [[UITextField alloc] init];
        _minPage.borderStyle = UITextBorderStyleBezel;
        _minPage.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        _minPage.placeholder = @"min";
    }
    return _minPage;
}
- (UITextField *)maxPage
{
    if(!_maxPage)
    {
        _maxPage = [[UITextField alloc] init];
        _maxPage.borderStyle = UITextBorderStyleBezel;
        _maxPage.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        _maxPage.placeholder = @"max";
    }
    return _maxPage;
}

- (UISwitch *)orAndSwitch
{
    if(!_orAndSwitch)
    {
        _orAndSwitch = [[UISwitch alloc] init];
        _orAndSwitch.tag = 6;
        [_orAndSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orAndSwitch;
}

- (UIView *)keyboardView
{
    if(!_keyboardView)
    {
        _keyboardView = [[UIView alloc] init];
    }
    return _keyboardView;
}

@end
