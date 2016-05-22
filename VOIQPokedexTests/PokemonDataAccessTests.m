//
//  PokemonDataAccessTests.m
//  VOIQPokedex
//
//  Created by Field Service on 5/22/16.
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

- (void)testSaveListOfPokemon {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PokemonDataAccess *pokemonDataAccess = [PokemonDataAccess sharedInstance];
    pokemonDataAccess.managedObjectContext = delegate.coreDataStack.managedObjectContext;
    [self deleteObjectsWithContext:pokemonDataAccess.managedObjectContext];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    
    ServicesManager *servicesManager = [[ServicesManager alloc] init];
    XCTAssertNotNil(servicesManager);
    XCTAssert([servicesManager isKindOfClass:[ServicesManager class]]);
    
    [servicesManager getListOfAllPokemonsWithCompletionHandler:^(NSArray *listArray, NSError *error) {
        if (error) {
            XCTFail("error %@", error.localizedDescription);
        } else {
            XCTAssertNil(error);
            XCTAssertNotNil(listArray);
            XCTAssertGreaterThan(listArray.count, 0);
            [pokemonDataAccess saveListOfPokemon:listArray withCompletionHandler:^() {
                [expectation fulfill];
            }];
        }
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail("error %@", error.localizedDescription);
        } else {
            Pokemon *pokemon = [pokemonDataAccess loadPokemonWithName:@"bulbasaur"];
            XCTAssertNotNil(pokemon);
            XCTAssert([pokemon isKindOfClass:[Pokemon class]]);
            XCTAssert([pokemon.name isEqualToString:@"bulbasaur"]);
        }
    }];
    
    
    expectation = [self expectationWithDescription:@"expectation"];
    
    [servicesManager getPokemonDetailedInfo:@"bulbasaur" withCompletionHandler:^(NSDictionary *infoDictionary, NSError *error) {
        if (error != nil) {
            XCTFail("error %@", error.localizedDescription);
        } else {
            XCTAssertNil(error);
            XCTAssertNotNil(infoDictionary);
            XCTAssertEqual(infoDictionary.allKeys.count, 4);
            
            [pokemonDataAccess updatePokemonInfoForName:@"bulbasaur" withInfo:infoDictionary andCompletionHandler:^() {
                [expectation fulfill];
            }];
        }
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
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
