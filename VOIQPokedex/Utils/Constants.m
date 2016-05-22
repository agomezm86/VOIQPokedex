//
//  Constants.m
//  VOIQPokedex
//
//  Created by Field Service on 5/21/16.
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

+ (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)getBaseURL {
    return BASE_URL;
}

+ (NSURL *)getPokemonCountURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, POKEMON_URL]];
}

+ (NSURL *)getListOfAllPokemonURL:(NSInteger)count {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%ld", BASE_URL, POKEMON_URL, (long)count]];
}

+ (NSURL *)getPokemonDetailedInfoURL:(NSString *)name {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", BASE_URL, POKEMON_DETAILED_INFO_URL, name]];
}

@end
