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
#import "UIView+Toast.h"




@interface ZLTestViewController ()  <MKMapViewDelegate>

@property (readwrite, nonatomic, strong) MKMapView *mapView;
//@property (nonatomic, weak) UIView *nightView;



@end

@implementation ZLTestViewController{
    
    
    

    
}


//%%%%%%%%%%%%%%%%%  tap %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

- (double)distanceOfPoint:(MKMapPoint)pt toPoly:(MKPolyline *)poly
{
    double distance = MAXFLOAT;
    for (int n = 0; n < poly.pointCount - 1; n++) {
        
        MKMapPoint ptA = poly.points[n];
        MKMapPoint ptB = poly.points[n + 1];
        
        double xDelta = ptB.x - ptA.x;
        double yDelta = ptB.y - ptA.y;
        
        if (xDelta == 0.0 && yDelta == 0.0) {
            
            // Points must not be equal
            continue;
        }
        
        double u = ((pt.x - ptA.x) * xDelta + (pt.y - ptA.y) * yDelta) / (xDelta * xDelta + yDelta * yDelta);
        MKMapPoint ptClosest;
        if (u < 0.0) {
            
            ptClosest = ptA;
        }
        else if (u > 1.0) {
            
            ptClosest = ptB;
        }
        else {
            
            ptClosest = MKMapPointMake(ptA.x + u * xDelta, ptA.y + u * yDelta);
        }
        
        distance = MIN(distance, MKMetersBetweenMapPoints(ptClosest, pt));
    }
    
    return distance;
}





#define MAX_DISTANCE_PX 22.0f










-(void)handleMapTap:(UIGestureRecognizer*)tap{
    
    MKMapView *mapView = (MKMapView *)tap.view;
    
    
    CGPoint tapPoint = [tap locationInView:mapView];
    
    
    //----- polyline calculate------
    
    CGPoint ptB = CGPointMake(tapPoint.x + MAX_DISTANCE_PX, tapPoint.y);
    
    CLLocationCoordinate2D coordA = [mapView convertPoint:tapPoint toCoordinateFromView:mapView];
    CLLocationCoordinate2D coordB = [mapView convertPoint:ptB toCoordinateFromView:mapView];

    double maxMeters = MKMetersBetweenMapPoints(MKMapPointForCoordinate(coordA), MKMapPointForCoordinate(coordB));

    
    float nearestDistance = MAXFLOAT;
    MKPolyline *nearestPoly = nil;
    
    //  ------ end polyline calculate-----------
    
    
   NSLog(@"tapPoint = %f,%f",tapPoint.x, tapPoint.y);
    
    CLLocationCoordinate2D tapCoord = [mapView convertPoint:tapPoint toCoordinateFromView:mapView];
    MKMapPoint mapPoint = MKMapPointForCoordinate(tapCoord);
    CGPoint mapPointAsCGP = CGPointMake(mapPoint.x, mapPoint.y);
    
    for (id<MKOverlay> overlay in mapView.overlays) {
        
        
        
        // polygon
        if([overlay isKindOfClass:[MKPolygon class]]){
            MKPolygon *polygon = (MKPolygon*) overlay;
            
            CGMutablePathRef mpr = CGPathCreateMutable();
            
            MKMapPoint *polygonPoints = polygon.points;
            
            for (int p=0; p < polygon.pointCount; p++){
                MKMapPoint mp = polygonPoints[p];
                if (p == 0)
                    CGPathMoveToPoint(mpr, NULL, mp.x, mp.y);
                else
                    CGPathAddLineToPoint(mpr, NULL, mp.x, mp.y);
            }
            
            if(CGPathContainsPoint(mpr , NULL, mapPointAsCGP, FALSE)){
                
                
                 NSLog(@"#### tap ##### found  polygon: %@", @"#### tap ##### found  polygon");
                
                CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
                CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
                CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
               UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
                
                //UIColor *color = [UIColor yellowColor];
                //NSLog(@"hue:%f  sat:%f bri:%f", hue,saturation,brightness);
                
                
                MKPolygonRenderer    *renderer =(MKPolygonRenderer*) [mapView rendererForOverlay:overlay];

                renderer.lineWidth = 3.0f;
                renderer.strokeColor = color;
                [renderer invalidatePath];
                
                
                
                
                // show properties
                
                
                
                NSLog(@"title......%@", polygon.title);
               // NSLog(@"description......%@", polygon.description);
                
                [mapView makeToast:polygon.title];
                
                
                
                break;
                
            }//if
            
            CGPathRelease(mpr);
        }//if
        
        
        
        
        if([overlay isKindOfClass:[MKPolyline class]]){
            // ... get the distance ...
            float distance = [self distanceOfPoint:MKMapPointForCoordinate(tapCoord)
                                            toPoly:overlay];
            
            // ... and find the nearest one
            if (distance < nearestDistance) {
                
                nearestDistance = distance;
                nearestPoly = overlay;
            }
        
        }//if

        
        
        
        
        
        
    }// for
    
    
    
    
    if (nearestDistance <= maxMeters) {
        
        NSLog(@"Touched poly: %@\n"
              "    distance: %f", nearestPoly, nearestDistance);
        
        
        
        CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        
        //UIColor *color = [UIColor yellowColor];
        //NSLog(@"hue:%f  sat:%f bri:%f", hue,saturation,brightness);
        
        
        MKPolylineRenderer    *renderer =(MKPolylineRenderer*) [mapView rendererForOverlay:nearestPoly];
        
        renderer.lineWidth = 4.0f;
        renderer.strokeColor = color;
        [renderer invalidatePath];
        
        
        
        // show properties
        [mapView makeToast:nearestPoly.title];
        
        
        
    }
    
    
    
    
}// handle map tap method



