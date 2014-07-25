//
//  DWifiViewController.m
//  GPAZJU
//
//  Created by 董鑫宝 on 13-11-3.
//  Copyright (c) 2013年 董鑫宝. All rights reserved.
//

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#import "DWifiViewController.h"
#import "ASIFormDataRequest.h"
#import "SIAlertView.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "ASIHTTPRequest.h"
#import "PKRevealController.h"
@interface DWifiViewController ()

@end
@implementation DWifiViewController
@synthesize account,password,loginView,connectButton,myIndicator;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (iPhone5) {
        self = [super initWithNibName:@"DWifiViewController" bundle:nibBundleOrNil];
    }else{
        self = [super initWithNibName:@"DWifiViewController35" bundle:nibBundleOrNil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [myIndicator startAnimating];
    if ([[self getWifiSSID]isEqualToString:@"ZJUWLAN"]) {
        if ([self isConnectionAvailable] == FALSE) {
            [loginView setHidden:NO];
            
            [connectButton setTitle:@"CONNECT" forState:UIControlStateNormal];
            _connectStatus.hidden = YES;
            account.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"wifiUsername"];
            password.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"wifiPassword"];
            [myIndicator stopAnimating];
        } else {
            [loginView setHidden:YES];
            _connectStatus.hidden = NO;
            _connectStatus.text = @"成功连接至ZJUWLAN！";
            [connectButton setTitle:@"CHECK NETWORK" forState:UIControlStateNormal];
            [myIndicator stopAnimating];
        }
        
    }else {
        [loginView setHidden:YES];
        _connectStatus.hidden = NO;
        _connectStatus.text = @"未连接至ZJUWLAN！";
        [connectButton setTitle:@"CHECK NETWORK" forState:UIControlStateNormal];
        [myIndicator stopAnimating];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //隐藏键盘
    [account resignFirstResponder];
    [password resignFirstResponder];
}

- (IBAction)WifiConnect:(UIButton *)sender
{
    [password resignFirstResponder];
    [account resignFirstResponder];
    [myIndicator startAnimating];
    if ([sender.currentTitle isEqualToString:@"CHECK NETWORK"]) {
        //refresh
        if ([[self getWifiSSID]isEqualToString:@"ZJUWLAN"]) {
            if (![self isConnectionAvailable]) {
                [loginView setHidden:NO];
                
                [connectButton setTitle:@"CONNECT" forState:UIControlStateNormal];
                _connectStatus.hidden = YES;
                account.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"wifiUsername"];
                password.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"wifiPassword"];
            } else {
                [loginView setHidden:YES];
                _connectStatus.hidden = NO;
                _connectStatus.text = @"成功连接至ZJUWLAN！";
                [connectButton setTitle:@"CHECK NETWORK" forState:UIControlStateNormal];
            }
            
        }else {
            [loginView setHidden:YES];
            _connectStatus.hidden = NO;
            _connectStatus.text = @"请连接至ZJUWLAN！";
            [connectButton setTitle:@"CHECK NETWORK" forState:UIControlStateNormal];
        }
        [myIndicator stopAnimating];
        return;
    }
    NSString *wifiaccount = [[NSString alloc]initWithString:account.text];
    NSString *wifipassword = [[NSString alloc]initWithString:password.text];
    if ([wifiaccount length] == 0) {
        [self alertShow:@"账号在哪里呢？"];
        [myIndicator stopAnimating];
    }else if ([wifipassword length] == 0) {
        [self alertShow:@"总该输入一下密码吧？"];
        [myIndicator stopAnimating];
    }else {
//        NSLog(@"12");
//        NSString *urlString = [NSString stringWithFormat:@"https://net.zju.edu.cn/rad_online.php"];
        NSString *urlString = [NSString stringWithFormat:@"https://net.zju.edu.cn/cgi-bin/srun_portal"];
        ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
        [requestForm setPostValue:account.text forKey:@"username"];
        [requestForm setPostValue:password.text forKey:@"password"];
        [requestForm setPostValue:@"2" forKey:@"type"];
        [requestForm setPostValue:@"login" forKey:@"action"];
        [requestForm setPostValue:@"1" forKey:@"local_auth"];
        [requestForm setPostValue:@"1" forKey:@"is_ldap"];
        [requestForm setPostValue:@"5" forKey:@"ac_id"];
        [requestForm setDelegate:self];
        [requestForm setDidFinishSelector:@selector(wifiLoginSuccess:)];
        [requestForm setDidFailSelector:@selector(requestError:)];
        [requestForm startAsynchronous];
        //[requestForm setDidFailSelector:@selector(requestError:)];
    }
}

- (void)wifiLoginSuccess:(ASIFormDataRequest *)requestForm
{
    NSLog(@"%@",requestForm.responseString);
    if ([requestForm.responseString isEqualToString:@"online_num_error"]) {
        NSLog(@"已在线");
        [[NSUserDefaults standardUserDefaults]setObject:account.text forKey:@"wifiUsername"];
        [[NSUserDefaults standardUserDefaults]setObject:password.text forKey:@"wifiPassword"];
        [self isOnline];
        return;
    }
    if ([requestForm.responseString isEqualToString:@"password_error"]) {
        NSLog(@"密码错误！");
        [self alertShow:@"账号或者密码错了吧？"];
        [myIndicator stopAnimating];
        return;
        
    }
    NSRange range = [requestForm.responseString rangeOfString:@"login_ok"];
    if (range.location != NSNotFound) {
        NSLog(@"登录成功！");
        [[NSUserDefaults standardUserDefaults]setObject:account.text forKey:@"wifiUsername"];
        [[NSUserDefaults standardUserDefaults]setObject:password.text forKey:@"wifiPassword"];
        [self alertShow:@"登录成功啦！:D"];
        [loginView setHidden:YES];
        _connectStatus.hidden = NO;
        _connectStatus.text = @"成功连接至ZJUWLAN！";
        [connectButton setTitle:@"CHECK NETWORK" forState:UIControlStateNormal];
        [myIndicator stopAnimating];
        return;
    }
    range = [requestForm.responseString rangeOfString:@"ip"];
    if (range.location != NSNotFound) {
        [self alertShow:@"IP异常，请断开WI-FI后重新连接。"];
        [myIndicator stopAnimating];
        return;
    }
}

