//
//  DSettingViewController.m
//  GradeZJU
//
//  Created by Desolate on 13-8-14.
//  Copyright (c) 2013年 董鑫宝. All rights reserved.
//
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#import "DSettingViewController.h"
#import "SevenSwitch.h"
#import "SIAlertView.h"
#import "DLeftViewController.h"
#import "DViewController.h"
#import "PKRevealController.h"
#import "DLoginViewController.h"
#import "DAboutViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "DBugViewController.h"
@interface DSettingViewController ()

@end

@implementation DSettingViewController
@synthesize clearButton,indicator;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (iPhone5) {
        self = [super initWithNibName:@"DSettingViewController" bundle:nibBundleOrNil];
    }else{
        self = [super initWithNibName:@"DSettingViewController35" bundle:nibBundleOrNil];
    }
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AVAnalytics beginLogPageView:@"Settings1.0"];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"Settings1.0"];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self switchLoad];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)switchLoad
{
    SevenSwitch *mySwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(0, 0, 65, 25)];
    if (iPhone5) {
        mySwitch.center=CGPointMake(230, 172);
    }else{
        mySwitch.center = CGPointMake(230,139);
    }
    [mySwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    mySwitch.offImage = [UIImage imageNamed:@"cross.png"];
    mySwitch.onImage = [UIImage imageNamed:@"check.png"];
    mySwitch.onColor = [UIColor colorWithRed:51./255. green:204./255. blue:255./255. alpha:1.0];
    mySwitch.isRounded = NO;
    [self.view addSubview:mySwitch];
    BOOL push=[[NSUserDefaults standardUserDefaults]boolForKey:@"Push"];
    if (push==YES) {
        [mySwitch setOn:YES animated:YES];
    }else{
        [mySwitch setOn:NO animated:YES];     
    }
}

- (void)switchChanged:(SevenSwitch *)sender {
    [_pushIndicator startAnimating];
    sender.enabled = NO;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"login"] == NO) {
        [self showNotification:@"您还没有登录呢，推送开启失败. :("];
        [sender setOn:NO];
        sender.enabled = YES;
        [_pushIndicator stopAnimating];
        return;
    }
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"login"]==NO) {
        [_pushIndicator stopAnimating];
        sender.enabled = YES;
        return;
    }
    if (sender.on) {
        NSLog(@"Push ON");
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"]) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Push"];
            AVObject *stu = [AVObject objectWithClassName:@"studentPush"];
            [stu setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"] forKey:@"deviceToken"];
            [stu setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"password"] forKey:@"password"];
            [stu setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"name"] forKey:@"stuID"];
            //[stu saveInBackground];
