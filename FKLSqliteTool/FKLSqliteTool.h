//
//  FKLSqliteTool.h
//  FKLSqliteTool
//
//  Created by kun on 2017/6/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKLSqliteTool : NSObject

// 用户机制
// uid：nil common.db
// uid：zhangsan zhangsan.db

+ (BOOL)deal:(NSString *)sql uid:(NSString *)uid;

+ (NSMutableArray<NSMutableDictionary *> *)querySql:(NSString *)sql uid:(NSString *)uid;

+ (BOOL)dealSqls:(NSArray<NSString *> *)sqls uid:(NSString *)uid;

@end
