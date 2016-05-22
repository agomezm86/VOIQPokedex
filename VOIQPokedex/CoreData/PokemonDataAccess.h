//
//  PokemonDataAccess.h
//  VOIQPokedex
//
//  Created by Field Service on 5/21/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "Pokemon.h"

typedef void(^SaveListCompletionHandler)();

@interface PokemonDataAccess : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (id)sharedInstance;

- (void)saveListOfPokemon:(NSArray *)listArray withCompletionHandler:(SaveListCompletionHandler)completionHandler;
- (NSFetchedResultsController *)fetchedResultsControllerWithLimit:(NSInteger)fetchLimit;
- (void)updatePokemonInfoForName:(NSString *)name withInfo:(NSDictionary *)infoDictionary withCompletionHandler:(SaveListCompletionHandler)completionHandler;
- (Pokemon *)loadPokemonWithName:(NSString *)name;
- (NSInteger)loadPokemonCount;

@end