// not in use, this is another way
- (void)mapTapped:(UITapGestureRecognizer *)recognizer
{
    
    MKMapView *mapView = (MKMapView *)recognizer.view;
    
    CGPoint tapPoint = [recognizer locationInView:mapView];
    NSLog(@"tapPoint = %f,%f",tapPoint.x, tapPoint.y);
    
    //convert screen CGPoint tapPoint to CLLocationCoordinate2D...
    CLLocationCoordinate2D tapCoordinate = [mapView convertPoint:tapPoint toCoordinateFromView:mapView];
    
    //convert CLLocationCoordinate2D tapCoordinate to MKMapPoint...
    MKMapPoint point = MKMapPointForCoordinate(tapCoordinate);
    
    if (mapView.overlays.count > 0 ) {
        for (id<MKOverlay> overlay in mapView.overlays)
        {
            
            if ([overlay isKindOfClass:[MKCircle class]])
            {
                MKCircle *circle = overlay;
                MKCircleRenderer *circleRenderer = (MKCircleRenderer *)[mapView rendererForOverlay:circle];
                
                //convert MKMapPoint tapMapPoint to point in renderer's context...
                CGPoint datpoint = [circleRenderer pointForMapPoint:point];
                [circleRenderer invalidatePath];
                
                
                if (CGPathContainsPoint(circleRenderer.path, nil, datpoint, false)){
                    
                    NSLog(@"tapped on overlay");
                    break;
                }
                
            }
            
            
            if ([overlay isKindOfClass:[MKPolygon class]])
            {
                
                NSLog(@"#### tap polygon #####  : %@", @"22222222222222222222222");
                
                
                
                
            }
            
            
            
            
            
            
            
        }
        
    }
}//


