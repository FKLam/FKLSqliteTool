//
//  FKLSqliteToolTests.m
//  FKLSqliteToolTests
//
//  Created by kun on 2017/6/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FKLSqliteTool.h"

@interface FKLSqliteToolTests : XCTestCase

@end

@implementation FKLSqliteToolTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    NSString *sql = @"create table if not exists t_stu(id integer primary key autoincrement, name text not null, age integer, score real)";
    BOOL result = [FKLSqliteTool deal:sql uid:nil];
    XCTAssertEqual(result, YES);
}

- (void)testQuery {
    NSString *sql = @"select * from t_stu";
    NSMutableArray *result = [FKLSqliteTool querySql:sql uid:nil];
    NSLog(@"%@", result);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
