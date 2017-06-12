//
//  FKLSqliteModelTool.h
//  FKLSqliteTool
//
//  Created by kun on 2017/6/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKLSqliteModelTool : NSObject

+ (BOOL)createTable:(Class)cls uid:(NSString *)uid;

+ (void)saveModel:(id)model;

+ (BOOL)isTableRequiredUpdate:(Class)cls uid:(NSString *)uid;

+ (BOOL)updateTable:(Class)cls uid:(NSString *)uid;

@end
