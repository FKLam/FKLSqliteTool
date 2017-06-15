//
//  FKLModelProtocol.h
//  FKLSqliteTool
//
//  Created by kun on 2017/6/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FKLModelProtocol <NSObject>

@required
+ (NSString *)primarykey;

@optional
+ (NSArray *)ignoreColumnNames;

/**
 *  新字段名称->旧字段名称的映射表格
 *
 *  @return 映射表格
 */
+ (NSDictionary *)newNameToOldNameDict;

@end
