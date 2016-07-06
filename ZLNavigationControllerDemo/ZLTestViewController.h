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

//@property (strong, nonatomic) MKMapView *mapView_;
//@property (strong, nonatomic) MKTileOverlay *layer;

@end
