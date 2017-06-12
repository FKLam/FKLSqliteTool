//
//  FKLSqliteTool.m
//  FKLSqliteTool
//
//  Created by kun on 2017/6/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "FKLSqliteTool.h"
#import <sqlite3.h>

//#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject

#define kCachePath @"/Users/kun/Desktop"

static sqlite3 *ppDb = nil;

@implementation FKLSqliteTool

+ (BOOL)deal:(NSString *)sql uid:(NSString *)uid {
    
    // 打开／创建一个数据库
    if ( ![self openDB:uid] ) {
        return NO;
    }
    // 执行语句
    BOOL result = sqlite3_exec(ppDb, sql.UTF8String, nil, nil, nil) == SQLITE_OK;
    
    // 关闭数据库
    [self closeDB];
    
    return result;
    
}

+ (NSMutableArray<NSMutableDictionary *> *)querySql:(NSString *)sql uid:(NSString *)uid {
    // 打开数据库
    if ( ![self openDB:uid] ) {
        return nil;
    }
    // 准备语句
    sqlite3_stmt *ppStmt = nil;
    if ( sqlite3_prepare_v2(ppDb, sql.UTF8String, -1, &ppStmt, nil) != SQLITE_OK ) {
        NSLog(@"准备语句编译失败");
        return nil;
    }
    
    // 执行
    NSMutableArray *rowDictArray = [NSMutableArray array];
    while ( sqlite3_step(ppStmt) == SQLITE_ROW ) {
        // 获取所有列的个数
        int columnCount = sqlite3_column_count(ppStmt);
        
        NSMutableDictionary *rowDict = [NSMutableDictionary dictionary];
        [rowDictArray addObject:rowDict];
        // 遍历所有的列
        for (int i = 0; i < columnCount; i++ ) {
            // 获取列名
            const char *columnNameC = sqlite3_column_name(ppStmt, i);
            NSString *columnName = [NSString stringWithUTF8String:columnNameC];
            
            // 获取列值
            // 获取列的类型
            // 根据列的类型，使用不同的函数，进行获取值
            int type = sqlite3_column_type(ppStmt, i);
            id value = nil;
            switch ( type ) {
                case SQLITE_INTEGER: {
                    value = @(sqlite3_column_int(ppStmt, i));
                }
                    break;
                case SQLITE_FLOAT: {
                    value = @(sqlite3_column_double(ppStmt, i));
                }
                    break;
                case SQLITE_BLOB: {
                    value = CFBridgingRelease(sqlite3_column_blob(ppStmt, i));
                }
                    break;
                case SQLITE_NULL: {
                    value = @"";
                }
                    break;
                case SQLITE3_TEXT: {
                    value = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(ppStmt, i)];
                }
                    break;
                    default:
                    break;
            }
            [rowDict setValue:value forKey:columnName];
        }
        
    }
    
    // 释放资源
    sqlite3_finalize(ppStmt);
    [self closeDB];
    
    return rowDictArray;
}

+ (BOOL)dealSqls:(NSArray<NSString *> *)sqls uid:(NSString *)uid {
    [self beginTransaction:uid];
    
    for ( NSString *sql in sqls ) {
        BOOL result = [self deal:sql uid:uid];
        if ( result == NO ) {
            [self rollBackTransaction:uid];
            return NO;
        }
    }
    [self commitTransaction:uid];
    return YES;
}

+ (void)beginTransaction:(NSString *)uid {
    [self deal:@"begin transaction" uid:uid];
}

+ (void)commitTransaction:(NSString *)uid {
    [self deal:@"commit transaction" uid:uid];
}

+ (void)rollBackTransaction:(NSString *)uid {
    [self deal:@"rollBack transaction" uid:uid];
}

#pragma mark - private methods

+ (BOOL)openDB:(NSString *)uid {
    NSString *dbName = @"common.sqlite";
    if ( 0 != uid.length ) {
        dbName = [NSString stringWithFormat:@"%@.sqlite", uid];
    }
    NSString *dbPath = [kCachePath stringByAppendingPathComponent:dbName];
    
    // 打开／创建一个数据库
    return sqlite3_open(dbPath.UTF8String, &ppDb) == SQLITE_OK;
}

+ (void)closeDB {
    sqlite3_close(ppDb);
}

@end
