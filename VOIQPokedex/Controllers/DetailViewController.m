//
//  DetailViewController.m
//  VOIQPokedex
//
//  Created by Field Service on 5/22/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import "DetailViewController.h"

#import "ActivityIndicatorView.h"
#import "AppDelegate.h"
#import "PokemonDataAccess.h"
#import "ServicesManager.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nationalIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderTitleLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [self.pokemon.name capitalizedString];
    self.contentView.hidden = true;
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ActivityIndicatorView *activityIndicatorView = nil;
    NSURL *imageURL = [self imageURL];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[imageURL path]]) {
        [self reloadViewWithImageURL:imageURL];
    } else {
        activityIndicatorView = [delegate activityIndicatorView];
        [self.view addSubview:activityIndicatorView];
    }
    
    ServicesManager *servicesManager = [[ServicesManager alloc] init];
    [servicesManager getPokemonInfo:self.pokemon.name withCompletionHandler:^(NSDictionary *infoDictionary, NSError *error) {
        if (error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (activityIndicatorView != nil) {
                    [activityIndicatorView removeFromSuperview];
                }
                
                [delegate showError:error];
            });
        } else {
            PokemonDataAccess *pokemonDataAccess = [PokemonDataAccess sharedInstance];
            pokemonDataAccess.managedObjectContext = self.managedObjectContext;
            [pokemonDataAccess updatePokemonInfoForName:self.pokemon.name withInfo:infoDictionary andCompletionHandler:^() {
                self.pokemon = [pokemonDataAccess loadPokemonWithName:self.pokemon.name];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (activityIndicatorView != nil) {
                        [activityIndicatorView removeFromSuperview];
                    }
                    [self reloadViewWithImageURL:[self imageURL]];
                });
            }];
        }
    }];
}

- (void)reloadViewWithImageURL:(NSURL *)imageURL {
    self.contentView.hidden = false;
    self.imageView.image = [UIImage imageWithContentsOfFile:[imageURL path]];
    
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"NAME", nil), [self.pokemon.name capitalizedString]]];
    [nameString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(0, NSLocalizedString(@"NAME", nil).length)];
    self.nameLabel.attributedText = nameString;
    
    NSMutableAttributedString *nationalIDString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"NATIONAL_ID", nil), self.pokemon.pokemon_id]];
    [nationalIDString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(0, NSLocalizedString(@"NATIONAL_ID", nil).length)];
    self.nationalIDLabel.attributedText = nationalIDString;
    
    self.genderTitleLabel.text = NSLocalizedString(@"MALE_FEMALE_TITLE", nil);
    
    double femaleGenderRate = self.pokemon.gender_rate.doubleValue;
    double maleGenderRate = 1 - femaleGenderRate;
    if (femaleGenderRate == -1) {
        self.genderLabel.text = NSLocalizedString(@"NO_GENDER", nil);
    } else {
        NSNumberFormatter *numberFormatter = [self numberFormatter];
        NSString *maleGenderRateString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:maleGenderRate]];
        NSString *femaleGenderRateString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:femaleGenderRate]];
        self.genderLabel.text = [NSString stringWithFormat:@"%@ / %@", maleGenderRateString, femaleGenderRateString];

    }
}

- (NSURL *)imageURL {
    NSURL *documentsDirectory = [Constants applicationDocumentsDirectory];
    NSURL *imageURL = [documentsDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.pokemon.pokemon_id]];
    return imageURL;
}

- (NSNumberFormatter *)numberFormatter {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
    numberFormatter.minimumFractionDigits = 0;
    numberFormatter.maximumFractionDigits = 1;
    return numberFormatter;
}

@end
