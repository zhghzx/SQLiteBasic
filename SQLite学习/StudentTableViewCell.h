//
//  StudentTableViewCell.h
//  SQLite学习
//
//  Created by zhangxing on 2017/5/22.
//  Copyright © 2017年 zhangxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentModel.h"

@interface StudentTableViewCell : UITableViewCell

@property (nonatomic, strong) StudentModel *model;
@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end
