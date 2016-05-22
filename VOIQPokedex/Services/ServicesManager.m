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

- (void)getPokemonInfo:(NSString *)name withCompletionHandler:(DetailedInfoCompletionHandler)completionHandler {
    [self getBasicInfo:name withCompletionHandler:^(NSDictionary *infoDictionary, NSError *error) {
        if (error != nil) {
            completionHandler(nil, error);
        } else {
            [self getGenderInfo:infoDictionary withCompletionHandler:^(NSDictionary *infoDictionaryNew, NSError *error) {
                completionHandler(infoDictionaryNew, nil);
            }];
        }
    }];
}

- (void)getBasicInfo:(NSString *)name withCompletionHandler:(DetailedInfoCompletionHandler)completionHandler {
    if (self.dataTask != nil) {
        [self.dataTask cancel];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    
    NSURL *url = [Constants getPokemonDetailedInfoURL:name];
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
                NSMutableDictionary *infoDictionary = [[NSMutableDictionary alloc] init];
                [infoDictionary setObject:[dictionary objectForKey:@"id"] forKey:@"id"];
                
                NSDictionary *sprites = [dictionary objectForKey:@"sprites"];
                if ([sprites objectForKey:@"front_default"] != nil) {
                    [infoDictionary setObject:[sprites objectForKey:@"front_default"] forKey:@"image"];
                } else if ([sprites objectForKey:@"front_female"] != nil) {
                    [infoDictionary setObject:[sprites objectForKey:@"front_female"] forKey:@"image"];
                } else if ([sprites objectForKey:@"front_shiny"] != nil) {
                    [infoDictionary setObject:[sprites objectForKey:@"front_shiny"] forKey:@"image"];
                } else if ([sprites objectForKey:@"front_shiny_female"] != nil) {
                    [infoDictionary setObject:[sprites objectForKey:@"front_shiny_female"] forKey:@"image"];
                } else if ([sprites objectForKey:@"back_default"] != nil) {
                    [infoDictionary setObject:[sprites objectForKey:@"back_default"] forKey:@"image"];
                } else if ([sprites objectForKey:@"back_female"] != nil) {
                    [infoDictionary setObject:[sprites objectForKey:@"back_female"] forKey:@"image"];
                } else if ([sprites objectForKey:@"back_shiny"] != nil) {
                    [infoDictionary setObject:[sprites objectForKey:@"back_shiny"] forKey:@"image"];
                } else if ([sprites objectForKey:@"back_shiny_female"] != nil) {
                    [infoDictionary setObject:[sprites objectForKey:@"back_shiny_female"] forKey:@"image"];
                }
                
                NSDictionary *speciesDictionary = [dictionary objectForKey:@"species"];
                NSString *speciesUrl = [speciesDictionary objectForKey:@"url"];
                [infoDictionary setObject:speciesUrl forKey:@"url"];
                completionHandler (infoDictionary, nil);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        });
    }];
    
    [self.dataTask resume];
}

- (void)getGenderInfo:(NSDictionary *)infoDictionary withCompletionHandler:(DetailedInfoCompletionHandler)completionHandler {
    if (self.dataTask != nil) {
        [self.dataTask cancel];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    
    NSURL *url = [NSURL URLWithString:[infoDictionary objectForKey:@"url"]];
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
                NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] initWithDictionary:infoDictionary];
                [mutableDictionary setObject:[dictionary objectForKey:@"gender_rate"] forKey:@"gender_rate"];
                completionHandler(mutableDictionary, nil);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        });
    }];
    
    [self.dataTask resume];
}

@end
