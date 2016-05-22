//
//  AppDelegate.m
//  VOIQPokedex
//
//  Created by Field Service on 5/21/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeViewController.h"
#import "PokemonDataAccess.h"
#import "ServicesManager.h"

@interface AppDelegate ()

@property (strong, nonatomic) HomeViewController *homeViewController;

@end

#define ManagedObjectContextSaveDidFailNotification @"ManagedObjectContextSaveDidFailNotification"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        self.homeViewController = (HomeViewController *)navigationController.topViewController;
        self.homeViewController.managedObjectContext = self.managedObjectContext;
        [self.homeViewController performFetch];
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
                    pokemonDataAccess.managedObjectContext = self.managedObjectContext;
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


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "agomez.VOIQPokedex" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"VOIQPokedex" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"VOIQPokedex.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //            abort();
            
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate fatalCoreDataError:error];
        }
    }
}

@end
