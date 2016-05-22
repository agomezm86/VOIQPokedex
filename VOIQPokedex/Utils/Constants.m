//
//  Constants.m
//  VOIQPokedex
//
//  Created by Field Service on 5/21/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import "Constants.h"

#define BASE_URL @"http://pokeapi.co/api/v2/"
#define POKEMON @"pokemon?limit=1"
#define POKEMON_COUNT @"pokemon?limit="

@implementation Constants

+ (NSString *)getBaseURL {
    return BASE_URL;
}

+ (NSURL *)getPokemonCountURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, POKEMON]];
}

+ (NSURL *)getListOfAllPokemonURL:(NSInteger)count {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%ld", BASE_URL, POKEMON, (long)count]];
}

@end