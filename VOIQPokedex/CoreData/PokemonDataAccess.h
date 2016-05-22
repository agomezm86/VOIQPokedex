//
//  PokemonDataAccess.h
//  VOIQPokedex
//
//  Created by Alejandro Gomez Mutis on 5/21/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import "Pokemon.h"

/**
 Custom blocks
 */
typedef void(^SaveListCompletionHandler)();

@interface PokemonDataAccess : NSObject

/**
 @property core data managed context
 */
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

/**
 Public methods
 */
+ (id)sharedInstance;

- (void)saveListOfPokemon:(NSArray *)listArray withCompletionHandler:(SaveListCompletionHandler)completionHandler;
- (Pokemon *)loadPokemonWithName:(NSString *)name;
- (NSInteger)loadPokemonCount;
- (void)updatePokemonInfoForName:(NSString *)name withInfo:(NSDictionary *)infoDictionary andCompletionHandler:(SaveListCompletionHandler)completionHandler;
- (NSFetchedResultsController *)fetchedResultsControllerWithLimit:(NSInteger)fetchLimit;

@end
