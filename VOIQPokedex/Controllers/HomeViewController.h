//
//  HomeViewController.h
//  VOIQPokedex
//
//  Created by Alejandro Gomez Mutis on 5/21/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UITableViewController

/**
 @property core data managed context
 */
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

/**
 Public methods
 */
- (void)performFetch;

@end
