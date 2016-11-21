//
//  DemoView.m
//  DevBoy
//
//  Created by Ahmad Abdul-Gawad Mahmoud on 10/26/16.
//  Copyright © 2016 Ahmad Abdul-Gawad Mahmoud. All rights reserved.
//

#import "DemoView.h"
#import <UIView+Facade.h>
#import "Helper.h"
#import "EndUser-Swift.h"
#import <FirebaseDatabase/FirebaseDatabase.h>

@interface DemoView () {
    
    NSMutableArray *dummyData;
    NSTimer *timer;
    int counter;
}

@end

@implementation DemoView

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:13/255.0 green:14/255.0 blue:20/255.0 alpha:1.0];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.devBoy = [DevBoy new];
    self.devBoy.delegate = self;

    self.mapView = [MKMapView new];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.layer.cornerRadius = 7.0;
    self.mapView.clipsToBounds = YES;
    [self.view addSubview:self.mapView];
    
    self.maskView = [UIView new];
    self.maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    [self.mapView addSubview:self.maskView];
    
    self.avatarImageView = [UIImageView new];
    
    if ([[Helper getInstance] userPhoto] != nil) {
        
        self.avatarImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[[Helper getInstance] userPhoto]]];
        
    } else {
        
        self.avatarImageView.image = [UIImage imageNamed:@"avatar"];
    }
    
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 30.0;
    self.avatarImageView.layer.borderWidth = 1.0;
    self.avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.maskView addSubview:self.avatarImageView];
    
    self.dateLabel = [UILabel new];
    self.dateLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:19];
    self.dateLabel.textColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1.0];
    [self.maskView addSubview:self.dateLabel];
    
    self.cycleImageView = [UIImageView new];
    self.cycleImageView.image = [UIImage imageNamed:@"cycle"];
    [self.maskView addSubview:self.cycleImageView];
    
    self.trackingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.trackingButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    self.trackingButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    [self.trackingButton setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
//    [self.trackingButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
//    [self.maskView addSubview:self.trackingButton];
    
    self.containerView = [UIView new];
    //[self.view addSubview:self.containerView];
    
    self.timeView = [[MetricView alloc] initWithImage:[UIImage imageNamed:@"time"] title:@"Elapsed Time" color:[UIColor whiteColor]];
    [self.containerView addSubview:self.timeView];
    
    self.topSpeedView = [[MetricView alloc] initWithImage:[UIImage imageNamed:@"topSpeed"] title:@"Top Speed" color:[UIColor whiteColor]];
    [self.containerView addSubview:self.topSpeedView];
    
    self.averageSpeedView = [[MetricView alloc] initWithImage:[UIImage imageNamed:@"avgSpeed"] title:@"Avg. Speed" color:[UIColor whiteColor]];
    [self.containerView addSubview:self.averageSpeedView];
    
    self.distanceView = [[MetricView alloc] initWithImage:[UIImage imageNamed:@"distance"] title:@"Distance" color:[UIColor whiteColor]];
    [self.containerView addSubview:self.distanceView];
    
    self.averageAltitudeView = [[MetricView alloc] initWithImage:[UIImage imageNamed:@"avgAlt"] title:@"Avg. Altitude" color:[UIColor whiteColor]];
    [self.containerView addSubview:self.averageAltitudeView];
    
    self.maxAltitudeView = [[MetricView alloc] initWithImage:[UIImage imageNamed:@"maxAlt"] title:@"Max Altitude" color:[UIColor whiteColor]];
    [self.containerView addSubview:self.maxAltitudeView];

    [self preSettings];
}

- (void) preSettings {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSInteger day = [components day];
    NSInteger week = [components month];
    NSInteger year = [components year];
    NSString *string = [NSString stringWithFormat:@"%ld.%ld.%ld", (long)day, (long)week, (long)year];
    self.dateLabel.text = string;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNewLocationsAdded:) name: @"newLocationAdded" object:nil];
    
    _tracking = true;

    Utils.demoView = self;
    
    [Utils observeNewLocations];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.mapView anchorTopCenterFillingWidthWithLeftAndRightPadding:10 topPadding:20 height: self.view.frame.size.height - 40];
    [self.maskView anchorTopCenterFillingWidthWithLeftAndRightPadding:0 topPadding:0 height:75];
    [self.avatarImageView anchorCenterLeftWithLeftPadding:10 width:60 height:60];
    [self.dateLabel alignToTheRightOf:self.avatarImageView matchingTopAndFillingWidthWithLeftAndRightPadding:10 height:20];
    [self.cycleImageView alignUnder:self.dateLabel matchingLeftWithTopPadding:3 width:40 height:40];
    [self.trackingButton anchorCenterRightWithRightPadding:10 width:60 height:60];
    
    [self.containerView alignUnder:self.mapView centeredFillingWidthAndHeightWithLeftAndRightPadding:10 topAndBottomPadding:10];
    [self.containerView groupGrid:@[self.topSpeedView, self.averageSpeedView, self.distanceView, self.timeView, self.averageAltitudeView, self.maxAltitudeView] fillingWidthWithColumnCount:3 spacing:10];
}

#pragma mark - Map view delegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    UIColor *lightBlue = [UIColor colorWithRed:43.0/255 green:169.0/255 blue:223.0/255 alpha:1.0];
    renderer.fillColor = lightBlue;
    renderer.strokeColor = lightBlue;
    renderer.lineWidth = 10;
    return renderer;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    NSLog(@"longitude :: %f latitude :: %f", userLocation.coordinate.longitude, userLocation.coordinate.latitude);
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([[annotation title] isEqualToString:@"Current Location"]) {
        return nil;
    }
    
    MKAnnotationView *annView = [[MKAnnotationView alloc ] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    annView.image = [ UIImage imageNamed:@"cycle" ];
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annView.rightCalloutAccessoryView = infoButton;
    annView.canShowCallout = YES;
    return annView;
}

#pragma mark - HANDLE FIREBASE DATA.

- (void) handleNewLocationsAdded:(NSNotification*) notification {
    
    NSDictionary *location = notification.object;
    
    [self centerMapOnThisLocation:location];

    [self updateUIWithThisLocation:location];
}

- (void) centerMapOnThisLocation: (NSDictionary*) locationDic {

    if (_tracking) {
    
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[[locationDic valueForKey:@"latitude"] floatValue] longitude:[[locationDic valueForKey:@"longitude"] floatValue]];
        
        [_mapView setRegion:MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(.0005, .0005)) animated:YES];
        
        [self putPlaceMarkInLocation: location];
    }
}

- (void) putPlaceMarkInLocation:(CLLocation*) location {
    
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:location.coordinate];
    [self.mapView addAnnotation:placemark];

    /*CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        // Check for returned placemarks
        if (placemarks && placemarks.count > 0) {
            CLPlacemark *topResult = [placemarks objectAtIndex:0];
            
            MKPlacemark *placemark = [[MKPlacemark alloc]initWithPlacemark:topResult];
            [self.mapView addAnnotation:placemark];
        }
        
    }];*/
}

- (void) updateUIWithThisLocation: (NSDictionary*) location {
  
     [self.devBoy createPolylineForRoute];
     [self.devBoy createRegionForRoute];
    
     if (self.devBoy.routePolyline != nil) {
    
        [_mapView addOverlay:self.devBoy.routePolyline];
        [_mapView setRegion:self.devBoy.routeRegion animated:YES];
     }
}


@end
