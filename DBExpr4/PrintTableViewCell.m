//
//  PrintTableViewCell.m
//  DBExpr4
//
//  Created by 万延 on 16/4/27.
//  Copyright © 2016年 万延. All rights reserved.
//

#import "PrintTableViewCell.h"
#import "Masonry.h"

@interface PrintTableViewCell ()

@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *organLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation PrintTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self configureView];
    }
    return self;
}

- (void)loadModel:(PrintModel *)model
{
    _model = model;
    self.titleLabel.text = [NSString stringWithFormat:@"《%@》",model.title];
    self.authorLabel.text = [NSString stringWithFormat:@"作者：%@", model.author];
    self.organLabel.text = model.organ;
}

- (void)configureView
{
    self.backgroundColor = [UIColor colorWithRed:0.637 green:0.788 blue:1.000 alpha:1.000];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 20.0f;
    self.layer.borderColor = [UIColor purpleColor].CGColor;
    self.layer.borderWidth = 1.0f;
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    [self.contentView addSubview:self.authorLabel];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.titleLabel);
        make.width.mas_equalTo(170);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    [self.contentView addSubview:self.organLabel];
    [self.organLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.authorLabel.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
}

- (UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:30];
        _titleLabel.textColor = [UIColor purpleColor];
    }
    return _titleLabel;
}

- (UILabel *)authorLabel
{
    if(!_authorLabel)
    {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.textColor = [UIColor blueColor];
    }
    return _authorLabel;
}

- (UILabel *)organLabel
{
    if(!_organLabel)
    {
        _organLabel = [[UILabel alloc] init];
        _organLabel.textColor = [UIColor grayColor];
    }
    return _organLabel;
}

@end
