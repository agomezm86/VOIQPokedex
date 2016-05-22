//
//  DetailViewController.h
//  VOIQPokedex
//
//  Created by Alejandro Gomez Mutis on 5/22/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Pokemon.h"

@interface DetailViewController : UIViewController

/**
 @property Pokemon instance
 */
@property (strong, nonatomic) Pokemon *pokemon;

/**
 @property core data managed context
 */
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
