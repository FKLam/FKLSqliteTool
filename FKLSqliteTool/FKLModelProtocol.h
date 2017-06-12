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

@end
