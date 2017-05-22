//
//  StudentTableViewCell.m
//  SQLite学习
//
//  Created by zhangxing on 2017/5/22.
//  Copyright © 2017年 zhangxing. All rights reserved.
//

#import "StudentTableViewCell.h"

@implementation StudentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(StudentModel *)model {
    if (_model != model) {
        _model = model;
    }
    _userId.text = model.userId;
    _userName.text = model.userName;
}

@end
