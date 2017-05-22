//
//  AddViewController.h
//  SQLite学习
//
//  Created by zhangxing on 2017/5/22.
//  Copyright © 2017年 zhangxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userIdTF;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;

@end
