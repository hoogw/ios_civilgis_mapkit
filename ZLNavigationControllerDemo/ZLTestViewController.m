//
//  ZLTestViewController.m
//  CustomNavigationController
//
//  Created by zhaoliang on 15/11/12.
//  Copyright © 2015年 zhao. All rights reserved.
//


#import "ZLTestViewController.h"
#import "ZLCommonConst.h"


@interface ZLTestViewController ()

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
    

    
}



// ------  Location Manager Delegate Methods  --------
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
   // NSLog(@"%@", [locations lastObject]);
}






#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    
    
    
    if ([overlay isKindOfClass:[MKTileOverlay class]]) {
        
        
        
        return [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
    }
    
    return nil;
}


//-(MKTileOverlayRenderer *)mapView:(MKMapView*)mapView rendererForOverlay:(id<MKOverlay>)overlay {
//    
//    
//    NSLog(@"URL : %@", [overlay canReplaceMapContent]);
//
//    
//    return [[MKTileOverlayRenderer alloc] initWithOverlay:overlay];
//    
//}




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
