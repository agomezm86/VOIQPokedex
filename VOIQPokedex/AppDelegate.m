//
//  AppDelegate.m
//  VOIQPokedex
//
//  Created by Field Service on 5/21/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import "AppDelegate.h"

#import "ActivityIndicatorView.h"
#import "HomeViewController.h"
#import "PokemonDataAccess.h"
#import "ServicesManager.h"

@interface AppDelegate ()

@property (strong, nonatomic) HomeViewController *homeViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.coreDataStack = [[CoreDataStack alloc] init];
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        self.homeViewController = (HomeViewController *)navigationController.topViewController;
        self.homeViewController.managedObjectContext = self.coreDataStack.managedObjectContext;
        [self.homeViewController performFetch];
    }
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    PokemonDataAccess *pokemonDataAccess = [PokemonDataAccess sharedInstance];
    pokemonDataAccess.managedObjectContext = self.coreDataStack.managedObjectContext;
    NSInteger pokemonCount = [pokemonDataAccess loadPokemonCount];
    
    CGRect bounds = self.homeViewController.view.bounds;
    ActivityIndicatorView *activityIndicatorView = nil;
    if (pokemonCount == 0) {
        self.homeViewController.view.userInteractionEnabled = false;
        activityIndicatorView = [[ActivityIndicatorView alloc] initWithFrame:CGRectMake((bounds.size.width / 2) - 75, (bounds.size.height / 2) - 75, 150, 150)];
        [self.homeViewController.view addSubview:activityIndicatorView];
    }
    
    ServicesManager *servicesManager = [[ServicesManager alloc] init];
    [servicesManager getPokemonsCountWithCompletionHandler:^(NSInteger count, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (activityIndicatorView != nil) {
                    self.homeViewController.view.userInteractionEnabled = true;
                    [activityIndicatorView removeFromSuperview];
                }
                [self showError:error];
            });
        } else {
            [servicesManager getListOfAllPokemons:count withCompletionHandler:^(NSArray *listArray, NSError *error) {
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (activityIndicatorView != nil) {
                            self.homeViewController.view.userInteractionEnabled = true;
                            [activityIndicatorView removeFromSuperview];
                        }
                        [self showError:error];
                    });
                } else {
                    [pokemonDataAccess saveListOfPokemon:listArray withCompletionHandler:^() {
                        dispatch_async(dispatch_get_main_queue(), ^() {
                            if (activityIndicatorView != nil) {
                                self.homeViewController.view.userInteractionEnabled = true;
                                [activityIndicatorView removeFromSuperview];
                            }
                            [self.homeViewController performFetch];
                        });
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
