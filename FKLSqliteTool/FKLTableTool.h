//
//  FKLTableTool.h
//  FKLSqliteTool
//
//  Created by kun on 2017/6/12.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKLTableTool : NSObject

/**
 *  获取表格中所有的排序后字段
 *
 *  @param cls 类名
 *  @param uid 用户唯一标识
 *  @return 字段数组
 */
+ (NSArray *)tableSorteColumnNames:(Class)cls uid:(NSString *)uid;

+ (BOOL)isTableExists:(Class)cls uid:(NSString *)uid;

@end
