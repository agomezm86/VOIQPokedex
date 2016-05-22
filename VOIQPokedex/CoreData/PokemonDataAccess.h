//
//  PokemonDataAccess.h
//  VOIQPokedex
//
//  Created by Field Service on 5/21/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "CoreDataStack.h"

typedef void(^SaveListCompletionHandler)();

@interface PokemonDataAccess : NSObject

@property (strong, nonatomic) CoreDataStack *coreDataStack;

- (void)saveListOfPokemon:(NSArray *)listArray withCompletionHandler:(SaveListCompletionHandler)completionHandler;
- (NSFetchedResultsController *)fetchedResultsController;

@end
