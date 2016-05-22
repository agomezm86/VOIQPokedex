//
//  PokemonDataAccessTests.m
//  VOIQPokedex
//
//  Created by Alejandro Gomez Mutis on 5/22/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>

#import "AppDelegate.h"
#import "Constants.h"
#import "Pokemon.h"
#import "PokemonDataAccess.h"
#import "ServicesManager.h"

@interface PokemonDataAccessTests : XCTestCase

@end

@implementation PokemonDataAccessTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

/**
 Unit test to save the list of pokemons obtained from the service
 */
- (void)testSaveListOfPokemon {
    // Get the managed object context
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PokemonDataAccess *pokemonDataAccess = [PokemonDataAccess sharedInstance];
    pokemonDataAccess.managedObjectContext = delegate.coreDataStack.managedObjectContext;
    
    // Delete the objects saved in database
    [self deleteObjectsWithContext:pokemonDataAccess.managedObjectContext];
    
    // Create test expectation for save the list in database
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    
    ServicesManager *servicesManager = [[ServicesManager alloc] init];
    XCTAssertNotNil(servicesManager);
    XCTAssert([servicesManager isKindOfClass:[ServicesManager class]]);
    
    [servicesManager getListOfAllPokemonsWithCompletionHandler:^(NSArray *listArray, NSError *error) {
        if (error) {
            // If the service returns an error the test will fail
            XCTFail("error %@", error.localizedDescription);
        } else {
            XCTAssertNil(error);
            XCTAssertNotNil(listArray);
            XCTAssertGreaterThan(listArray.count, 0);
            [pokemonDataAccess saveListOfPokemon:listArray withCompletionHandler:^() {
                // If the service returns the list and is saved succesfully in
                // database the expectation will be fulfilled
                [expectation fulfill];
            }];
        }
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            // If the timeout is over the test will fail
            XCTFail("error %@", error.localizedDescription);
        } else {
            Pokemon *pokemon = [pokemonDataAccess loadPokemonWithName:@"bulbasaur"];
            XCTAssertNotNil(pokemon);
            XCTAssert([pokemon isKindOfClass:[Pokemon class]]);
            XCTAssert([pokemon.name isEqualToString:@"bulbasaur"]);
        }
    }];
    
    // Create test expectation for update a register in database
    expectation = [self expectationWithDescription:@"expectation"];
    
    [servicesManager getPokemonDetailedInfo:@"bulbasaur" withCompletionHandler:^(NSDictionary *infoDictionary, NSError *error) {
        if (error != nil) {
            // If the service returns an error the test will fail
            XCTFail("error %@", error.localizedDescription);
        } else {
            XCTAssertNil(error);
            XCTAssertNotNil(infoDictionary);
            XCTAssertEqual(infoDictionary.allKeys.count, 4);
            
            [pokemonDataAccess updatePokemonInfoForName:@"bulbasaur" withInfo:infoDictionary andCompletionHandler:^() {
                // If the service returns the information and is saved succesfully in
                // database the expectation will be fulfilled
                [expectation fulfill];
            }];
        }
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            // If the timeout is over the test will fail
            XCTFail("error %@", error.localizedDescription);
        } else {
            Pokemon *pokemon = [pokemonDataAccess loadPokemonWithName:@"bulbasaur"];
            XCTAssertNotNil(pokemon);
            XCTAssert([pokemon isKindOfClass:[Pokemon class]]);
            XCTAssert([pokemon.name isEqualToString:@"bulbasaur"]);
            XCTAssertEqual(pokemon.pokemon_id.integerValue, 1);
        }
    }];
}

/**
 Delete all the objects in an entity
 @param managedObjectContext managed context for core data file
 */
- (void)deleteObjectsWithContext:(NSManagedObjectContext *)managedObjectContext {
    NSEntityDescription *entity = [NSEntityDescription entityForName:PokemonEntityName inManagedObjectContext:managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    
    NSError *error;
    NSArray *array = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate fatalCoreDataError:error];
    } else {
        for (Pokemon *pokemon in array) {
            [managedObjectContext deleteObject:pokemon];
        }
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.coreDataStack saveContext];
    }
}

@end
