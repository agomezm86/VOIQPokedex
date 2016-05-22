//
//  AppDelegate.h
//  VOIQPokedex
//
//  Created by Alejandro Gomez Mutis on 5/21/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ActivityIndicatorView.h"
#import "CoreDataStack.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

/**
 @property main window application
 */
@property (strong, nonatomic) UIWindow *window;

/**
 @property CoreDataStack instance
 */
@property (strong, nonatomic) CoreDataStack *coreDataStack;

/**
 Public methods
 */
- (void)showError:(NSError *)error;
- (void)fatalCoreDataError:(NSError *)error;
- (ActivityIndicatorView *)activityIndicatorView;

@end

