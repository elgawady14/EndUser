//
//  DemoView.h
//  DevBoy
//
//  Created by Ahmad Abdul-Gawad Mahmoud on 10/26/16.
//  Copyright © 2016 Ahmad Abdul-Gawad Mahmoud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DevBoy.h"
#import "MetricView.h"

@interface DemoView : UIViewController <MKMapViewDelegate, DevBoyDelegate>

@property (nonatomic, strong) DevBoy *devBoy;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *cycleImageView;
@property (nonatomic, strong) UIButton *trackingButton;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) MetricView *timeView;
@property (nonatomic, strong) MetricView *topSpeedView;
@property (nonatomic, strong) MetricView *averageSpeedView;
@property (nonatomic, strong) MetricView *distanceView;
@property (nonatomic, strong) MetricView *averageAltitudeView;
@property (nonatomic, strong) MetricView *maxAltitudeView;

@property BOOL tracking;

@end
