//
//  SQLiteManager.m
//  SQLite学习
//
//  Created by zhangxing on 2017/5/22.
//  Copyright © 2017年 zhangxing. All rights reserved.
//

#import "SQLiteManager.h"

@implementation SQLiteManager

#define kNameFile (@"Student.sqlite")

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static SQLiteManager *man = nil;
    dispatch_once(&onceToken, ^{
        man = [[SQLiteManager alloc] init];
        [man createDataBaseTableIfNeed];
    });
    return man;
}

- (NSString *)applicationDocumentsDirectoryFile {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths firstObject];
    NSString *filePath = [documentDirectory stringByAppendingString:kNameFile];
    return filePath;
}

- (void)createDataBaseTableIfNeed {
    NSString *writeTablePath = [self applicationDocumentsDirectoryFile];
    NSLog(@"数据库地址:%@", writeTablePath);
    if (sqlite3_open([writeTablePath UTF8String], &db) != SQLITE_OK) {
        //打开失败
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败!");
        
    }   else {
        //成功
        char *err;
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS StudentName (userId TEXT PRIMARYKEY, userName TEXT)"];
        /*
         db对象
         语句
         回调函数和回调函数传递参数
         错误信息
         */
        if (sqlite3_exec(db, [createSQL UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            //失败
            sqlite3_close(db);
            NSAssert1(NO, @"建表失败! %s", err);
        }
        sqlite3_close(db);
    }
    
}

-(NSMutableArray *)getAllStudents {
    NSMutableArray *ary = [NSMutableArray array];
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"打开数据库失败!");
    }   else {
        NSString *sql = @"SELECT *FROM StudentName";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *id = (char *)sqlite3_column_text(statement, 0);
                char *name = (char *)sqlite3_column_text(statement, 1);
                NSString *idStr = [[NSString alloc] initWithUTF8String:id];
                NSString *nameStr = [[NSString alloc] initWithUTF8String:name];
                StudentModel *mode = [[StudentModel alloc] init];
                mode.userId = idStr;
                mode.userName = nameStr;
                [ary addObject:mode];
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return ary;
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return nil;
}

//查询
- (StudentModel *)searchWithUserId:(StudentModel *)model {
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"打开数据库失败!");
    }   else {
        NSString *qsql = @"SELECT userId, userName FROM StudentName where userId = ?";
        sqlite3_stmt *statement;//语句对象
        //1.预处理
        if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statement, NULL) == SQLITE_OK) {//-1执行语句长度全部 NULL没有执行的语句部分
            //按主键查询数据库
            NSString *userId = model.userId;
            //2.绑定
            sqlite3_bind_text(statement, 1, [userId UTF8String], -1, NULL);//1开始执行序号 -1长度
            //3.遍历
            //SQLITE_ROW 查处结果
            if (sqlite3_step(statement) == SQLITE_ROW) {
                //4.提取 0字段索引
                char *id = (char *)sqlite3_column_text(statement, 0);
                NSString *idStr = [[NSString alloc] initWithUTF8String:id];
                char *name = (char *)sqlite3_column_text(statement, 1);
                NSString *nameStr = [[NSString alloc] initWithUTF8String:name];
                StudentModel *m = [[StudentModel alloc] init];
                m.userId = idStr;
                m.userName = nameStr;
                sqlite3_finalize(statement);
                sqlite3_close(db);
                return m;
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
        }
    }
    return nil;
}

//
- (int)insert:(StudentModel *)model {
    NSString *filePath = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([filePath UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"打开数据库失败!");
        
    }   else {
        NSString *sql = @"INSERT OR REPLACE INTO StudentName (userId, userName) VALUES (?, ?)";
        sqlite3_stmt *statement;
        //预处理
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            //绑定
            sqlite3_bind_text(statement, 1, [model.userId UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [model.userName UTF8String], -1, NULL);
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"插入数据失败!");
            };
            sqlite3_finalize(statement);
            sqlite3_close(db);
        };
        
    }
    
    return 0;
}

- (void)remove:(StudentModel *)model {
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"打开数据库失败!");
    }   else {
        //model.userId唯一才可删除成功
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM StudentName where userId = %@", model.userId];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"删除数据失败!");
            };
            sqlite3_finalize(statement);
            sqlite3_close(db);
        }
    }
}

- (void)modify:(StudentModel *)model {
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
    }   else {
        //model.userId唯一才可修改成功
        NSString *sql = [NSString stringWithFormat:@"update StudentName set userName = %@ WHERE userId = %@", model.userName, model.userId];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            sqlite3_close(db);
        }
    }
}

@end
