//
//  RxListVC.m
//  Gesundheit
//
//  Created by Jhaybie on 10/28/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "RxListVC.h"
#import "RootVC.h"
#import "WeeklyForecastVC.h"
#import <QuartzCore/QuartzCore.h>


@interface Drugstore : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (nonatomic) CLLocationCoordinate2D coord;
@property (nonatomic) BOOL openNow;
@end

@implementation Drugstore
@end


@interface RxListVC ()
@property (weak, nonatomic) IBOutlet UITableView *drugstoresTableView;
@property (strong, nonatomic) IBOutlet UIImageView *backroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *dandyImagePng;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *oneDayActiveButton;
@property (weak, nonatomic) IBOutlet UIButton *fiveDayActiveButton;
@property (weak, nonatomic) IBOutlet UIButton *rxListDisabledButton;

- (IBAction)onSearchButtonTap:(id)sender;
- (IBAction)onTapGoGoRootVC:(id)sender;
- (IBAction)onTapGoGoFiveDayForecastVC:(id)sender;
@end

@implementation RxListVC
@synthesize  oneDayActiveButton,
             location,
             fiveDayActiveButton,
             rxListDisabledButton,
             backroundImage,
             dandyImagePng,
             city,
             searchButton,
             state,
             drugstoresTableView,
             zipCodeTextField;


CLLocationCoordinate2D coord;
NSArray                *searchResults;
NSMutableArray         *drugstores;
NSString               *name,
                       *address;

- (void)buttonBorders {
    float radius = 10.0f;
    float width = 1.0f;

    [[oneDayActiveButton layer] setCornerRadius:radius];
    [[oneDayActiveButton layer] setBorderWidth:width];
    [[oneDayActiveButton layer] setBorderColor:[UIColor blueColor].CGColor];

    [[fiveDayActiveButton layer] setCornerRadius:radius];
    [[fiveDayActiveButton layer] setBorderWidth:width];
    [[fiveDayActiveButton layer] setBorderColor:[UIColor blueColor].CGColor];

    [rxListDisabledButton setBackgroundColor:[UIColor whiteColor]];
    [[rxListDisabledButton layer] setCornerRadius:radius];
    [[rxListDisabledButton layer] setBorderWidth:width];
    [[rxListDisabledButton layer] setBorderColor:[UIColor whiteColor].CGColor];

    [[searchButton layer] setCornerRadius:15.0f];
    [[searchButton layer] setBorderWidth:1.0f];
    [[searchButton layer] setBorderColor:[UIColor blueColor].CGColor];
}

- (void)fetchSearchResults {
    drugstores = [[NSMutableArray alloc] init];
    city = [city stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    //state = [location objectForKey:@"state"];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
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
                                   tempRx.name = [searchResults[i] objectForKey:@"name"];
                                   tempRx.address = [searchResults[i] objectForKey:@"formatted_address"];
                                   tempRx.coord = CLLocationCoordinate2DMake([[[tempDict objectForKey:@"location"] objectForKey:@"lat"] floatValue], [[[tempDict objectForKey:@"location"] objectForKey:@"lng"] floatValue]);
                                   tempRx.openNow = (BOOL)[[searchResults[i] objectForKey:@"opening_hours"] objectForKey:@"open_now"];
                                   [drugstores addObject:tempRx];
                                   [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                               }
                               [drugstoresTableView reloadData];
                           }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buttonBorders];
    [self showBackgroundImages];
    [self fetchSearchResults];
}

- (void) showBackgroundImages {
    backroundImage.image = [UIImage imageNamed:@"skyBackRound2.png"];
    dandyImagePng.image = [UIImage imageNamed:@"testDandyDan.png"];
    [dandyImagePng setAlpha:.5];
    [drugstoresTableView setAlpha:.75];

}

- (IBAction)onBackButtonTap:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section {
    return drugstores.count;
}

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Drugstore *tempDrugstore = drugstores[indexPath.row];
    name = tempDrugstore.name;
    address = [[tempDrugstore.address componentsSeparatedByString:@", "] firstObject];
    city = [[tempDrugstore.address componentsSeparatedByString:@", "] objectAtIndex:1];
    state = [[tempDrugstore.address componentsSeparatedByString:@", "] objectAtIndex:2];
    coord = tempDrugstore.coord;

    MapVC *mvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapVC"];
    mvc.name = name;
    mvc.address1 = address;
    mvc.city = city;
    mvc.state = state;
    mvc.coord = coord;
    [self presentViewController:mvc animated:YES completion:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xxx"];
    Drugstore *tempDrugstore = drugstores[indexPath.row];
    cell.textLabel.text = tempDrugstore.name;
    cell.detailTextLabel.numberOfLines = 2;
    NSString *tempAddress1 = [[tempDrugstore.address componentsSeparatedByString:@", "] firstObject];
    NSString *tempCity = [[tempDrugstore.address componentsSeparatedByString:@", "] objectAtIndex:1];
    NSString *tempState = [[tempDrugstore.address componentsSeparatedByString:@", "] objectAtIndex:2];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@, %@", tempAddress1, tempCity, tempState];
    return cell;
}

- (IBAction)onSearchButtonTap:(id)sender {
    [zipCodeTextField resignFirstResponder];
    city = zipCodeTextField.text;
    state = @"";
    [self fetchSearchResults];
    zipCodeTextField.text = @"";
}

- (IBAction)onTapGoGoRootVC:(id)sender {
    RootVC *rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"RootVC"];
    [self presentViewController:rvc
                       animated:NO
                     completion:nil];
}

- (IBAction)onTapGoGoFiveDayForecastVC:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];

//    WeeklyForecastVC *wfvc = [self.storyboard instantiateViewControllerWithIdentifier:@"WeeklyForecastVC"];
//    wfvc.location =
//    [self presentViewController:wfvc
//                       animated:NO
//                     completion:nil];
}
@end
