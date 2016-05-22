//
//  AppDelegate.m
//  VOIQPokedex
//
//  Created by Field Service on 5/21/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import "AppDelegate.h"

#import "CoreDataStack.h"
#import "HomeViewController.h"
#import "PokemonDataAccess.h"
#import "ServicesManager.h"

@interface AppDelegate ()

@property (strong, nonatomic) CoreDataStack *coreDataStack;
@property (strong, nonatomic) HomeViewController *homeViewController;

@end

#define ManagedObjectContextSaveDidFailNotification @"ManagedObjectContextSaveDidFailNotification"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.coreDataStack = [[CoreDataStack alloc] init];
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        self.homeViewController = (HomeViewController *)navigationController.topViewController;
        self.homeViewController.coreDataStack = self.coreDataStack;
    }
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    ServicesManager *servicesManager = [[ServicesManager alloc] init];
    [servicesManager getPokemonsCountWithCompletionHandler:^(NSInteger count, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showError:error];
            });
        } else {
            [servicesManager getListOfAllPokemons:count withCompletionHandler:^(NSArray *listArray, NSError *error) {
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showError:error];
                    });
                } else {
                    PokemonDataAccess *pokemonDataAccess = [[PokemonDataAccess alloc]init];
                    pokemonDataAccess.coreDataStack = self.coreDataStack;
                    [pokemonDataAccess saveListOfPokemon:listArray withCompletionHandler:^() {
                        [self.homeViewController performFetch];
                    }];
                }
            }];
        }
    }];
}

- (void)showError:(NSError *)error {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ERROR", nil) message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:alertAction];
    
    if (self.homeViewController) {
        [self.homeViewController presentViewController:alertController animated:true completion:nil];
    }
}

- (void)fatalCoreDataError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:ManagedObjectContextSaveDidFailNotification object:nil];
}

- (void)listenForFatalCoreDataNotifications {
    [[NSNotificationCenter defaultCenter] addObserverForName:ManagedObjectContextSaveDidFailNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"INTERNAL_ERROR", nil) message:NSLocalizedString(@"FATAL_ERROR_MESSAGE", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSException *exception = [NSException exceptionWithName:NSInternalInconsistencyException reason:NSLocalizedString(@"FATAL_CORE_DATA_ERROR", nil) userInfo:nil];
            [exception raise];
        }];
        [alertController addAction:alertAction];
        
        if (self.homeViewController) {
            [self.homeViewController presentViewController:alertController animated:true completion:nil];
        }
    }];
}

@end
