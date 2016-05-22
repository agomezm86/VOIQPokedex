//
//  DetailViewController.h
//  VOIQPokedex
//
//  Created by Field Service on 5/22/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Pokemon.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Pokemon *pokemon;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
