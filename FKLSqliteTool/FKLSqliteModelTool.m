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
    
    // 获取更名字典
    NSDictionary *newNameToOldNameDict = @{};
    // @{@"age" : @"age2"}
    if ( [cls respondsToSelector:@selector(newNameToOldNameDict)] ) {
        newNameToOldNameDict = [cls newNameToOldNameDict];
    }
    
    for ( NSString *columnName in newNames ) {
        NSString *oldName = columnName;
        // 找映射的旧的字段名称
        if ( [newNameToOldNameDict[columnName] length] != 0 ) {
            oldName = newNameToOldNameDict[columnName];
        }
        // 如果老表包含新的列名，应该从老表更新到临时表格里面
        if ( (![oldNames containsObject:columnName]
              && ![oldNames containsObject:oldName])
            || [columnName isEqualToString:primaryKey] ) {
            continue;
        }
        
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = (select %@ form %@ where %@.%@ = %@.%@)", tmpTableName, columnName, oldName, tableName, tmpTableName, primaryKey, tableName, primaryKey];
        [execSql addObject:updateSql];
    }
    
    NSString *deleteOldTable = [NSString stringWithFormat:@"drop table if exists %@", tableName];
    [execSql addObject:deleteOldTable];
    
    NSString *renameTableName = [NSString stringWithFormat:@"alter table %@ rename to %@", tmpTableName, tableName];
    [execSql addObject:renameTableName];
    
    return [FKLSqliteTool dealSqls:execSql uid:uid];
}

+ (BOOL)saveModel:(id)model uid:(NSString *)uid {
    // 如果用户在使用过程中，直接调用这个方法，保存模型
    // 保存一个模型
    Class cls = [model class];
    
    // 判断表格是否存在，不存在，则创建
    if ( ![FKLTableTool isTableExists:cls uid:uid] ) {
        [self createTable:cls uid:uid];
    }
    
    // 检测表格式否需要更新，需要，更新
    if ( [self isTableRequiredUpdate:cls uid:uid] ) {
        [self updateTable:cls uid:uid];
    }
    
    // 判断记录是否存在 更新、执行插入记录动作
    NSString *tableName = [FKLModelTool tableName:cls];
    
    if ( ![cls respondsToSelector:@selector(primarykey)] ) {
        return NO;
    }
    NSString *primaryKey = [cls primarykey];
    id primaryValue = [model valueForKey:primaryKey];
    NSString *checkSql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", tableName, primaryKey, primaryValue];
    NSArray *result = [FKLSqliteTool querySql:checkSql uid:uid];
    
    // 获取字段数组
    NSArray *columnNames = [FKLModelTool classIvarNameTypeDict:cls].allKeys;
    
    // 获取值数组
    NSMutableArray *values = [NSMutableArray array];
    for ( NSString *columnName in columnNames ) {
        id value = [model valueForKey:columnName];
        [values addObject:value];
    }
    
    NSInteger count = columnNames.count;
    NSMutableArray *setValueArray = [NSMutableArray array];
    for ( int i = 0; i < count; i++ ) {
        NSString *name = columnNames[i];
        id value = values[i];
        NSString *setStr = [NSString stringWithFormat:@"%@=%@", name, value];
        [setValueArray addObject:setStr];
    }
    
    NSString *execSql = @"";
    
    if ( 0 < result.count ) {
        // 更新
        execSql = [NSString stringWithFormat:@"update %@ set %@ where %@ = '%@'", tableName, [setValueArray componentsJoinedByString:@","], primaryKey, primaryValue];
        
    } else {
        // 插入
        execSql = [NSString stringWithFormat:@"insert into %@(%@) values('%@')", tableName, [columnNames componentsJoinedByString:@","], [values componentsJoinedByString:@"','"]];
    }
    return [FKLSqliteTool deal:execSql uid:uid];
}

@end
