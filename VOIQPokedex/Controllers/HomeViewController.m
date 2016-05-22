//
//  HomeViewController.m
//  VOIQPokedex
//
//  Created by Field Service on 5/21/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import "HomeViewController.h"

#import "AppDelegate.h"
#import "DetailViewController.h"
#import "Pokemon.h"
#import "PokemonDataAccess.h"
#import "UIScrollView+InfiniteScroll.h"

@interface HomeViewController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (assign, nonatomic) NSInteger fetchLimit;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.infiniteScrollIndicatorStyle = UIActivityIndicatorViewStyleGray;
    [self.tableView addInfiniteScrollWithHandler:^(UITableView *tableView) {
        weakSelf.fetchLimit += 20;
        [weakSelf performFetch];
        [tableView reloadData];
        [tableView finishInfiniteScroll];
    }];
}

- (void)performFetch {
    if (self.fetchLimit == 0) {
        self.fetchLimit = 20;
    }
    
    PokemonDataAccess *pokemonDataAccess = [PokemonDataAccess sharedInstance];
    pokemonDataAccess.managedObjectContext = self.managedObjectContext;
    self.fetchedResultsController = [pokemonDataAccess fetchedResultsControllerWithLimit:self.fetchLimit];
    if (self.fetchedResultsController.sections.count > 0) {
        self.fetchedResultsController.delegate = self;
    }
    
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    if (error) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate fatalCoreDataError:error];
    }
    
    [self.tableView reloadData];
}

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
    
    Pokemon *pokemon = (Pokemon *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [pokemon.name capitalizedString];
    
    return cell;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            break;
        case NSFetchedResultsChangeMove:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
