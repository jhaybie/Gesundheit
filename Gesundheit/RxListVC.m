//
//  RxListVC.m
//  Gesundheit
//
//  Created by Jhaybie on 10/28/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "RxListVC.h"

@interface Drugstore : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (nonatomic) CLLocationCoordinate2D coord;
@property (nonatomic) BOOL openNow;
@end

@implementation Drugstore
@end


@interface RxListVC ()
- (IBAction)onBackButtonTap:(id)sender;
@end

@implementation RxListVC

@synthesize  city,
             state;

NSArray        *searchResults;
NSMutableArray *drugstores;
NSString       *name,
               *address;


- (void)fetchSearchResults {
    drugstores = [[NSMutableArray alloc] init];
    city = [city stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=pharmacies+in+%@+%@&sensor=true&key=AIzaSyChk-7Q-sBiibQi8sUHWb7g3bHc2U1WdPQ", city, state]]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSDictionary *initialDump = [NSJSONSerialization JSONObjectWithData:data
                                                                                           options:0
                                                                                             error:&connectionError];
                               searchResults = [initialDump objectForKey:@"results"];
                               for (int i = 0; i < searchResults.count; i++) {
                                   NSDictionary *tempDict = [searchResults[i] objectForKey:@"geometry"];
                                   Drugstore *tempRx = [[Drugstore alloc] init];
                                   tempRx.name = [tempDict objectForKey:@"name"];
                                   tempRx.address = [searchResults[i] objectForKey:@"formatted_address"];
                                   tempRx.coord = CLLocationCoordinate2DMake([[[tempDict objectForKey:@"location"] objectForKey:@"lat"] floatValue], [[[tempDict objectForKey:@"location"] objectForKey:@"lng"] floatValue]);
                                   if ([[[searchResults[i] objectForKey:@"opening_hours"] objectForKey:@"open_now"] isEqualToString:@"true"])
                                       tempRx.openNow = YES;
                                   else tempRx.openNow = NO;
                                   [drugstores addObject:tempRx];
                               }
                           }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchSearchResults];
}

- (IBAction)onBackButtonTap:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
