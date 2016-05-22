//
//  ServicesManager.h
//  VOIQPokedex
//
//  Created by Field Service on 5/21/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CountCompletionHandler)(NSInteger count, NSError *error);
typedef void(^CompleteListCompletionHandler)(NSArray *listArray, NSError *error);
typedef void(^DetailedInfoCompletionHandler)(NSDictionary *infoDictionary, NSError *error);
typedef void(^DownloadImageCompletionHandler)(NSError *error);

@interface ServicesManager : NSObject

- (void)getListOfAllPokemonsWithCompletionHandler:(CompleteListCompletionHandler)completionHandler;
- (void)getPokemonInfo:(NSString *)name withCompletionHandler:(DetailedInfoCompletionHandler)completionHandler;

@end
