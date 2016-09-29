//
//  ZLTestViewController.h
//  CustomNavigationController
//
//  Created by zhaoliang on 15/11/12.
//  Copyright © 2015年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <MapKit/MapKit.h>
@import CoreLocation;

@interface ZLTestViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *area;

//@property (readwrite, nonatomic, strong) MKMapView *mapView;
@property (strong, nonatomic) MKMapView *mapView;
//@property (strong, nonatomic) MKTileOverlay *layer;


@property (strong, nonatomic) NSArray *shapes;
@property (strong, nonatomic) NSArray *last_shapes;
@property (strong, nonatomic) NSString *shapes_type;

@property (strong, nonatomic) MKPointAnnotation *highlighted_pin;


@end
