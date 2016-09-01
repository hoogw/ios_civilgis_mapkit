//
//  ZLTestViewController.m
//  CustomNavigationController
//
//  Created by zhaoliang on 15/11/12.
//  Copyright © 2015年 zhao. All rights reserved.
//


#import "ZLTestViewController.h"
#import "ZLCommonConst.h"
#import "GeoJSONSerialization.h"





@interface ZLTestViewController ()  <MKMapViewDelegate>

@property (readwrite, nonatomic, strong) MKMapView *mapView;
//@property (nonatomic, weak) UIView *nightView;



@end

@implementation ZLTestViewController{
    
    
    

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    // .......... mapkit init ................
    
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    
   // mapView.mapType = MKMapTypeHybrid;
    
    mapView.showsUserLocation = YES;
    
    mapView.delegate = self;
    
    
//    MKUserLocation *userLocation = mapView.userLocation;
//    
//    MKCoordinateRegion region =
//    MKCoordinateRegionMakeWithDistance (
//                                        userLocation.location.coordinate, 20000, 20000);
//    
//    
//    [mapView setRegion:region animated:NO];
    
     NSString *lat=@"33.6599244";
     NSString *lng=@"-117.915058135";
    
    CGFloat latitude = [lat floatValue];
    CGFloat longitude = [lng floatValue];
    
    CLLocationCoordinate2D center_coord = CLLocationCoordinate2DMake(latitude, longitude);
    
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center_coord, 20000, 20000);
    
    
   // [mapView setCenterCoordinate:center_coord animated:YES];
    [mapView setRegion:region animated:YES];
   
    
    
    NSString *tile_url = [NSString stringWithFormat:@"http://tile.transparentgov.net/v2/%@_%@/{z}/{x}/{y}.png", _area, _subject];
    
    
    
    MKTileOverlay *overlay = [[MKTileOverlay alloc] initWithURLTemplate: tile_url];
    
    //overlay.canReplaceMapContent = YES;
    
    
    // above Road render tile too slow, above label render tile faster
   // [mapView addOverlay:overlay level: MKOverlayLevelAboveRoads];
     [mapView addOverlay:overlay level: MKOverlayLevelAboveLabels];
    
    
    
    
    self.view = mapView;
    //[self.view addSubview:mapView];
    
    
    
    //............. END ......... mapkit init .........................
    
    
    
    
    
    
    
    // ----- title text ------------
    
    UITextView *mytext = [[UITextView alloc] initWithFrame:CGRectMake(100, 20, 400.0, 28.0)];
    mytext.backgroundColor = [UIColor clearColor];
    NSString *title = [_area stringByAppendingString:@" - "];
    title = [title stringByAppendingString:_subject];
    mytext.text = title;
    mytext.textColor = [UIColor blueColor];
    mytext.font = [UIFont systemFontOfSize:15];
    mytext.editable = NO;
    [self.view addSubview:mytext];
    
    
    
    
    //-------- back button ------
    
    UIButton *backbtn = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    backbtn.frame = CGRectMake(0, 20, 50, 18);
    [backbtn setTitle:@"< back" forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(backbtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];
    
    
    
    //======= location =================
    // ** Don't forget to add NSLocationWhenInUseUsageDescription in MyApp-Info.plist and give it a string
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    
    
    
    
    //---------------- add area boundary -------------
    
    
    
    
    NSString *const _url_arealimit = [NSString stringWithFormat:@"http://166.62.80.50:10/gis/api/maparealimit/%@/limit", _area];

    //NSLog(@"URL****: %@", kMessageBoardURLString);
    
    
//    NSURL *msgURL = [NSURL URLWithString:_url_arealimit];
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    
//    
//    
//    NSURLSessionTask *messageTask = [session dataTaskWithURL:msgURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        
//        
//        // NSString *retString = [NSString stringWithUTF8String:[data bytes]];
//        
//        
//        // NSLog(@"json returned: %@", retString);
//        
//        //
//        //    NSError *parseError = nil;
//        //    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
//        //                                                         options:0
//        //                                                           error:&parseError];
//        //
//        //    if (!parseError) {
//        //        [self setMessageArray:jsonArray];
//        //        NSLog(@"json array is %@", jsonArray);
//        //    } else {
//        //        NSString *err = [parseError localizedDescription];
//        //        NSLog(@"Encountered error parsing: %@", err);
//        //    }
//        
//        
//        
//        NSDictionary *geoJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        NSArray *shapes = [GeoJSONSerialization shapesFromGeoJSONFeatureCollection:geoJSON error:nil];
//        
//        for (MKShape *shape in shapes) {
//            if ([shape isKindOfClass:[MKPointAnnotation class]]) {
//                
//                [mapView addAnnotation:shape];
//            } else if ([shape conformsToProtocol:@protocol(MKOverlay)]) {
//                
//                [mapView addOverlay:(id <MKOverlay>)shape];
//                
//            }
//        }
//
//        
//        
//        
//        
//    }];
//    [messageTask resume];
    
    
    [self add_geojson_layer:_url_arealimit  toMap: mapView ];
    
    //-------------- end area boundary -------------------
    
    
    
    
    
    
    
    
    
    
    // first time get geojson
    
    NSString * _url_api = [self get_map_bound];
    
   // NSLog(@"----- json_api -----: %@", _url_api);
    
    [self add_geojson_layer:_url_api toMap: mapView ];
    
    
    
    
}// view did load method






