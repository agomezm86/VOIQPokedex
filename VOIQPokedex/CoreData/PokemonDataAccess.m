//
//  PokemonDataAccess.m
//  VOIQPokedex
//
//  Created by Field Service on 5/21/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import "PokemonDataAccess.h"

#import "AppDelegate.h"
#import "Pokemon.h"

#define POKEMON_ENTITY_NAME @"Pokemon"

@implementation PokemonDataAccess

- (void)saveListOfPokemon:(NSArray *)listArray withCompletionHandler:(SaveListCompletionHandler)completionHandler {
    for (NSDictionary *dictionary in listArray) {
        NSString *name = [dictionary objectForKey:@"name"];
        NSString *url = [dictionary objectForKey:@"url"];
        
        Pokemon *pokemon = [self loadPokemonWithName:name];
        if (pokemon == nil) {
            pokemon = [NSEntityDescription insertNewObjectForEntityForName:POKEMON_ENTITY_NAME inManagedObjectContext:self.coreDataStack.managedObjectContext];
            pokemon.name = name;
            pokemon.url = url;
        }
    }
    
    [self.coreDataStack saveContext];
    completionHandler();
}

- (Pokemon *)loadPokemonWithName:(NSString *)name {
    NSEntityDescription *entity = [NSEntityDescription entityForName:POKEMON_ENTITY_NAME inManagedObjectContext:self.coreDataStack.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    fetchRequest.predicate = predicate;
    
    Pokemon *pokemon = nil;
    NSError *error;
    NSArray *array = [self.coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:&error];
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

- (NSFetchedResultsController *)fetchedResultsController {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:POKEMON_ENTITY_NAME inManagedObjectContext:self.coreDataStack.managedObjectContext];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:true];

    fetchRequest.entity = entity;
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.coreDataStack.managedObjectContext sectionNameKeyPath:@"name" cacheName:@"Pokemons"];
    return fetchedResultsController;
}

@end