//
//  FKLSqliteModelTool.h
//  FKLSqliteTool
//
//  Created by kun on 2017/6/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ColumnNameToValueRelationType) {
    ColumnNameToValueRelationTypeMore,
    ColumnNameToValueRelationTypeLess,
    ColumnNameToValueRelationTypeEqual,
    ColumnNameToValueRelationTypeMoreEqual,
    ColumnNameToValueRelationTypeLessEqual
};

@interface FKLSqliteModelTool : NSObject

+ (BOOL)createTable:(Class)cls uid:(NSString *)uid;

+ (BOOL)saveModel:(id)model uid:(NSString *)uid;

+ (BOOL)deleteModel:(id)model uid:(NSString *)uid;

// 根据条件来删除
+ (BOOL)deleteModel:(Class)cls whereStr:(NSString *)whereStr uid:(NSString *)uid;

+ (BOOL)deleteModel:(Class)cls columnName:(NSString *)columnName relation:(ColumnNameToValueRelationType)relation value:(id)value uid:(NSString *)uid;

+ (BOOL)deleteWithSql:(NSString *)sql uid:(NSString *)uid;

//+ (BOOL)deleteModel:(Class)cls columnNames:(NSArray *)columnNames relations:(NSArray *)relations values:(NSArray *)values naos:(NSArray *)naos uids:(NSArray *)uids;

+ (NSArray *)queryAllModels:(Class)cls uid:(NSString *)uid;

+ (NSArray *)queryModels:(Class)cls columnName:(NSString *)columnName relation:(ColumnNameToValueRelationType)relation value:(id)value uid:(NSString *)uid;

+ (NSArray *)queryModels:(Class)cls WithSql:(NSString *)sql uid:(NSString *)uid;

+ (BOOL)isTableRequiredUpdate:(Class)cls uid:(NSString *)uid;

+ (BOOL)updateTable:(Class)cls uid:(NSString *)uid;

@end
