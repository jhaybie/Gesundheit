//
//  MapVC.m
//  Gesundheit
//
//  Created by Jhaybie on 10/28/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "MapVC.h"


@interface MapVC ()

@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
- (IBAction)onBackButtonTap:(id)sender;
@end


@implementation MapVC
@synthesize  address1,
             city,
             coord,
             myMapView,
             name,
             state;


- (void)viewDidLoad
{
    [super viewDidLoad];
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    MKCoordinateRegion region;
    region.center = coord;
    region.span = span;
    [myMapView setRegion:region];

    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = region.center;
    point.title = name;

    point.subtitle = [NSString stringWithFormat:@"%@, %@, %@", address1, city, state];
    [myMapView addAnnotation:point];
    [myMapView selectAnnotation:point
                       animated:YES];
}

- (IBAction)onBackButtonTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
