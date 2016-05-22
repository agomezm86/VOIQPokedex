//
//  VOIQPokedexUITests.m
//  VOIQPokedexUITests
//
//  Created by Alejandro Gomez Mutis on 5/21/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface VOIQPokedexUITests : XCTestCase

@end

@implementation VOIQPokedexUITests

- (void)setUp {
    [super setUp];
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    [super tearDown];
}

/**
 UITest for verify some tap rows and go back actions
 in portrait orientation
 */
- (void)testDownloadAndShowPokemonList {
    [XCUIDevice sharedDevice].orientation = UIDeviceOrientationPortrait;
    
    //This line is used for waiting web services response
    //in case the view is empty
    sleep(10);
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.tables.staticTexts[@"Abomasnow"] tap];
    
    sleep(10);
    [app.navigationBars[@"Abomasnow"].buttons[@"Pokemon List"] tap];
    [app.tables.staticTexts[@"Abra"] tap];
    
    sleep(10);
    [app.navigationBars[@"Abra"].buttons[@"Pokemon List"] tap];
}

/**
 UITest for verify some tap rows and go back actions
 in landscape orientation
 */
- (void)testDownloadAndShowPokemonListLandscape {
    [XCUIDevice sharedDevice].orientation = UIDeviceOrientationLandscapeRight;
    
    sleep(10);
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.tables.staticTexts[@"Absol"] tap];
    
    sleep(10);
    [app.navigationBars[@"Absol"].buttons[@"Pokemon List"] tap];
    [app.tables.staticTexts[@"Accelgor"] tap];
    
    sleep(10);
    [app.navigationBars[@"Accelgor"].buttons[@"Pokemon List"] tap];
}

@end
