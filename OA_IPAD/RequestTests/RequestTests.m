//
//  RequestTests.m
//  RequestTests
//
//  Created by cello on 2018/3/25.
//  Copyright © 2018年 icebartech. All rights reserved.
//
// TODO: 输入错误的密码；参数少了某个看看结果

#import <XCTest/XCTest.h>
#import "UserService.h"
#import "RequestManager.h"

@interface RequestTests : XCTestCase

@end

@implementation RequestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRequestManager {
    XCTestExpectation *expect = [self expectationWithDescription:@"testRequestManager"];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"UserID":@"system",@"PSW":@"system"}];
    __weak NSURLSessionDataTask *task = [[RequestManager shared] requestWithAction:@"Login" appendingURL:@"DMS_FileMan_Handler.ashx?" parameters:params callback:^(BOOL success, id data, NSError *error) {
        XCTAssertTrue(success);
        XCTAssert(data);
        XCTAssertNil(error);
        [expect fulfill];
    }];
    
    XCTAssert(task);
    
    [self waitForExpectations:@[expect] timeout:20.0];
}

- (void)testUserService {
    [UserService shared].activeCode = nil;
    [RequestManager shared].activeCode = nil; //清除ActiveCode，以免造成影响
    XCTestExpectation *expect = [self expectationWithDescription:@"testUserService"];
    
    [[[UserService shared] loginWithAccount:@"system" password:@"system"] subscribeNext:^(id  _Nullable x) {
        XCTAssert(x);
    } error:^(NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expect fulfill];
    } completed:^{
        //看看参数有没有保存在UserDefaults
        XCTAssert([[NSUserDefaults standardUserDefaults] objectForKey:@"UserService_activeCode"]);
        [expect fulfill];
    }];
    
    [self waitForExpectations:@[expect] timeout:20.0];
}

@end
