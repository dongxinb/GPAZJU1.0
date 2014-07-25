//
//  DAboutViewController.m
//  GradeZJU
//
//  Created by 董鑫宝 on 13-8-8.
//  Copyright (c) 2013年 董鑫宝. All rights reserved.
//
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#import "DAboutViewController.h"
@interface DAboutViewController ()

@end

@implementation DAboutViewController
@synthesize bottomBar,textOut;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (iPhone5) {
        self = [super initWithNibName:@"DAboutViewController" bundle:nibBundleOrNil];
    }else{
        self = [super initWithNibName:@"DAboutViewController35" bundle:nibBundleOrNil];
    }
    
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    //[textOut.layer]
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
