//
//  HomeViewController.m
//  VOIQPokedex
//
//  Created by Alejandro Gomez Mutis on 5/21/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import "HomeViewController.h"

#import "AppDelegate.h"
#import "DetailViewController.h"
#import "Pokemon.h"
#import "PokemonDataAccess.h"
#import "UIScrollView+InfiniteScroll.h"

@interface HomeViewController ()

/**
 @property core data controller for fetched results
 */
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

/**
 @property limit for fetched registers
 */
@property (assign, nonatomic) NSInteger fetchLimit;

@end

@implementation HomeViewController

/**
 Controller is loaded
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     Handler for the infinite scroll
     everytime the bottom scroll is reached the event inside the block
     will be invoked
     */
    __weak typeof(self) weakSelf = self;
    self.tableView.infiniteScrollIndicatorStyle = UIActivityIndicatorViewStyleGray;
    [self.tableView addInfiniteScrollWithHandler:^(UITableView *tableView) {
        weakSelf.fetchLimit += 20;
        [weakSelf performFetch];
        [tableView finishInfiniteScroll];
    }];
}

/**
 Perform the fetch in order to get the list of pokemons
 */
- (void)performFetch {
    if (self.fetchLimit == 0) {
        self.fetchLimit = 20;
    }
    
    PokemonDataAccess *pokemonDataAccess = [PokemonDataAccess sharedInstance];
    pokemonDataAccess.managedObjectContext = self.managedObjectContext;
    self.fetchedResultsController = [pokemonDataAccess fetchedResultsControllerWithLimit:self.fetchLimit];
    
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    if (error) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate fatalCoreDataError:error];
    }
    
    [self.tableView reloadData];
}

/**
 Invoked when a segue is performed
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToDetailView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Pokemon *pokemon = (Pokemon *)[self.fetchedResultsController objectAtIndexPath:indexPath];
        DetailViewController *detailViewController = segue.destinationViewController;
        detailViewController.pokemon = pokemon;
        detailViewController.managedObjectContext = self.managedObjectContext;
    }
}

/**
 Number of sections in the controller's table view
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

/**
 Number of rows per section in the controller's table view
 */
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    return sectionInfo.numberOfObjects;
}

/**
 Contents of each cell in the controller's table view
 */
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
    
    Pokemon *pokemon = (Pokemon *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [pokemon.name capitalizedString];
    
    return cell;
}

@end
