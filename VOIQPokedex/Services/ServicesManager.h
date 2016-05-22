//
//  ServicesManager.h
//  VOIQPokedex
//
//  Created by Field Service on 5/21/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ServiceCompletionHandler)(id response, NSError *error);
typedef void(^DownloadImageCompletionHandler)(NSError *error);

@interface ServicesManager : NSObject

- (void)getListOfAllPokemonsWithCompletionHandler:(ServiceCompletionHandler)completionHandler;
- (void)getPokemonDetailedInfo:(NSString *)name withCompletionHandler:(ServiceCompletionHandler)completionHandler;

@end
