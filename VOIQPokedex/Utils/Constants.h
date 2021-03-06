//
//  Constants.h
//  VOIQPokedex
//
//  Created by Alejandro Gomez Mutis on 5/21/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Constants : NSObject

/**
 Application constants
 */
extern NSString *const PokemonEntityName;
extern NSString *const ManagedObjectContextSaveDidFailNotification;
extern NSString *const PokemonNotFoundError;

/**
 Public methods
 */
+ (NSURL *)applicationDocumentsDirectory;
+ (NSURL *)getPokemonCountURL;
+ (NSURL *)getListOfAllPokemonURL:(NSInteger)count;
+ (NSURL *)getPokemonDetailedInfoURL:(NSString *)name;

@end
