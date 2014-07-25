//
//  DDetailViewController.m
//  GradeZJU
//
//  Created by 董鑫宝 on 13-8-22.
//  Copyright (c) 2013年 董鑫宝. All rights reserved.
//
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#import "DDetailViewController.h"
#import <AVOSCloud/AVOSCloud.h>
@interface DDetailViewController ()

@end

@implementation DDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (iPhone5) {
        self = [super initWithNibName:@"DDetailViewController" bundle:nibBundleOrNil];
    }else{
        self = [super initWithNibName:@"DDetailViewController35" bundle:nibBundleOrNil];
    }
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AVAnalytics beginLogPageView:@"Detail1.0"];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"Detail1.0"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    gtld.text=[NSString stringWithFormat:@"%.1f",[[NSUserDefaults standardUserDefaults]doubleForKey:@"gtld"]];
    jsj.text=[NSString stringWithFormat:@"%.1f",[[NSUserDefaults standardUserDefaults]doubleForKey:@"jsj"]];
    lswh.text=[NSString stringWithFormat:@"%.1f",[[NSUserDefaults standardUserDefaults]doubleForKey:@"lswh"]];
    wxys.text=[NSString stringWithFormat:@"%.1f",[[NSUserDefaults standardUserDefaults]doubleForKey:@"wxys"]];
    kxyj.text=[NSString stringWithFormat:@"%.1f",[[NSUserDefaults standardUserDefaults]doubleForKey:@"kxyj"]];
    jjsh.text=[NSString stringWithFormat:@"%.1f",[[NSUserDefaults standardUserDefaults]doubleForKey:@"jjsh"]];
    tshx.text=[NSString stringWithFormat:@"%.1f",[[NSUserDefaults standardUserDefaults]doubleForKey:@"tshx"]];
    xsyt.text=[NSString stringWithFormat:@"%.1f",[[NSUserDefaults standardUserDefaults]doubleForKey:@"xsyt"]];
    jssj.text=[NSString stringWithFormat:@"%.1f",[[NSUserDefaults standardUserDefaults]doubleForKey:@"jssj"]];
    rwskl.text=[NSString stringWithFormat:@"%.1f",[gtld.text doubleValue]+[lswh.text doubleValue]+[wxys.text doubleValue]+[jjsh.text doubleValue]];
    kxjsl.text=[NSString stringWithFormat:@"%.1f",[kxyj.text doubleValue]+[jssj.text doubleValue]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