//%%%%%%%%%%%%%%%%% End tap %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    
    
    
    
    
    //########### init location ##########
    
    
    NSMutableArray *city = [NSMutableArray arrayWithObjects:@"city", @"33.65992448007282", @"-117.91505813598633", @"13", nil];
    
    NSMutableArray *county = [NSMutableArray arrayWithObjects:@"county", @"33.693495", @"-117.793350", @"11", nil];
    
    NSMutableArray *Newport_Beach = [NSMutableArray arrayWithObjects:@"Newport_Beach", @"33.616478", @"-117.875748", @"13", nil];
    NSMutableArray *Santa_Monica = [NSMutableArray arrayWithObjects:@"Santa_Monica", @"34.023143", @"-118.475275", @"14", nil];
    
    NSMutableArray *Los_Angeles = [NSMutableArray arrayWithObjects:@"Los_Angeles", @"34.043556504127444", @"-118.24928283691406", @"11", nil];
    NSMutableArray *San_Francisco = [NSMutableArray arrayWithObjects:@"San_Francisco", @"37.77559951996456", @"-122.41722106933594", @"12", nil];
    NSMutableArray *New_York = [NSMutableArray arrayWithObjects:@"New_York", @"40.753499070431374", @"-73.98948669433594", @"11", nil];
    NSMutableArray *Chicago = [NSMutableArray arrayWithObjects:@"Chicago", @"41.874673839758024", @"-87.63175964355469", @"11", nil];
    NSMutableArray *Denver = [NSMutableArray arrayWithObjects:@"Denver", @"39.74336227378035", @"-104.99101638793945", @"12", nil];
    NSMutableArray *Los_Angeles_County = [NSMutableArray arrayWithObjects:@"Los_Angeles_County", @"34.05607276338366", @"-118.26370239257812", @"10", nil];
    NSMutableArray *New_York_Bronx = [NSMutableArray arrayWithObjects:@"New_York_Bronx", @"40.85537053192496", @"-73.87687683105469", @"13", nil];
    NSMutableArray *New_York_Brooklyn = [NSMutableArray arrayWithObjects:@"New_York_Brooklyn", @"40.65433643720422", @"-73.95206451416016", @"13", nil];
    NSMutableArray *New_York_Manhattan = [NSMutableArray arrayWithObjects:@"New_York_Manhattan", @"40.764421348741976", @"-73.97815704345703", @"13", nil];
    NSMutableArray *New_York_Queens = [NSMutableArray arrayWithObjects:@"New_York_Queens", @"40.72280306615735", @"-73.79997253417969", @"13", nil];
    NSMutableArray *New_York_Staten_Island = [NSMutableArray arrayWithObjects:@"New_York_Staten_Island", @"40.60300547512703", @"-74.1353988647461", @"13", nil];
    NSMutableArray *Arura = [NSMutableArray arrayWithObjects:@"Arura", @"39.723296392333026", @"-104.84081268310547", @"13", nil];
    NSMutableArray *Bakersfield = [NSMutableArray arrayWithObjects:@"Bakersfield", @"39.818557296839344", @"-104.501953125", @"13", nil];
    NSMutableArray *Baltimore = [NSMutableArray arrayWithObjects:@"Baltimore", @"35.44808511462123", @"-118.78177642822266", @"13", nil];
    NSMutableArray *Orlando = [NSMutableArray arrayWithObjects:@"Orlando", @"39.90657598772841", @"-104.59259033203125", @"13", nil];
    NSMutableArray *Palo_Alto = [NSMutableArray arrayWithObjects:@"Palo_Alto", @"37.4426999532675", @"-122.15492248535156", @"13", nil];
    NSMutableArray *Philadelphia = [NSMutableArray arrayWithObjects:@"Philadelphia", @"37.49529038649112", @"-122.10411071777344", @"13", nil];
    NSMutableArray *Portland = [NSMutableArray arrayWithObjects:@"Portland", @"40.13794057716276", @"-74.95491027832031", @"13", nil];
    NSMutableArray *San_Jose = [NSMutableArray arrayWithObjects:@"San_Jose", @"45.58473142874248", @"-122.46803283691406", @"13", nil];
    NSMutableArray *Seattle = [NSMutableArray arrayWithObjects:@"Seattle", @"37.45469273789926", @"-121.82052612304688", @"13", nil];
    NSMutableArray *Shoreline = [NSMutableArray arrayWithObjects:@"Shoreline", @"47.75479043701335", @"-122.34392166137695", @"13", nil];
    NSMutableArray *Stockton = [NSMutableArray arrayWithObjects:@"Stockton", @"47.77936670249429", @"-122.27182388305664", @"13", nil];
    NSMutableArray *Washington_DC = [NSMutableArray arrayWithObjects:@"Washington_DC", @"38.063635376296816", @"-121.18932723999023", @"13", nil];
    
    
    
    NSMutableDictionary *area_info= [[NSMutableDictionary alloc]init];
    
    [area_info setObject:city forKey:@"city"];
    [area_info setObject:county forKey:@"county"];
    [area_info setObject:Newport_Beach forKey:@"Newport_Beach"];
    [area_info setObject:Santa_Monica forKey:@"Santa_Monica"];
    [area_info setObject:Los_Angeles forKey:@"Los_Angeles"];
    [area_info setObject:San_Francisco forKey:@"San_Francisco"];
    [area_info setObject:New_York forKey:@"New_York"];
    [area_info setObject:Chicago forKey:@"Chicago"];
    [area_info setObject:Denver forKey:@"Denver"];
    [area_info setObject:Los_Angeles_County forKey:@"Los_Angeles_County"];
    [area_info setObject:New_York_Bronx forKey:@"New_York_Bronx"];
    [area_info setObject:New_York_Brooklyn forKey:@"New_York_Brooklyn"];
    [area_info setObject:New_York_Manhattan forKey:@"New_York_Manhattan"];
    [area_info setObject:New_York_Queens forKey:@"New_York_Queens"];
    [area_info setObject:New_York_Staten_Island forKey:@"New_York_Staten_Island"];
    [area_info setObject:Arura forKey:@"Arura"];
    [area_info setObject:Bakersfield forKey:@"Bakersfield"];
    [area_info setObject:Baltimore forKey:@"Baltimore"];
    [area_info setObject:Orlando forKey:@"Orlando"];
    [area_info setObject:Palo_Alto forKey:@"Palo_Alto"];
    [area_info setObject:Philadelphia forKey:@"Philadelphia"];
    [area_info setObject:Portland forKey:@"Portland"];
    [area_info setObject:San_Jose forKey:@"San_Jose"];
    [area_info setObject:Seattle forKey:@"Seattle"];
    [area_info setObject:Shoreline forKey:@"Shoreline"];
    [area_info setObject:Stockton forKey:@"Stockton"];
    [area_info setObject:Washington_DC forKey:@"Washington_DC"];
    
    
    //###############  End  init location ##########

    
    
    
    
    
    
    
    
    
    
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
    
    
    NSMutableArray *_init_loc = area_info[_area];
    
