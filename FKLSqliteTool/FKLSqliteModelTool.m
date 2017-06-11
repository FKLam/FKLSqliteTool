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

@end
