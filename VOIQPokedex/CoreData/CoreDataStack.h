//
//  CoreDataStack.h
//  VOIQPokedex
//
//  Created by Alejandro Gomez Mutis on 5/22/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataStack : NSObject

/**
 @property core data managed context
 */
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

/**
 @property core data managed model
 */
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

/**
 @property core data persistent coordinator
 */
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 Public methods
 */
- (void)saveContext;

@end