// =============== add geojson layer ===========

- (void) add_geojson_layer:(NSString*)_url toMap:(MKMapView *)mapview_{

    
    
    NSLog(@"*****  URL  ****: %@", _url);
    
    
    NSURL *msgURL = [NSURL URLWithString:_url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    
    
    NSURLSessionTask *messageTask = [session dataTaskWithURL:msgURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        // NSString *retString = [NSString stringWithUTF8String:[data bytes]];
        
        
        // NSLog(@"json returned: %@", retString);
        
        //
        //    NSError *parseError = nil;
        //    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
        //                                                         options:0
        //                                                           error:&parseError];
        //
        //    if (!parseError) {
        //        [self setMessageArray:jsonArray];
        //        NSLog(@"json array is %@", jsonArray);
        //    } else {
        //        NSString *err = [parseError localizedDescription];
        //        NSLog(@"Encountered error parsing: %@", err);
        //    }
        
        
        
        NSDictionary *geoJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *shapes = [GeoJSONSerialization shapesFromGeoJSONFeatureCollection:geoJSON error:nil];
        
        for (MKShape *shape in shapes) {
            if ([shape isKindOfClass:[MKPointAnnotation class]]) {
                
                [mapview_ addAnnotation:shape];
            } else if ([shape conformsToProtocol:@protocol(MKOverlay)]) {
                
                [mapview_ addOverlay:(id <MKOverlay>)shape];
                
            }
        }// for shapes
        

    
    }];// message session task
     [messageTask resume];
    
    
    
}// add geojson method



