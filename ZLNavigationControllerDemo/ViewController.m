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
    oneViewController.content = @[@"zoning",@"parcels",@"address",@"streets",@"general_land_use"];
    oneViewController.title = @"city";
    oneViewController.view.backgroundColor = [UIColor clearColor];
    
    
    
    ZLTableViewController *twoViewController = [[ZLTableViewController alloc] init];
    twoViewController.area = @"Santa_Monica";
    twoViewController.content = @[@"Zoning",@"Parcels",@"Streets",@"General_land_use"];
    twoViewController.title = @"Santa_Monica";
    twoViewController.view.backgroundColor = [UIColor clearColor];
    
    
    
    
    ZLTableViewController *threeViewController = [[ZLTableViewController alloc] init];
    threeViewController.area = @"Palo_Alto";
    threeViewController.content = @[@"Zoning",@"Parcels",@"Address",@"Streets",@"General_land_use",@"Schools",@"Parks",@"Beat",@"District"];
    threeViewController.title = @"Palo_Alto";
    threeViewController.view.backgroundColor = [UIColor clearColor];
    
    
    
    
    ZLTableViewController *fourViewController = [[ZLTableViewController alloc] init];
    fourViewController.area = @"Newport_Beach";
    fourViewController.content = @[@"Zoning",@"Parcels",@"Address",@"Streets",@"General_land_use"];
    fourViewController.title = @"Newport_Beach";
    fourViewController.view.backgroundColor = [UIColor clearColor];
    
    
    
    
    ZLTableViewController *fiveViewController = [[ZLTableViewController alloc] init];
    fiveViewController.area = @"Shoreline";
    fiveViewController.content = @[@"zoning",@"Parcels",@"Address",@"Streets",@"Beat",@"District"];
    fiveViewController.title = @"Shoreline";
    fiveViewController.view.backgroundColor = [UIColor clearColor];
    
    
    
    ZLTableViewController *sixViewController = [[ZLTableViewController alloc] init];
    sixViewController.area = @"San_Francisco";
    sixViewController.content = @[@"Zoning",@"Parcels",@"Address",@"Streets",@"General_land_use",@"Schools",@"Parks"];
    sixViewController.title = @"San_Francisco";
    sixViewController.view.backgroundColor = [UIColor clearColor];
    
    
    
    ZLTableViewController *sevenViewController = [[ZLTableViewController alloc] init];
    sevenViewController.area = @"Chicago";
    sevenViewController.content = @[@"Zoning",@"Parcels",@"Address",@"Streets",@"General_land_use",@"Schools",@"Parks",@"Beat",@"District"];
    sevenViewController.title = @"Chicago";
    sevenViewController.view.backgroundColor = [UIColor clearColor];
    
    
    
    
    ZLTableViewController *eightViewController = [[ZLTableViewController alloc] init];
    eightViewController.area = @"Los_Angeles";
    eightViewController.content = @[@"Zoning",@"Parcels",@"Address",@"Streets",@"General_land_use",@"Schools",@"Parks",@"Beat",@"District"];
    eightViewController.title = @"Los_Angeles";
    eightViewController.view.backgroundColor = [UIColor clearColor];
    
    
    
    
    
    ZLTableViewController *nightViewController = [[ZLTableViewController alloc] init];
    nightViewController.area = @"Stockton";
    nightViewController.content = @[@"Zoning",@"Parcels",@"Address",@"Streets",@"General_land_use",@"Schools",@"Parks",@"Beat",@"District"];
    nightViewController.title = @"Stockton";
    nightViewController.view.backgroundColor = [UIColor clearColor];
    
    
    
    
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