- (void)isOnline
{
    [[SIAlertView appearance]setTitleFont:[UIFont systemFontOfSize:16]];
    [[SIAlertView appearance]setMessageFont:[UIFont systemFontOfSize:15]];
    [[SIAlertView appearance]setViewBackgroundColor:[UIColor colorWithRed:1. green:1. blue:1. alpha:1.]];
    [[SIAlertView appearance]setButtonFont:[UIFont systemFontOfSize:17]];
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"ZJUWLAN" andMessage:@"您的账号已在线，是否无情地将其踢下线？"];
    [alertView addButtonWithTitle:@"取消" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView) {
        [myIndicator stopAnimating];
    }];
    [alertView addButtonWithTitle:@"好的"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              NSString *urlString = [NSString stringWithFormat:@"https://net.zju.edu.cn/rad_online.php"];
                              ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
                              [requestForm setPostValue:account.text forKey:@"username"];
                              [requestForm setPostValue:password.text forKey:@"password"];
                              [requestForm setPostValue:@"auto_dm" forKey:@"action"];
                              [requestForm setDelegate:self];
                              [requestForm setDidFinishSelector:@selector(reLogin:)];
                              [requestForm setDidFailSelector:@selector(requestError:)];
                              [requestForm startAsynchronous];
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    [alertView show];
}

- (void)reLogin: (ASIFormDataRequest *)response
{
    NSLog(@"reLogin");
    NSString *urlString = [NSString stringWithFormat:@"https://net.zju.edu.cn/cgi-bin/srun_portal"];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [requestForm setPostValue:account.text forKey:@"username"];
    [requestForm setPostValue:password.text forKey:@"password"];
    [requestForm setPostValue:@"2" forKey:@"type"];
    [requestForm setPostValue:@"login" forKey:@"action"];
    [requestForm setPostValue:@"1" forKey:@"local_auth"];
    [requestForm setPostValue:@"1" forKey:@"is_ldap"];
    [requestForm setPostValue:@"5" forKey:@"ac_id"];
    [requestForm setDelegate:self];
    [requestForm setDidFinishSelector:@selector(reLoginAlertSuccess:)];
    [requestForm setDidFailSelector:@selector(requestError:)];
    [requestForm startAsynchronous];
}

- (void)reLoginAlertSuccess:(ASIFormDataRequest *)requestForm
{
    //NSLog(@"reLoginAlertSuccess");
    //NSLog(@"1212%@",requestForm.responseString);
    NSRange range = [requestForm.responseString rangeOfString:@"login_ok"];
    NSRange range2 = [requestForm.responseString rangeOfString:@"ip"];
    if (range.location != NSNotFound) {
        [self alertShow:@"登录成功啦！:D"];
        [loginView setHidden:YES];
        _connectStatus.hidden = NO;
        _connectStatus.text = @"成功连接至ZJUWLAN！";
        [connectButton setTitle:@"CHECK NETWORK" forState:UIControlStateNormal];
    }else if (range2.location != NSNotFound) {
        [self alertShow:@"IP异常，请断开WI-FI后重新连接。"];
    }else{
        [self alertShow:@"未知错误. BAD"];
    }
    [myIndicator stopAnimating];
    
}

- (void)requestError:(ASIFormDataRequest *)requestForm
{
    [self alertShow:@"网络连接错误! BAD"];
}

- (void)alertShow:(NSString *)str
{
    [[SIAlertView appearance]setTitleFont:[UIFont systemFontOfSize:16]];
    [[SIAlertView appearance]setMessageFont:[UIFont systemFontOfSize:15]];
    [[SIAlertView appearance]setViewBackgroundColor:[UIColor colorWithRed:1. green:1. blue:1. alpha:1.]];
    [[SIAlertView appearance]setButtonFont:[UIFont systemFontOfSize:17]];
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"ZJUWLAN" andMessage:str];

    [alertView addButtonWithTitle:@"确认"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"OK Clicked");
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    [alertView show];
}

- (IBAction)textDidOnExit:(UITextField *)sender {
    if (sender.tag == 1) {
        [password becomeFirstResponder];
    }else if (sender.tag == 2) {
        [sender resignFirstResponder];
        [self.connectButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (IBAction)clearInformation:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"wifiUsername"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"wifiPassword"];
    account.text = @"";
    password.text = @"";
    
}

- (NSString *)getWifiSSID
{
    NSString *ssid = @"Not Found";
    
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            ssid = [dict valueForKey:@"SSID"];
        }
    }
    NSLog(@"%@",ssid);
    return ssid;
}

- (BOOL) isConnectionAvailable
{
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:0.5];
    [request startSynchronous];
    NSError *error = [request error];
    if (error) {
        return FALSE;
    }
    if ([request.responseString rangeOfString:@"baike"].location != NSNotFound) {
        return TRUE;
    }
    return FALSE;
}
@end












