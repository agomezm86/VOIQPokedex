//
//  ServicesManager.m
//  VOIQPokedex
//
//  Created by Field Service on 5/21/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import "ServicesManager.h"

@interface ServicesManager()

@property (strong, nonatomic) NSURLSessionDataTask *dataTask;
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;

@end

@implementation ServicesManager

- (void)createDataTaskWithCase:(NSInteger)serviceCase url:(NSURL *)url  parameters:(id)parameters andCompletionHandler:(ServiceCompletionHandler)completionHandler {
    if (self.dataTask != nil) {
        [self.dataTask cancel];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    
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
                if (serviceCase == PokemonsCount) {
                    NSNumber *countNumber = [dictionary objectForKey:@"count"];
                    completionHandler(countNumber, nil);
                } else if (serviceCase == AllPokemons) {
                    NSArray *array = [dictionary objectForKey:@"results"];
                    completionHandler(array, nil);
                } else if (serviceCase == PokemonBasicInfo) {
                    if ([dictionary objectForKey:@"detail"] != nil && [[dictionary objectForKey:@"detail"] isEqualToString:PokemonNotFoundError]) {
                        NSDictionary *errorDictionary = [NSDictionary dictionaryWithObject:@"Pokemon not found" forKey:NSLocalizedDescriptionKey];
                        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:errorDictionary];
                        completionHandler(nil, error);
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
                } else if (serviceCase == PokemonGenderInfo) {
                    NSDictionary *infoDictionary = (NSDictionary *)parameters;
                    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] initWithDictionary:infoDictionary];
                    [mutableDictionary setObject:[dictionary objectForKey:@"gender_rate"] forKey:@"gender_rate"];
                    completionHandler(mutableDictionary, nil);
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        });
    }];
    
    [self.dataTask resume];
}

- (void)getPokemonsCountWithCompletionHandler:(ServiceCompletionHandler)completionHandler {
    NSURL *url = [Constants getPokemonCountURL];
    [self createDataTaskWithCase:PokemonsCount url:url parameters:nil andCompletionHandler:^(id response, NSError *error) {
        if (error != nil) {
            completionHandler(0, error);
        } else  {
            NSNumber *countNumber = (NSNumber *)response;
            completionHandler(countNumber, nil);
        }
    }];
}

- (void)getListOfAllPokemonsWithCompletionHandler:(ServiceCompletionHandler)completionHandler {
    [self getPokemonsCountWithCompletionHandler:^(id response, NSError *error) {
        if (error != nil) {
            completionHandler(nil, error);
        } else {
            NSNumber *countNumber = (NSNumber *)response;
            NSURL *url = [Constants getListOfAllPokemonURL:countNumber.integerValue];
            [self createDataTaskWithCase:AllPokemons url:url parameters:nil andCompletionHandler:^(id response, NSError *error) {
                if (error != nil) {
                    completionHandler(0, error);
                } else  {
                    NSArray *array = (NSArray *)response;
                    completionHandler(array, nil);
                }
            }];
        }
    }];
}

- (void)getPokemonDetailedInfo:(NSString *)name withCompletionHandler:(ServiceCompletionHandler)completionHandler {
    [self getPokemonBasicInfoWithName:name andCompletionHandler:^(NSDictionary *infoDictionary, NSError *error) {
        if (error != nil) {
            completionHandler(nil, error);
        } else {
            [self getPokemonGenderInfo:infoDictionary withCompletionHandler:^(NSDictionary *infoDictionaryNew, NSError *error) {
                if (error != nil) {
                    completionHandler(nil, error);
                } else {
                    NSString *imageURL = [infoDictionaryNew objectForKey:@"image"];
                    NSNumber *identification = [infoDictionaryNew objectForKey:@"id"];
                    [self downloadImageWithURL:imageURL identification:identification withCompletionHandler:^(NSError *error) {
                        if (error != nil) {
                            completionHandler(nil, error);
                        } else {
                            completionHandler(infoDictionaryNew, nil);
                        }
                    }];
                }
            }];
        }
    }];
}

- (void)getPokemonBasicInfoWithName:(NSString *)name andCompletionHandler:(ServiceCompletionHandler)completionHandler {
    NSURL *url = [Constants getPokemonDetailedInfoURL:name];
    [self createDataTaskWithCase:PokemonBasicInfo url:url parameters:nil andCompletionHandler:^(id response, NSError *error) {
        if (error != nil) {
            completionHandler(0, error);
        } else  {
            NSDictionary *infoDictionary = (NSDictionary *)response;
            completionHandler(infoDictionary, nil);
        }
    }];
}

- (void)getPokemonGenderInfo:(NSDictionary *)infoDictionary withCompletionHandler:(ServiceCompletionHandler)completionHandler {
    NSURL *url = [NSURL URLWithString:[infoDictionary objectForKey:@"url"]];
    [self createDataTaskWithCase:PokemonGenderInfo url:url parameters:infoDictionary andCompletionHandler:^(id response, NSError *error) {
        if (error != nil) {
            completionHandler(0, error);
        } else  {
            NSDictionary *infoDictionary = (NSDictionary *)response;
            completionHandler(infoDictionary, nil);
        }
    }];
}

- (void)downloadImageWithURL:(NSString *)stringURL identification:(NSNumber *)identification withCompletionHandler:(DownloadImageCompletionHandler)completionHandler {
    if (self.downloadTask != nil) {
        [self.downloadTask cancel];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    
    NSURL *url = [NSURL URLWithString:stringURL];
    NSURLSession *session = [NSURLSession sharedSession];
    self.downloadTask = [session downloadTaskWithURL:url completionHandler: ^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            completionHandler(error);
        } else {
            NSData *data = [NSData dataWithContentsOfURL:location];
            NSURL *documentsDirectory = [Constants applicationDocumentsDirectory];
            [data writeToURL:[documentsDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", identification]] atomically:true];
            completionHandler(nil);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        });
    }];
    
    [self.downloadTask resume];
}

@end
