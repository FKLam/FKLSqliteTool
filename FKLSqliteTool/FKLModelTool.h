//
//  FKLModelTool.h
//  FKLSqliteTool
//
//  Created by kun on 2017/6/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKLModelTool : NSObject

+ (NSString *)tableName:(Class)cls;

+ (NSString *)tmpTableName:(Class)cls;

/**
 *  所有的成员变量，以及成员变量对应的类型
 */
+ (NSMutableDictionary *)classIvarNameTypeDict:(Class)cls;

/**
 *  所有的成员变量，以及成员变量映射到数据库里面对应的类型
 */
+ (NSDictionary *)classIvarNameSqliteTypeDict:(Class)cls;

/**
 *  将列名和类型拼接成一个字符串
 */
+ (NSString *)columnNameAndTypesStr:(Class)cls;

+ (NSArray *)allTableSortedIvarNames:(Class)cls;

@end
