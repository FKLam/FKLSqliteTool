//
//  FKLModelToolTests.m
//  FKLSqliteTool
//
//  Created by kun on 2017/6/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FKLModelTool.h"
#import "FKLStu.h"
#import "FKLSqliteModelTool.h"

@interface FKLModelToolTests : XCTestCase

@end

@implementation FKLModelToolTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIvarNameType {
    NSString *str = [FKLModelTool columnNameAndTypesStr:[FKLStu class]];
    NSLog(@"%@", str);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
