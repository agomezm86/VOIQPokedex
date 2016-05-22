//
//  Pokemon+CoreDataProperties.h
//  VOIQPokedex
//
//  Created by Alejandro Gomez Mutis on 5/22/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Pokemon.h"

NS_ASSUME_NONNULL_BEGIN

@interface Pokemon (CoreDataProperties)

/**
 @property pokemon name
 */
@property (nullable, nonatomic, retain) NSString *name;

/**
 @property pokemon info url
 */
@property (nullable, nonatomic, retain) NSString *url;

/**
 @property pokemon national id
 */
@property (nullable, nonatomic, retain) NSNumber *pokemon_id;

/**
 @property pokemon image url
 */
@property (nullable, nonatomic, retain) NSString *image;

/**
 @property pokemon female gender rate
 */
@property (nullable, nonatomic, retain) NSNumber *gender_rate;

@end

NS_ASSUME_NONNULL_END
