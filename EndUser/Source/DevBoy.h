//
//  DevBoy.h
//  DevBoy
//
//  Created by Ahmad Abdul-Gawad Mahmoud on 10/26/16.
//  Copyright © 2016 Ahmad Abdul-Gawad Mahmoud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class DevBoy;

@protocol DevBoyDelegate <NSObject>

@optional
- (void)devBoyDidUpdate:(DevBoy *)devBoy;

@end

typedef NS_ENUM(NSUInteger, TrackingState) {
    TrackingStateOff = 0,
    TrackingStatePaused,
    TrackingStateTracking
};

typedef NS_ENUM(NSUInteger, TimeUnit) {
    TimeUnitSeconds = 0,
    TimeUnitMinutes,
    TimeUnitHours
};

typedef NS_ENUM(NSUInteger, DistanceUnit) {
    DistanceUnitMeters = 0,
    DistanceUnitKilometers,
    DistanceUnitFeet,
    DistanceUnitMiles
};

typedef NS_ENUM(NSUInteger, SpeedUnit) {
    SpeedUnitMetersPerSecond = 0,
    SpeedUnitKilometersPerHour,
    SpeedUnitMilesPerHour
};

@interface DevBoy : NSObject

@property (nonatomic) id<DevBoyDelegate> delegate;

@property (nonatomic, strong, readonly) NSMutableArray *routeLocations;

@property (nonatomic, strong, readonly) MKPolyline *routePolyline;

@property (nonatomic, readonly) MKCoordinateRegion routeRegion;

@property (nonatomic, readonly) TrackingState trackingState;

- (void)beginRouteTracking;

- (void)pauseRouteTracking;

- (void)resumeRouteTracking;

- (void)endRouteTracking;

- (NSTimeInterval)routeDurationWithUnit:(TimeUnit)timeUnit;

- (NSString *)routeDurationString;

- (CLLocationDistance)totalDistanceWithUnit:(DistanceUnit)distanceUnit;

- (CLLocationDistance)averageAltitudeWithUnit:(DistanceUnit)distanceUnit;

- (CLLocationDistance)minimumAltitudeWithUnit:(DistanceUnit)distanceUnit;

- (CLLocationDistance)maximumAltitudeWithUnit:(DistanceUnit)distanceUnit;

- (CLLocationSpeed)averageSpeedWithUnit:(SpeedUnit)speedUnit;

- (CLLocationSpeed)topSpeedWithUnit:(SpeedUnit)speedUnit;

- (void)handleLocationUpdate:(CLLocation *)location;

- (void)createRegionForRoute;

- (void)createPolylineForRoute;

@end
