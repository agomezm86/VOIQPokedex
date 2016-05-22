//
//  ServicesManagerTests.m
//  VOIQPokedex
//
//  Created by Alejandro Gomez Mutis on 5/22/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ServicesManager.h"

@interface ServicesManagerTests : XCTestCase

@end

@implementation ServicesManagerTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetListOfAllPokemons {
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    
    ServicesManager *servicesManager = [[ServicesManager alloc] init];
    XCTAssertNotNil(servicesManager);
    XCTAssert([servicesManager isKindOfClass:[ServicesManager class]]);
    
    [servicesManager getListOfAllPokemonsWithCompletionHandler:^(NSArray *listArray, NSError *error) {
        if (error) {
            XCTFail("error %@", error.localizedDescription);
        } else {
            XCTAssertNil(error);
            XCTAssertNotNil(listArray);
            XCTAssertGreaterThan(listArray.count, 0);
            [expectation fulfill];
        }
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail("error %@", error.localizedDescription);
        }
    }];
}

- (void)testGetPokemonDetailedInfo {
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    
    ServicesManager *servicesManager = [[ServicesManager alloc] init];
    XCTAssertNotNil(servicesManager);
    XCTAssert([servicesManager isKindOfClass:[ServicesManager class]]);
    
    [servicesManager getPokemonDetailedInfo:@"bulbasaur" withCompletionHandler:^(NSDictionary *infoDictionary, NSError *error) {
        if (error) {
            XCTFail("error %@", error.localizedDescription);
        } else {
            XCTAssertNil(error);
            XCTAssertNotNil(infoDictionary);
            XCTAssertEqual(infoDictionary.allKeys.count, 4);
            [expectation fulfill];
        }
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail("error %@", error.localizedDescription);
        }
    }];
}

- (void)testGetPokemonDetailedInfoForFail {
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    
    ServicesManager *servicesManager = [[ServicesManager alloc] init];
    XCTAssertNotNil(servicesManager);
    XCTAssert([servicesManager isKindOfClass:[ServicesManager class]]);
    
    [servicesManager getPokemonDetailedInfo:@"aaaaa" withCompletionHandler:^(NSDictionary *infoDictionary, NSError *error) {
        if (error) {
            XCTAssertNil(infoDictionary);
            XCTAssertNotNil(error);
            [expectation fulfill];
        } else {
            XCTFail("error %@", @"info dictionary received");
        }
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail("error %@", error.localizedDescription);
        }
    }];
}

@end