//            [stu saveEventually];
            [stu saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self showNotification:@"开启推送成功。:)"];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Push"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [_pushIndicator stopAnimating];
                    sender.enabled = YES;
                }else{
                    [self showNotification:@"推送开启失败，请检查网络设置。:("];
                    [sender setOn:NO animated:YES];
                    [_pushIndicator stopAnimating];
                    sender.enabled = YES;
                }
            }];
        }
    }else{
        NSLog(@"Push OFF");
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"]length]!=0) {
            AVQuery *query=[AVQuery queryWithClassName:@"studentPush"];
            [query whereKey:@"deviceToken" equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"Push"];
                    //[object deleteInBackground];
                    for (AVObject *object in objects) {
                        [object deleteInBackground];
                    }
                    [self showNotification:@"推送关闭成功啦。 :)"];
                    [sender setOn:NO animated:YES];
                    [_pushIndicator stopAnimating];
                    sender.enabled = YES;
                } else {
                    [self showNotification:@"推送关闭失败，请检查网络设置。:("];
                    [sender setOn:YES animated:YES];
                    [_pushIndicator stopAnimating];
                    sender.enabled = YES;
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clearInformation:(id)sender {
    [clearButton setBackgroundColor:[UIColor colorWithRed:51./255. green:204./255. blue:255./255. alpha:1.0]];
    NSString *deviceToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"Push"] == YES) {
        [[SIAlertView appearance]setTitleFont:[UIFont systemFontOfSize:16]];
        [[SIAlertView appearance]setMessageFont:[UIFont systemFontOfSize:15]];
        [[SIAlertView appearance]setViewBackgroundColor:[UIColor colorWithRed:1. green:1. blue:1. alpha:1.]];
        [[SIAlertView appearance]setButtonFont:[UIFont systemFontOfSize:17]];
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"清除数据" andMessage:@"清除数据失败，请先关闭成绩推送功能。"];
        [alertView addButtonWithTitle:@"好的"
                                 type:SIAlertViewButtonTypeDestructive
                              handler:^(SIAlertView *alertView) {
                                  NSLog(@"OK Clicked");
                              }];
        alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
        alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
        [alertView show];
        [indicator stopAnimating];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
    [[NSUserDefaults standardUserDefaults]setObject:deviceToken forKey:@"deviceToken"];
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Push"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    didLogin=NO;
    UIViewController *leftViewController =[[DLeftViewController alloc]init];
    [self.revealController setLeftViewController:leftViewController];
    DViewController *grade=[[DViewController alloc]init];
    rootController=grade;
    [indicator startAnimating];
    [self performSelector:@selector(clearSuccess) withObject:nil afterDelay:0.6];
    
    
}

- (void)clearSuccess{

    
    
    [[SIAlertView appearance]setTitleFont:[UIFont systemFontOfSize:16]];
    [[SIAlertView appearance]setMessageFont:[UIFont systemFontOfSize:15]];
    [[SIAlertView appearance]setViewBackgroundColor:[UIColor colorWithRed:1. green:1. blue:1. alpha:1.]];
    [[SIAlertView appearance]setButtonFont:[UIFont systemFontOfSize:17]];
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"清除数据" andMessage:@"OK，\n 现在没人知道你曾经登陆过啦！"];
    [alertView addButtonWithTitle:@"好的"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"OK Clicked");
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    [alertView show];
    [indicator stopAnimating];
    
    [self.revealController setFrontViewController:[[DSettingViewController alloc]init] ];
    [self.revealController showViewController:self.revealController.frontViewController];
}

- (IBAction)clearInformationSelected:(id)sender {
    
    [clearButton setBackgroundColor:[UIColor grayColor]];
    
}
- (IBAction)bugFeedBack:(UIButton *)sender {
    DBugViewController *bug=[[DBugViewController alloc]init];
    bug.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.revealController setFrontViewController:bug];
    //[self.revealController showViewController:self.revealController.frontViewController];
    [self.revealController showViewController:self.revealController.frontViewController animated:YES completion:nil];
}

- (IBAction)bugFeedBackPressed:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor grayColor]];
}

- (IBAction)aboutApp:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor colorWithRed:51./255. green:204./255. blue:255./255. alpha:1.0]];
    DAboutViewController *about=[[DAboutViewController alloc]init];
    [self.revealController setFrontViewController:about];
    [self.revealController showViewController:self.revealController.frontViewController animated:YES completion:nil];
    //about.modalTransitionStyle=UIModalTransitionStylePartialCurl;
    //[self presentViewController:about animated:YES completion:nil];
}

- (IBAction)aboutAppPressed:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor grayColor]];
}

- (void)showNotification:(NSString *)str
{
    [[SIAlertView appearance]setTitleFont:[UIFont systemFontOfSize:16]];
    [[SIAlertView appearance]setMessageFont:[UIFont systemFontOfSize:15]];
    [[SIAlertView appearance]setViewBackgroundColor:[UIColor colorWithRed:1. green:1. blue:1. alpha:1.]];
    [[SIAlertView appearance]setButtonFont:[UIFont systemFontOfSize:17]];
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"推送设置" andMessage:str];
    [alertView addButtonWithTitle:@"好的"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"OK Clicked");
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    [alertView show];
}


@end
