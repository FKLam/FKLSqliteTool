//
//  FKLSqliteModelTool.m
//  FKLSqliteTool
//
//  Created by kun on 2017/6/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "FKLSqliteModelTool.h"
#import "FKLModelTool.h"
#import "FKLModelProtocol.h"
#import "FKLSqliteTool.h"
#import "FKLTableTool.h"

@interface FKLSqliteModelTool ()

@end

@implementation FKLSqliteModelTool

+ (BOOL)createTable:(Class)cls uid:(NSString *)uid {
    // 表名
    NSString *tableName = [FKLModelTool tableName:cls];
    
    if ( ![cls conformsToProtocol:@protocol(FKLModelProtocol)] ) {
        if ( ![cls respondsToSelector:@selector(primarykey)] ) {
            NSLog(@"没有实现主键方法");
        }
        return NO;
    }
    
    NSString *primaryKey = [cls primarykey];
    
    // 获取字段，类型
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@))", tableName, [FKLModelTool columnNameAndTypesStr:cls], primaryKey];
    
    return [FKLSqliteTool deal:createTableSql uid:uid];
}

+ (BOOL)isTableRequiredUpdate:(Class)cls uid:(NSString *)uid {
    NSArray *modelNames = [FKLModelTool allTableSortedIvarNames:cls];
    NSArray *tableNames = [FKLTableTool tableSorteColumnNames:cls uid:uid];
    return ![modelNames isEqualToArray:tableNames];
}

+ (BOOL)updateTable:(Class)cls uid:(NSString *)uid {
    
    NSString *tmpTableName = [FKLModelTool tmpTableName:cls];
    NSString *tableName = [FKLModelTool tableName:cls];
    
    if ( ![cls respondsToSelector:@selector(primarykey)] ) {
        return NO;
    }
    
    NSMutableArray *execSql = [NSMutableArray array];
    NSString *primaryKey = [cls primarykey];
    
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@ primary key(%@))", tmpTableName, [FKLModelTool columnNameAndTypesStr:cls], primaryKey];
    [execSql addObject:createTableSql];
    
    NSString *insertPrimaryKeyData = [NSString stringWithFormat:@"insert into %@(%@) select %@ form %@;", tmpTableName, primaryKey, primaryKey, tableName];
    [execSql addObject:insertPrimaryKeyData];
    
    NSArray *oldNames = [FKLTableTool tableSorteColumnNames:cls uid:uid];
    NSArray *newNames = [FKLModelTool allTableSortedIvarNames:cls];
    
    for ( NSString *columnName in newNames ) {
        if ( ![oldNames containsObject:columnName] ) {
            continue;
        }
        
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = (select %@ form %@ where %@.%@ = %@.%@)", tmpTableName, columnName, columnName, tableName, tmpTableName, primaryKey, tableName, primaryKey];
        [execSql addObject:updateSql];
    }
    
    NSString *deleteOldTable = [NSString stringWithFormat:@"drop table if exists %@", tableName];
    [execSql addObject:deleteOldTable];
    
    NSString *renameTableName = [NSString stringWithFormat:@"alter table %@ rename to %@", tmpTableName, tableName];
    [execSql addObject:renameTableName];
    
    return [FKLSqliteTool dealSqls:execSql uid:uid];
}

@end
