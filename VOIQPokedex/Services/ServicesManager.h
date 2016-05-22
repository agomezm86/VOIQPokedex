//
//  ServicesManager.h
//  VOIQPokedex
//
//  Created by Alejandro Gomez Mutis on 5/21/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Custom blocks
 */
typedef void(^ServiceCompletionHandler)(id response, NSError *error);
typedef void(^DownloadImageCompletionHandler)(NSError *error);

@interface ServicesManager : NSObject

/**
 Public methods
 */
- (void)getListOfAllPokemonsWithCompletionHandler:(ServiceCompletionHandler)completionHandler;
- (void)getPokemonDetailedInfo:(NSString *)name withCompletionHandler:(ServiceCompletionHandler)completionHandler;

@end
