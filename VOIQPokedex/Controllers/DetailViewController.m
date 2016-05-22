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

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nationalIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;

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
                self.pokemon = [pokemonDataAccess loadPokemonWithName:self.pokemon.name];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadView];
                });
            }];
        }
    }];
}

- (void)reloadView {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSURL *documentsDirectory = [delegate applicationDocumentsDirectory];
    NSURL *imageURL = [documentsDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.pokemon.pokemon_id]];
    self.imageView.image = [UIImage imageWithContentsOfFile:[imageURL path]];
    
    self.nameLabel.text = [self.pokemon.name capitalizedString];
    self.nationalIDLabel.text = [NSString stringWithFormat:@"%@", self.pokemon.pokemon_id];
    self.genderLabel.text = [NSString stringWithFormat:@"%@", self.pokemon.gender_rate];
}

@end
