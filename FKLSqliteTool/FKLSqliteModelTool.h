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

+ (BOOL)saveModel:(id)model uid:(NSString *)uid;

+ (BOOL)isTableRequiredUpdate:(Class)cls uid:(NSString *)uid;

+ (BOOL)updateTable:(Class)cls uid:(NSString *)uid;

@end
