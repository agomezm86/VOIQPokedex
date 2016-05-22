//
//  DetailViewController.m
//  VOIQPokedex
//
//  Created by Field Service on 5/22/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [self.pokemon.name capitalizedString];
}

@end