//     NSString *lat=@"33.6599244";
//     NSString *lng=@"-117.915058135";
    NSString *lat=[_init_loc objectAtIndex:1];
    NSString *lng=[_init_loc objectAtIndex:2];
    
    
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
    
    
    
    
    
    
    
    
    
    
    
    // --------   add tap gesture ----------
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMapTap:)];
    tap.cancelsTouchesInView = NO;
    tap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] init];
    tap2.cancelsTouchesInView = NO;
    tap2.numberOfTapsRequired = 2;
    
//    [mapView addGestureRecognizer:tap2];
    [mapView addGestureRecognizer:tap];
//    [tap requireGestureRecognizerToFail:tap2]; // Ignore single tap if the user actually double taps
    
    
    // Not in use, this is another way
  //  [mapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped:)]];
    
    // --------- End tap gesture ---------------
    
    
    
    
    
    
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

   
    
    
    [self add_geojson_layer:_url_arealimit  toMap: mapView ];
    
    //-------------- end area boundary -------------------
    
    
    
    
    
    
    
    
    
    
    // first time get geojson
    
    NSString * _url_api = [self get_map_bound:mapView];
    
   // NSLog(@"----- json_api -----: %@", _url_api);
    
    [self add_geojson_layer:_url_api toMap: mapView ];
    
    
    
    
}// view did load method






// =============== add geojson layer ===========

- (void) add_geojson_layer:(NSString*)_url toMap:(MKMapView *)mapview_{

    
    
    NSLog(@"*****  URL  ****: %@", _url);
    
    
    NSURL *msgURL = [NSURL URLWithString:_url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    
    
    NSURLSessionTask *messageTask = [session dataTaskWithURL:msgURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
         NSString *retString = [NSString stringWithUTF8String:[data bytes]];
        
        
         NSLog(@"    #####json#####    : %@", retString);
        
        if (retString.length < 20){
            
            // return total number
            
            // show properties
            [mapview_ makeToast:retString];
            
        }
            
        
        
        else{
        // return geojson
        
        NSDictionary *geoJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *shapes = [GeoJSONSerialization shapesFromGeoJSONFeatureCollection:geoJSON error:nil];
        
        for (MKShape *shape in shapes) {
            if ([shape isKindOfClass:[MKPointAnnotation class]]) {
                
                [mapview_ addAnnotation:shape];
            } else if ([shape conformsToProtocol:@protocol(MKOverlay)]) {
                
                [mapview_ addOverlay:(id <MKOverlay>)shape];
                
            }
        }// for shapes
        
    }//else

    
    }];// message session task
     [messageTask resume];
    
    
    
}// add geojson method



// =========== End add geojson layer ==================










    //............. get map bound ................
                                     
-(NSString *)get_map_bound:(MKMapView *)mapview_
                                     {
                                         
                                         MKMapRect mRect = mapview_.visibleMapRect;
                                         
                                         
                                         
  // 1 way works
//                                         MKMapPoint neMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), mRect.origin.y);
//                                         MKMapPoint swMapPoint = MKMapPointMake(mRect.origin.x, MKMapRectGetMaxY(mRect));
//                                         
//                                         CLLocationCoordinate2D neCoord = MKCoordinateForMapPoint(neMapPoint);
//                                         CLLocationCoordinate2D swCoord = MKCoordinateForMapPoint(swMapPoint);
 // end 1 way works
               
                                         
                                         
                                         
     // 2 way works

                                         
                                         CLLocationCoordinate2D  swCoord= [self getSWCoordinate:mRect];
                                         CLLocationCoordinate2D neCoord = [self getNECoordinate:mRect];
    // end 2 way works
                                         
                                         NSNumber *sw_lat = [NSNumber numberWithDouble:swCoord.latitude ];
                                         NSNumber *sw_lng = [NSNumber numberWithDouble:swCoord.longitude];
                                         NSNumber *ne_lat =  [NSNumber numberWithDouble:neCoord.latitude];
                                         NSNumber *ne_lng =[NSNumber numberWithDouble:neCoord.longitude];
                                         
                                         
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
        ((MKPolylineRenderer *)renderer).strokeColor = [UIColor blueColor];
        ((MKPolylineRenderer *)renderer).lineWidth = 4.0f;
        //((MKPolylineRenderer *)renderer).descript
        
    }
    
        // polygon
    else if ([overlay isKindOfClass:[MKPolygon class]]) {
        renderer = [[MKPolygonRenderer alloc] initWithPolygon:(MKPolygon *)overlay];
        ((MKPolygonRenderer *)renderer).strokeColor = [UIColor redColor];
        ((MKPolygonRenderer *)renderer).fillColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.0f];
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
