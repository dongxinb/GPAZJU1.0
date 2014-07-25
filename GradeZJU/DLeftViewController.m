//
//  DLeftViewController.m
//  GradeZJU
//
//  Created by Desolate on 13-8-13.
//  Copyright (c) 2013年 董鑫宝. All rights reserved.
//
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#import "DLeftViewController.h"
#import "PKRevealController.h"
#import "DLoginViewController.h"
#import "DViewController.h"
#import "DAboutViewController.h"
#import "DAppDelegate.h"
#import "DSettingViewController.h"
#import "DDetailViewController.h"
#import "DWifiViewController.h"
@interface DLeftViewController ()

@end

@implementation DLeftViewController
@synthesize xm;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (iPhone5) {
        self = [super initWithNibName:@"DLeftViewController" bundle:nibBundleOrNil];
    }else{
        self = [super initWithNibName:@"DLeftViewController35" bundle:nibBundleOrNil];
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (rootController==nil) {
        rootController=self.revealController.frontViewController;
    }
    if (didLogin==YES) {
        [loginbutton setTitle:@"注    销" forState:UIControlStateNormal];
        labelname.text=[[NSUserDefaults standardUserDefaults]stringForKey:@"xm"];
        labelxh.text=[[NSUserDefaults standardUserDefaults]stringForKey:@"name"];
        
    }else{
        [loginbutton setTitle:@"登    录" forState:UIControlStateNormal];
        labelxh.text=@"";
        labelname.text=@"未登录";
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    //if (loginController==nil) {
        UIViewController *login=[[DLoginViewController alloc]init];
        [self.revealController setFrontViewController:login];
        loginController=self.revealController.frontViewController;
    //}
    [self.revealController setFrontViewController:loginController];
    [self.revealController showViewController:self.revealController.frontViewController];
}

- (IBAction)grade:(id)sender {
    if (didLogin==YES){
        //DViewController *grade =[[DViewController alloc]init];
        [self.revealController setFrontViewController:rootController];
        [self.revealController showViewController:self.revealController.frontViewController];
    }else{
        DViewController *grade =[[DViewController alloc]init];
        [self.revealController setFrontViewController:grade];
        [self.revealController showViewController:self.revealController.frontViewController];
        rootController=grade;
    }
//    [self.revealController setFrontViewController:rootController];
//    [self.revealController showViewController:self.revealController.frontViewController];
}

- (IBAction)setting:(id)sender {
    UIViewController *setting =[[DSettingViewController alloc]init];
    [self.revealController setFrontViewController:setting];
    [self.revealController showViewController:self.revealController.frontViewController];
}

- (IBAction)statistics:(id)sender {
    UIViewController *detail=[[DDetailViewController alloc]init];
    [self.revealController setFrontViewController:detail];
    [self.revealController showViewController:self.revealController.frontViewController];
}

- (IBAction)wifiLogin:(UIButton *)sender {
    UIViewController *wifi = [[DWifiViewController alloc]init];
    [self.revealController setFrontViewController:wifi];
    [self.revealController showViewController:self.revealController.frontViewController];
}

@end
