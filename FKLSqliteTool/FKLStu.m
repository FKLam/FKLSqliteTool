//
//  FKLStu.m
//  FKLSqliteTool
//
//  Created by kun on 2017/6/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "FKLStu.h"

@implementation FKLStu

#pragma mark - FKLModelProtocol

+ (NSString *)primarykey {
    return @"stuNum";
}

+ (NSArray *)ignoreColumnNames {
    return nil;
}

+ (NSDictionary *)newNameToOldNameDict {
    return @{@"age" : @"age2"};
}

@end