// =========== End add geojson layer ==================










                                     //............. get map bound ................
                                     
                                     -(NSString *)get_map_bound
                                     {
                                         
                                         // MKMapRect mRect =  _mapView.visibleMapRect;
                                         
                                         MKMapRect mRect = self.mapView.visibleMapRect;
                                         
                                         CLLocationCoordinate2D bottomLeft = [self getSWCoordinate:mRect];
                                         CLLocationCoordinate2D topRight = [self getNECoordinate:mRect];
                                         
                                         
                                         NSNumber *sw_lat = [NSNumber numberWithDouble:bottomLeft.latitude ];
                                         NSNumber *sw_lng = [NSNumber numberWithDouble:bottomLeft.longitude];
                                         NSNumber *ne_lat =  [NSNumber numberWithDouble:topRight.latitude];
                                         NSNumber *ne_lng =[NSNumber numberWithDouble:topRight.longitude];
                                         
                                         
                                         NSString *sw_lat_string = [sw_lat stringValue];
                                         NSString *sw_lng_string = [sw_lng stringValue];
                                         NSString *ne_lat_string = [ne_lat stringValue];
                                         NSString *ne_lng_string = [ne_lng stringValue];
                                         
                                         
                                         // php
                                         NSString *_url =[NSString stringWithFormat:@"http://166.62.80.50:10/gis/api/loadall_mobile/%@/%@/%@/%@/%@/%@", _area, _subject,sw_lng_string,sw_lat_string,ne_lng_string,ne_lat_string];
                                         
                                         // asp.net
                                         // NSString *_url =[NSString stringWithFormat:@"http://166.62.80.50/api/geojson/feature_mobile/%@/%@/%@/%@/%@/%@", _area, _subject,sw_lng_string,sw_lat_string,ne_lng_string,ne_lat_string];
                                         
                                         
                                         return _url;
                                         
                                         
                                     }
                                     
                                     
                                     
                                     -(CLLocationCoordinate2D)getNECoordinate:(MKMapRect)mRect{
                                         return [self getCoordinateFromMapRectanglePoint:MKMapRectGetMaxX(mRect) y:mRect.origin.y];
                                     }
                                     -(CLLocationCoordinate2D)getNWCoordinate:(MKMapRect)mRect{
                                         return [self getCoordinateFromMapRectanglePoint:MKMapRectGetMinX(mRect) y:mRect.origin.y];
                                     }
                                     -(CLLocationCoordinate2D)getSECoordinate:(MKMapRect)mRect{
                                         return [self getCoordinateFromMapRectanglePoint:MKMapRectGetMaxX(mRect) y:MKMapRectGetMaxY(mRect)];
                                     }
                                     -(CLLocationCoordinate2D)getSWCoordinate:(MKMapRect)mRect{
                                         return [self getCoordinateFromMapRectanglePoint:mRect.origin.x y:MKMapRectGetMaxY(mRect)];
                                     }
                                     
                                     
                                     -(CLLocationCoordinate2D)getCoordinateFromMapRectanglePoint:(double)x y:(double)y{
                                         MKMapPoint swMapPoint = MKMapPointMake(x, y);
                                         return MKCoordinateForMapPoint(swMapPoint);
                                     }
                                     
                                     
                                     
                                     
                                     //.............End of  get map bound ................








// ------  Location Manager Delegate Methods  --------
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
   // NSLog(@"%@", [locations lastObject]);
}






#pragma mark - MKMapViewDelegate

//- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
//{
//    
//    
//    
//    if ([overlay isKindOfClass:[MKTileOverlay class]]) {
//        
//        
//        
//        return [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
//    }
//    
//    return nil;
//}


#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString * PinIdentifier = @"Pin";
    
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:PinIdentifier];
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PinIdentifier];
    };
    
    annotationView.hidden = ![annotation isKindOfClass:[MKPointAnnotation class]];
    
    return annotationView;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id <MKOverlay>)overlay
{
    
    // tile overlay
    
    if ([overlay isKindOfClass:[MKTileOverlay class]]) {
        
        
        
                return [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
            }
    
    else {
    
        
        
    // geojson - shape overlay
        
    MKOverlayRenderer *renderer = nil;
        
     // polyline
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        renderer = [[MKPolylineRenderer alloc] initWithPolyline:(MKPolyline *)overlay];
        ((MKPolylineRenderer *)renderer).strokeColor = [UIColor blackColor];
        ((MKPolylineRenderer *)renderer).lineWidth = 4.0f;
        //((MKPolylineRenderer *)renderer).descript
        
    }
    
        // polygon
    else if ([overlay isKindOfClass:[MKPolygon class]]) {
        renderer = [[MKPolygonRenderer alloc] initWithPolygon:(MKPolygon *)overlay];
        ((MKPolygonRenderer *)renderer).strokeColor = [UIColor redColor];
        ((MKPolygonRenderer *)renderer).fillColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.5f];
        ((MKPolygonRenderer *)renderer).lineWidth = 2.0f;
    }
    
    renderer.alpha = 0.7;
    
    return renderer;
        
    }// else
    
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)backbtnPressed:(UIButton *)button {
    //NSLog(@"Button Pressed");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



//- (IBAction)btnClick:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
