//
//  AddViewController.m
//  SQLite学习
//
//  Created by zhangxing on 2017/5/22.
//  Copyright © 2017年 zhangxing. All rights reserved.
//

#import "AddViewController.h"
#import "SQLiteManager.h"
#import "StudentModel.h"

@interface AddViewController ()

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _userIdTF.text = _userId;
    _userNameTF.text = _userName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)add:(id)sender {
    StudentModel *model = [[StudentModel alloc] init];
    model.userId = _userIdTF.text;
    model.userName = _userNameTF.text;
    [[SQLiteManager sharedManager] insert:model];
}

- (IBAction)modify:(id)sender {
    StudentModel *model = [[StudentModel alloc] init];
    model.userId = _userIdTF.text;
    model.userName = _userNameTF.text;
    [[SQLiteManager sharedManager] modify:model];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
