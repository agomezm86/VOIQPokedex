//
//  PokemonDataAccess.m
//  VOIQPokedex
//
//  Created by Field Service on 5/21/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import "PokemonDataAccess.h"

#import "AppDelegate.h"

#define POKEMON_ENTITY_NAME @"Pokemon"

@implementation PokemonDataAccess

+ (id)sharedInstance {
    static PokemonDataAccess *pokemonDataAccess = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pokemonDataAccess = [[self alloc] init];
    });
    return pokemonDataAccess;
}

- (void)saveListOfPokemon:(NSArray *)listArray withCompletionHandler:(SaveListCompletionHandler)completionHandler {
    for (NSDictionary *dictionary in listArray) {
        NSString *name = [dictionary objectForKey:@"name"];
        NSString *url = [dictionary objectForKey:@"url"];
        
        Pokemon *pokemon = [self loadPokemonWithName:name];
        if (pokemon == nil) {
            pokemon = [NSEntityDescription insertNewObjectForEntityForName:POKEMON_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
            pokemon.name = name;
            pokemon.url = url;
        }
    }
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate saveContext];
    completionHandler();
}

- (Pokemon *)loadPokemonWithName:(NSString *)name {
    NSEntityDescription *entity = [NSEntityDescription entityForName:POKEMON_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    fetchRequest.predicate = predicate;
    
    Pokemon *pokemon = nil;
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate fatalCoreDataError:error];
    } else {
        if ([array count] > 0) {
            pokemon = (Pokemon *)[array lastObject];
        }
    }
    
    return pokemon;
}

- (NSInteger)loadPokemonCount {
    NSEntityDescription *entity = [NSEntityDescription entityForName:POKEMON_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate fatalCoreDataError:error];
    }
    
    return array.count;
}

- (void)updatePokemonInfoForName:(NSString *)name withInfo:(NSDictionary *)infoDictionary withCompletionHandler:(SaveListCompletionHandler)completionHandler {
    Pokemon *pokemon = [self loadPokemonWithName:name];
    if (pokemon != nil) {
        NSInteger gender_rate = [[infoDictionary objectForKey:@"gender_rate"] doubleValue] / 8;
        pokemon.gender_rate = [NSNumber numberWithInteger:gender_rate];
        pokemon.pokemon_id = [NSNumber numberWithInteger:[[infoDictionary objectForKey:@"id"] integerValue]];
        pokemon.image = [infoDictionary objectForKey:@"image"];
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate saveContext];
    }
    
    completionHandler();
}

- (NSFetchedResultsController *)fetchedResultsController {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:POKEMON_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:true];

    fetchRequest.entity = entity;
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    return fetchedResultsController;
}

@end
