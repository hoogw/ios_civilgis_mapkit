//
//  ViewController.m
//  ZLNavigationControllerDemo
//
//  Created by zhaoliang on 15/12/9.
//  Copyright © 2015年 zhao. All rights reserved.
//

#import "ViewController.h"
#import "ZLNavTabBarController.h"
#import "ZLTableViewController.h"
#import "ZLTestViewController.h"
#import "ZLCommonConst.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
//     Do any additional setup after loading the view, typically from a nib.
    
    
    ZLTableViewController *oneViewController = [[ZLTableViewController alloc] init];
    oneViewController.area = @"city";
    oneViewController.content = @[@"zoning",@"parcels",@"address",@"streets",@"general_land_use",@"parks",@"schools",@"law_beat",@"law_district",@"neighbor",@"law_geoproximity",@"law_reportarea",@"fire_district",@"fire_geoproximity",@"fire_agency",@"fire_station_boundary"];
    oneViewController.title = @"city";
    oneViewController.view.backgroundColor = [UIColor clearColor];
    
    
    
    ZLTableViewController *twoViewController = [[ZLTableViewController alloc] init];
    twoViewController.area = @"Santa_Monica";
    twoViewController.content = @[@"Zoning",@"Bike_Route",@"Parcels",@"Streets",@"Buildings",@"SpeedLimit", @"Streets_Sweeping"];
    twoViewController.title = @"Santa_Monica";
    twoViewController.view.backgroundColor = [UIColor clearColor];
    
    
    
    
    ZLTableViewController *threeViewController = [[ZLTableViewController alloc] init];
    threeViewController.area = @"Palo_Alto";
    threeViewController.content = @[@"Zoning",@"Address",@"Parcels",@"Streets",@"Building",@"PAN_Areas",@"Right_of_way"];
    threeViewController.title = @"Palo_Alto";
    threeViewController.view.backgroundColor = [UIColor clearColor];
    
    
    
    
    ZLTableViewController *fourViewController = [[ZLTableViewController alloc] init];
    fourViewController.area = @"Newport_Beach";
    fourViewController.content = @[@"Zoning",@"Address",@"Parcels",@"Streets",@"Right_Of_Way",@"Parks",@"General_Land_Use"];
    fourViewController.title = @"Newport_Beach";
    fourViewController.view.backgroundColor = [UIColor clearColor];
    
    
    
    
    ZLTableViewController *fiveViewController = [[ZLTableViewController alloc] init];
    fiveViewController.area = @"Shoreline";
    fiveViewController.content = @[@"Zoning",@"Land_Use_Comp_Plan",@"Address_Central",@"Tax_Parcel_Central",@"Buildings",@"Park",@"Neighborhood",@"Monument",@"Land_Mark",@"Encumbrance",@"Art",@"Street",@"Street_Light",@"Sidewalk",@"Pavement_Condition",@"Pavement",@"Intersections",@"Guard_Rail",@"Fence",@"Curb_Ramp",@"Curb",@"Bridge",@"Bike_Facility",@"Railroad"];
    fiveViewController.title = @"Shoreline";
    fiveViewController.view.backgroundColor = [UIColor clearColor];
    
    
    
    ZLTableViewController *sixViewController = [[ZLTableViewController alloc] init];
    sixViewController.area = @"San_Francisco";
    sixViewController.content = @[@"Downtown_Zoning",@"Downtown_Address",@"Downtown_Land_Use",@"Zoning_Districts",@"Height_And_Bulk_Districts",@"Blocks",@"Special_Sign_Districts",@"Special_Sign_Districts_Scenic_Streets",@"Special_Use_Districts",@"Major_Streets",@"Streets",@"Street_Structures",@"Curb_Island",@"Building",@"Zipcode",@"Realtor_Neighborhoods",@"Schools_Public",@"Schools_Public_Address",@"City_Land",@"City_Facility"];
    sixViewController.title = @"San_Francisco";
    sixViewController.view.backgroundColor = [UIColor clearColor];
    
    
    
    ZLTableViewController *sevenViewController = [[ZLTableViewController alloc] init];
    sevenViewController.area = @"Chicago";
    sevenViewController.content = @[@"Zoning",@"Planning_Districts",@"Planning_Regions",@"Community",@"Neighborhoods",@"Industrial_Corridors",@"Enterprises_Communities",@"Landmark_Districts",@"Conservation_Areas",@"Empowerment_Zones",@"Police_Beat",@"Police_District",@"Major_Streets",@"Railroads",@"Streets_Sweeping",@"Bike_Routes",@"Census_Tracts",@"Hospitals",@"Schools",@"High_School_Attendance_Boundaries",@"Parks",@"Hydro",@"Forestry"];
    sevenViewController.title = @"Chicago";
    sevenViewController.view.backgroundColor = [UIColor clearColor];
    
    
    
    
    ZLTableViewController *eightViewController = [[ZLTableViewController alloc] init];
    eightViewController.area = @"Los_Angeles";
    eightViewController.content = @[@"Zoning",@"General_Land_Use",@"Communities",@"Neighborhood_Councils",@"Area_Planning_Commissions",@"Communities_And_Planning_Areas",@"Specific_Plans",@"Other_Districts",@"Historic_Preservation_Overlay_Zone",@"Historic_Cultural_Monuments",@"Federal_Renewal_Community",@"State_Enterprise_Zone",@"Business_Improvement_District",@"Targeted_Neighborhood_Initiative"];
    eightViewController.title = @"Los_Angeles";
    eightViewController.view.backgroundColor = [UIColor clearColor];
    
    
    
    
    
    ZLTableViewController *nightViewController = [[ZLTableViewController alloc] init];
    nightViewController.area = @"county";
    nightViewController.content = @[@"cities",@"rails",@"parks",@"water",@"education_facility",@"hospitals",@"fire_stations"];
    nightViewController.title = @"county";
    nightViewController.view.backgroundColor = [UIColor clearColor];
    
    
    
    ZLTableViewController *tenViewController = [[ZLTableViewController alloc] init];
    tenViewController.area = @"New_York";
    tenViewController.content = @[@"Zone_Districts",@"Commercial_Zone",@"Boroughs",@"Neighborhoods",@"Community_Districts",@"Building_Demolition",@"Building",@"Parks",@"Parking_Lots"];
    tenViewController.title = @"New_York";
    tenViewController.view.backgroundColor = [UIColor clearColor];
    
    
    
    
    ZLNavTabBarController *navTabBarController = [[ZLNavTabBarController alloc] init];
    navTabBarController.subViewControllers = @[oneViewController, twoViewController, threeViewController, fourViewController, fiveViewController, sixViewController, sevenViewController, eightViewController, nightViewController];
    navTabBarController.navTabBarColor = [UIColor clearColor];
    navTabBarController.mainViewBounces = YES;
    navTabBarController.selectedToIndex = 5;
    navTabBarController.unchangedToIndex = 2;
    navTabBarController.showArrayButton = NO;
    [navTabBarController addParentController:self];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
