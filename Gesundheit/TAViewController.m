//
//  TAViewController.m
//  Gesundheit
//
//  Created by Jhaybie on 10/23/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "TAViewController.h"
#import "TALocation.h"
#import "TAAppDelegate.h" 

@interface TAViewController ()

@end

@implementation TAViewController{
    
    NSFetchedResultsController *fetcher;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) showResults
{
    
    
    NSDictionary *tempDict;
    NSArray *tempArray;
    for (NSDictionary *dict in tempArray) {
        tempArray = [tempDict objectForKey:@"city"];
        tempArray = [tempDict objectForKey:@"desc"];
        tempArray = [tempDict objectForKey:@"predominantType"];
        tempArray = [tempDict objectForKey:@"state"];
    }
}

-(void)saveToCoreData

{
    NSFetchRequest *rq = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    fetcher = [[NSFetchedResultsController alloc] initWithFetchRequest:rq
                                                  managedObjectContext:[UIApplication moc]
                                                    sectionNameKeyPath:nil
                                                             cacheName:nil];
    

    [fetcher performFetch:nil];
    fetcher.delegate = self;
}

@end
