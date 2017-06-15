//
//  FKLTableTool.m
//  FKLSqliteTool
//
//  Created by kun on 2017/6/12.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "FKLTableTool.h"
#import "FKLModelTool.h"
#import "FKLSqliteTool.h"

@implementation FKLTableTool

+ (NSArray *)tableSorteColumnNames:(Class)cls uid:(NSString *)uid {
    NSString *tableName = [FKLModelTool tableName:cls];
    NSString *queryCreateSqlStr = [NSString stringWithFormat:@"select sql from sqlite_master where type = 'table' and name = '%@'", tableName];
    NSMutableDictionary *dict = [FKLSqliteTool querySql:queryCreateSqlStr uid:uid].firstObject;
    NSString *createTableSql = [dict[@"sql"] lowercaseString];
    createTableSql = [createTableSql stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
    createTableSql = [createTableSql stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
    createTableSql = [createTableSql stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\t"]];
    if ( 0 == createTableSql.length ) {
        return nil;
    }
    NSString *nameTypeStr = [createTableSql componentsSeparatedByString:@"c"][1];
    NSArray *namtTypeArray = [nameTypeStr componentsSeparatedByString:@","];
    
    NSMutableArray *names = [NSMutableArray array];
    for ( NSString *nameType in namtTypeArray ) {
        if ( [nameType containsString:@"primary"] ) {
            continue;
        }
        NSString *nameType2 = [nameType stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        NSString *name = [nameType2 componentsSeparatedByString:@" "].firstObject;
        [names addObject:name];
    }
    [names sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    return names;
}

+ (BOOL)isTableExists:(Class)cls uid:(NSString *)uid {
    NSString *tableName = [FKLModelTool tableName:cls];
    NSString *queryCreateSqlStr = [NSString stringWithFormat:@"select sql from sqlite_master where type = 'table' and name = '%@'", tableName];
    
    NSMutableArray *result = [FKLSqliteTool querySql:queryCreateSqlStr uid:uid];
    
    return result.count > 0;
}

@end
