//
//  HomeViewController.m
//  VOIQPokedex
//
//  Created by Field Service on 5/21/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import "HomeViewController.h"

#import "Pokemon.h"
#import "PokemonDataAccess.h"

@interface HomeViewController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performFetch];
}

- (void)performFetch {
    PokemonDataAccess *pokemonDataAccess = [[PokemonDataAccess alloc]init];
    pokemonDataAccess.coreDataStack = self.coreDataStack;
    self.fetchedResultsController = [pokemonDataAccess fetchedResultsController];
    self.fetchedResultsController.delegate = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"sections %lu", self.fetchedResultsController.sections.count);
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    NSLog(@"number of rows %lu for section %ld", (unsigned long)sectionInfo.numberOfObjects, (long)section);
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
    
    Pokemon *pokemon = (Pokemon *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = pokemon.name;
    
    return cell;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

/*
func controller(controller: NSFetchedResultsController,
                didChangeObject anObject: AnyObject,
                atIndexPath indexPath: NSIndexPath?,
                forChangeType type: NSFetchedResultsChangeType,
                newIndexPath: NSIndexPath?) {
    
    switch type {
    case .Insert:
        print("*** NSFetchedResultsChangeInsert (object)")
        tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        
    case .Delete:
        print("*** NSFetchedResultsChangeDelete (object)")
        tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        
    case .Update:
        print("*** NSFetchedResultsChangeUpdate (object)")
        if let cell = tableView.cellForRowAtIndexPath(indexPath!) as? LocationCell {
            let location = controller.objectAtIndexPath(indexPath!) as! Location
            cell.configureForLocation(location)
        }
        
    case .Move:
        print("*** NSFetchedResultsChangeMove (object)")
        tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        
    }
}

func controller(controller: NSFetchedResultsController,
                didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
                atIndex sectionIndex: Int,
                forChangeType type: NSFetchedResultsChangeType) {
    
    switch type {
    case .Insert:
        print("*** NSFetchedResultsChangeInsert (section)")
        tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        
    case .Delete:
        print("*** NSFetchedResultsChangeDelete (section)")
        tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        
    case .Update:
        print("*** NSFetchedResultsChangeUpdate (section)")
        
    case .Move:
        print("*** NSFetchedResultsChangeMove (section)")
        
    }
    
}*/

@end
