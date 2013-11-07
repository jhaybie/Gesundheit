//
//  MapVC.m
//  Gesundheit
//
//  Created by Jhaybie on 10/28/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "MapVC.h"
#import <QuartzCore/QuartzCore.h>


@interface MapVC ()
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
- (IBAction)onBackButtonTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@end


@implementation MapVC
@synthesize  address1,
             backButton,
             city,
             coord,
             myMapView,
             name,
             state;

/*
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self mapStuff];
    [self addButtonBorder];

}

-(void) addButtonBorder {
    [[backButton layer] setBorderColor:[UIColor blueColor].CGColor];
    [[backButton layer] setBorderWidth:1.0f];
    [[backButton layer] setCornerRadius:15.0f];

}

-(void) mapStuff {
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


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{

    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"xxx"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"xxx"];
            pinView.canShowCallout = YES;
            pinView.calloutOffset = CGPointMake(0, 32);

            // Add a detail disclosure button to the callout.
            UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pinView.leftCalloutAccessoryView = leftButton;

        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        NSLog(@"Clicked Pizza Shop");

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Disclosure Pressed" message:@"Click Cancel to Go Back" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView show];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coord
                                                   addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];

    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
    [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                   launchOptions:launchOptions];
    }
}

//-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
//{
//    Class mapItemClass = [MKMapItem class];
//    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
//    {
//        // Create an MKMapItem to pass to the Maps app
//        CLLocationCoordinate2D coordinate =
//        CLLocationCoordinate2DMake(41.90, -87.65);
//        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
//                                                       addressDictionary:nil];
//        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
//        [mapItem setName:@"My Place"];
//
//        // Set the directions mode to "Walking"
//        // Can use MKLaunchOptionsDirectionsModeDriving instead
//        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
//        // Get the "Current User Location" MKMapItem
//        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
//        // Pass the current location and destination map items to the Maps app
//        // Set the direction mode in the launchOptions dictionary
//        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
//                       launchOptions:launchOptions];
//    }
//}


*/
- (IBAction)onBackButtonTap:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}





- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void)viewDidAppear:(BOOL)animated
{

    //    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(41.90, -87.65);
    MKCoordinateSpan span        = MKCoordinateSpanMake(.01, .01);

    [self.myMapView setRegion:MKCoordinateRegionMake(coord, span)  animated:YES];

    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coord;

    [self.myMapView addAnnotation:annotation];
    [myMapView selectAnnotation:annotation
                       animated:YES];

}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSString *reuseID = @"xxx";

    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseID];

    if (!view)
    {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseID];      //for standard pin
                                                                                                         //view = [[MobileMakersAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseID];  // for custom pin
        view.canShowCallout = YES;
        view.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    else
    {
        view.annotation = annotation;
    }
    return view;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{


    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coord
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:[NSString stringWithFormat:@"%@", name]];

        // Set the directions mode to "Walking"
        // Can use MKLaunchOptionsDirectionsModeDriving instead
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
    
    NSLog(@"Tapped");
}

@end
