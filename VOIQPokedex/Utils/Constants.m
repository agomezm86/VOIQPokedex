//
//  Constants.m
//  VOIQPokedex
//
//  Created by Alejandro Gomez Mutis on 5/21/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import "Constants.h"

#define BASE_URL @"http://pokeapi.co/api/v2/"
#define POKEMON_URL @"pokemon?limit=1"
#define POKEMON_DETAILED_INFO_URL @"pokemon/"

@implementation Constants

NSString *const PokemonEntityName = @"Pokemon";
NSString *const ManagedObjectContextSaveDidFailNotification = @"ManagedObjectContextSaveDidFailNotification";
NSString *const PokemonNotFoundError = @"Not found.";

/**
 Documents directory of the application
 */
+ (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

/**
 Base URL for the pokeapi API
 */
+ (NSString *)getBaseURL {
    return BASE_URL;
}

/**
 URL for the list to get the pokemon count
 */
+ (NSURL *)getPokemonCountURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, POKEMON_URL]];
}

/**
 URL for the list of all pokemons
 */
+ (NSURL *)getListOfAllPokemonURL:(NSInteger)count {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%ld", BASE_URL, POKEMON_URL, (long)count]];
}

/**
 URL to get the detailed info of a pokemon
 */
+ (NSURL *)getPokemonDetailedInfoURL:(NSString *)name {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", BASE_URL, POKEMON_DETAILED_INFO_URL, name]];
}

@end
