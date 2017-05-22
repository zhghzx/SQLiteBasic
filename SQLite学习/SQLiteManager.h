//
//  SQLiteManager.h
//  SQLite学习
//
//  Created by zhangxing on 2017/5/22.
//  Copyright © 2017年 zhangxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "StudentModel.h"

@interface SQLiteManager : NSObject

{
    sqlite3 *db;
}

+ (instancetype)sharedManager;

- (NSMutableArray *)getAllStudents;

- (StudentModel *)searchWithUserId:(StudentModel *)model;

- (int)insert:(StudentModel *)model;

- (void)remove:(StudentModel *)model;

- (void)modify:(StudentModel *)model;

@end
