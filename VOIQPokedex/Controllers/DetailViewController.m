//
//  DetailViewController.m
//  VOIQPokedex
//
//  Created by Field Service on 5/22/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import "DetailViewController.h"

#import "AppDelegate.h"
#import "PokemonDataAccess.h"
#import "ServicesManager.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [self.pokemon.name capitalizedString];
    
    ServicesManager *servicesManager = [[ServicesManager alloc] init];
    [servicesManager getPokemonInfo:self.pokemon.name withCompletionHandler:^(NSDictionary *infoDictionary, NSError *error) {
        if (error != nil) {
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate showError:error];
        } else {
            PokemonDataAccess *pokemonDataAccess = [[PokemonDataAccess alloc]init];
            pokemonDataAccess.managedObjectContext = self.managedObjectContext;
            [pokemonDataAccess updatePokemonInfoForName:self.pokemon.name withInfo:infoDictionary withCompletionHandler:^() {
                
            }];
        }
    }];
}

@end
