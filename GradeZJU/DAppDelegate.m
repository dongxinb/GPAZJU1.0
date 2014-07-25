//
//  DAppDelegate.m
//  GradeZJU
//
//  Created by 董鑫宝 on 13-8-5.
//  Copyright (c) 2013年 董鑫宝. All rights reserved.
//

#import "DAppDelegate.h"
#import "DViewController.h"
#import "PKRevealController.h"
#import "DLeftViewController.h"
#import "DLoginViewController.h"
#import "DWifiViewController.h"
#import "SIAlertView.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation DAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [AVOSCloud setApplicationId:@""
                      clientKey:@""];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [AVAnalytics setCrashReportEnabled:YES];
    [AVAnalytics start];
    
    [AVAnalytics updateOnlineConfigWithBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            BOOL tempMode;
            if ([[dict objectForKey:@"tempMode"] isEqualToString:@"1"]) {
                tempMode = YES;
            }else {
                tempMode = NO;
            }
            
            [[NSUserDefaults standardUserDefaults] setBool:tempMode forKey:@"mode"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];

    
    
    // Register for push notifications
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    
    if(![[NSUserDefaults standardUserDefaults]boolForKey:@"newVersion1.2"]){
        NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
        [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
        [[NSUserDefaults standardUserDefaults]setObject:deviceToken forKey:@"deviceToken"];
        [self newVersion];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"newVersion1.2"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UITableViewController *viewController=[[DViewController alloc]init];
    UIViewController *leftViewController = [[DLeftViewController alloc] init];
    UIViewController *rightViewController = [[DWifiViewController alloc] init];
    //viewController=(DViewController *)[PKRevealController revealControllerWithFrontViewController:viewController leftViewController:leftViewController options:nil];
    viewController = (DViewController *)[PKRevealController revealControllerWithFrontViewController:viewController leftViewController:leftViewController rightViewController:rightViewController options:nil];
    
    self.window.rootViewController = viewController;
    
    [self.window makeKeyAndVisible];
    
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo) {
        [AVPush handlePush:userInfo];
        [self receiveGradePush:userInfo];
        AVInstallation *currentInstallation = [AVInstallation currentInstallation];
        if (currentInstallation.badge != 0) {
            currentInstallation.badge = 0;
            //[currentInstallation saveEventually];
            [currentInstallation saveInBackground];
        }
        //[self handleRemoteNotification:application userInfo:userInfo];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.window.frame =  CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height-20);
        UIApplication *myApp = [UIApplication sharedApplication];
        [myApp setStatusBarStyle: UIStatusBarStyleLightContent];
    }
    
    return YES;
    
    // Step 5: Take a look at the Left/RightDemoViewController files. They're self-sufficient as to the configuration of their reveal widths for instance.
    
    // Override point for customization after application launch.

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
    [[NSUserDefaults standardUserDefaults]setObject:currentInstallation.deviceToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"]);
    
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [AVPush handlePush:userInfo];
    [self receiveGradePush:userInfo];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
    //[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
- (void)receiveGradePush:(NSDictionary *)userInfo{
    [[SIAlertView appearance]setTitleFont:[UIFont systemFontOfSize:16]];
    [[SIAlertView appearance]setMessageFont:[UIFont systemFontOfSize:15]];
    [[SIAlertView appearance]setViewBackgroundColor:[UIColor colorWithRed:1. green:1. blue:1. alpha:1.]];
    [[SIAlertView appearance]setButtonFont:[UIFont systemFontOfSize:17]];
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"GPA.PUSH" andMessage:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
    //    [alertView addButtonWithTitle:@"Cancel"
    //                             type:SIAlertViewButtonTypeCancel
    //                          handler:^(SIAlertView *alertView) {
    //                              NSLog(@"Cancel Clicked");
    //                          }];
    [alertView addButtonWithTitle:@"我去看看"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"OK Clicked");
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    [alertView show];
    
}

- (void)newVersion
{
    [[SIAlertView appearance]setTitleFont:[UIFont systemFontOfSize:16]];
    [[SIAlertView appearance]setMessageFont:[UIFont systemFontOfSize:15]];
    [[SIAlertView appearance]setViewBackgroundColor:[UIColor colorWithRed:1. green:1. blue:1. alpha:1.]];
    [[SIAlertView appearance]setButtonFont:[UIFont systemFontOfSize:17]];
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"GPA.ZJU版本更新v1.2" andMessage:@"1.完善成绩推送功能.\n2.默认关闭推送成绩.\n3.修复若干推送BUG.\n4.优化刷取成绩速度."];
    //    [alertView addButtonWithTitle:@"Cancel"
    //                             type:SIAlertViewButtonTypeCancel
    //                          handler:^(SIAlertView *alertView) {
    //                              NSLog(@"Cancel Clicked");
    //                          }];
    [alertView addButtonWithTitle:@"我知道了"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    [alertView show];
    
}

@end
