//
//  ServicesManager.m
//  VOIQPokedex
//
//  Created by Field Service on 5/21/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import "ServicesManager.h"

#import "Constants.h"

@interface ServicesManager()

@property (strong, nonatomic) NSURLSessionDataTask *dataTask;

@end

@implementation ServicesManager

- (void)getPokemonsCountWithCompletionHandler:(CountCompletionHandler)completionHandler {
    if (self.dataTask != nil) {
        [self.dataTask cancel];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    
    NSURL *url = [Constants getPokemonCountURL];
    NSURLSession *session = [NSURLSession sharedSession];
    self.dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data,    NSURLResponse *response, NSError *error) {
        if (error != nil) {
            completionHandler(0, error);
        } else {
            NSError *parsingError;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parsingError];
            if (parsingError) {
                completionHandler(0, parsingError);
            } else {
                NSNumber *countNumber = [dictionary objectForKey:@"count"];
                completionHandler(countNumber.integerValue, nil);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        });
    }];
    
    [self.dataTask resume];
}

- (void)getListOfAllPokemons:(NSInteger)pokemonCount withCompletionHandler:(CompleteListCompletionHandler)completionHandler {
    if (self.dataTask != nil) {
        [self.dataTask cancel];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    
    NSURL *url = [Constants getListOfAllPokemonURL:pokemonCount];
    NSURLSession *session = [NSURLSession sharedSession];
    self.dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data,    NSURLResponse *response, NSError *error) {
        if (error != nil) {
            completionHandler(nil, error);
        } else {
            NSError *parsingError;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parsingError];
            if (parsingError) {
                completionHandler(nil, parsingError);
            } else {
                NSArray *array = [dictionary objectForKey:@"results"];
                completionHandler(array, nil);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        });
    }];
    
    [self.dataTask resume];
}

@end
