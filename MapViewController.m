//
//  MapViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()<MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.selectedBike.title;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(self.selectedBike.coordinate, span);
    [self.mapView setRegion:region animated:YES];

    self.mapView.showsUserLocation = YES;
    [self.mapView addAnnotation:self.selectedBike];
    // Do any additional setup after loading the view.
}


#pragma mark - MapKit
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    request.source = [MKMapItem mapItemForCurrentLocation];

    MKPlacemark *placemark = [[MKPlacemark alloc]initWithCoordinate:self.selectedBike.coordinate addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc]initWithPlacemark:placemark];
    request.destination = mapItem;

    //Get directions for specified request
    MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error)
     {
         MKRoute *route = response.routes.firstObject;

         int counter = 1;
         NSMutableString *directionsString = [NSMutableString string];
         for (MKRouteStep *step in route.steps)
         {
             [directionsString appendFormat:@"%d: %@\n", counter, step.instructions];
             counter++;
         }
         UIAlertView *directionsAlert = [[UIAlertView alloc] initWithTitle:@"Directions:" message:directionsString delegate:self cancelButtonTitle:@"Got It!" otherButtonTitles:nil];
         [directionsAlert show];
         [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
     }];
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];

}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (annotation == mapView.userLocation) {
        return nil;
    }
    BikeModel *newAnnotation = annotation;
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    pin.image = [UIImage imageNamed:@"bikeImage"];
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    newAnnotation.title = annotation.title;
    return pin;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *route = overlay;
        MKPolylineRenderer *rendered = [[MKPolylineRenderer alloc] initWithPolyline:route];
        rendered.strokeColor = [UIColor colorWithRed:0.10 green:0.53 blue:0.76 alpha:1.00];
        rendered.lineWidth = 5.0;
        return rendered;
    }
    else {
        return nil;
    }
}
@end
