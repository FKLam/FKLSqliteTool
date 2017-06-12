//
//  FKLModelTool.m
//  FKLSqliteTool
//
//  Created by kun on 2017/6/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "FKLModelTool.h"
#import <objc/runtime.h>
#import "FKLModelProtocol.h"

@implementation FKLModelTool

+ (NSString *)tableName:(Class)cls {
    return NSStringFromClass(cls);
}

+ (NSMutableDictionary *)classIvarNameTypeDict:(Class)cls {
    NSMutableDictionary *nameTypeDict = [NSMutableDictionary dictionary];
    NSArray *ignoreNames = nil;
    if ( [cls respondsToSelector:@selector(ignoreColumnNames)] ) {
        ignoreNames = [cls ignoreColumnNames];
    }
    // 获取类中，所有成员变量和类型
    unsigned int outCount = 0;
    Ivar *varList = class_copyIvarList(cls, &outCount);
    for ( int i = 0; i< outCount; i++ ) {
        Ivar ivar = varList[i];
        // 获取成员变量名称
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        if ( [ivarName hasPrefix:@"_"] ) {
            ivarName = [ivarName substringFromIndex:1];
        }
        
        if (ignoreNames && [ignoreNames containsObject:ivarName] ) {
            continue;
        }
        
        // 获取成员变量类型
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        type = [type stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
        
        [nameTypeDict setValue:type forKey:ivarName];
    }
    return nameTypeDict;
}

+ (NSDictionary *)classIvarNameSqliteTypeDict:(Class)cls {
    NSMutableDictionary *dict = [self classIvarNameTypeDict:cls];
    NSDictionary *typeDict = [self ocTypeToSqliteTypeDict];
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        dict[key] = typeDict[obj];
    }];
    
    return dict;
}

+ (NSString *)columnNameAndTypesStr:(Class)cls {
    NSDictionary *nameTypeDict = [self classIvarNameSqliteTypeDict:cls];
    NSMutableArray *result = [NSMutableArray array];
    [nameTypeDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        [result addObject:[NSString stringWithFormat:@"%@ %@", key, obj]];
    }];
    
    return [result componentsJoinedByString:@","];
}

#pragma mark - private methods

+ (NSDictionary *)ocTypeToSqliteTypeDict {
    return @{
             @"d" : @"real",
             @"f" : @"real",
             
             @"i" : @"integer",
             @"q" : @"integer",
             @"Q" : @"integer",
             @"B" : @"integer",
             
             @"NSData" : @"blob",
             @"NSDictionary" : @"text",
             @"NSMutableDictionary" : @"text",
             @"NSNarray" : @"text",
             @"NSMutableArray" : @"text",
             
             @"NSString" : @"text"
             };
}

@end
