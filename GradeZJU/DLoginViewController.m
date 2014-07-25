//
//  DLoginViewController.m
//  GradeZJU
//
//  Created by 董鑫宝 on 13-8-5.
//  Copyright (c) 2013年 董鑫宝. All rights reserved.
//
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define GB2312_ENCODING CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)

#import "DLoginViewController.h"
#import "ASIFormDataRequest.h"
#import "Dgrade.h"
#import "PKRevealController.h"
#import "DLeftViewController.h"
#import "DViewController.h"
#import "DAppDelegate.h"
#import "SIAlertView.h"
#import "DRow.h"
#import <AVOSCloud/AVOSCloud.h>


@interface DLoginViewController ()

@end

@implementation DLoginViewController
NSString *tempresult;//密码错误，您还有X次尝试机会……

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (iPhone5) {
        self = [super initWithNibName:@"DLoginViewController" bundle:nibBundleOrNil];
    }else{
        self = [super initWithNibName:@"DLoginViewController35" bundle:nibBundleOrNil];
    }
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{

    // Do any additional setup after loading the view from its nib.
    name.delegate=self;
    password.delegate=self;
    
    NSString *namesave=[[NSUserDefaults standardUserDefaults]stringForKey:@"name"];
    if (namesave) {
        name.text=namesave;
        password.text=[[NSUserDefaults standardUserDefaults]stringForKey:@"password"];
    }
    //读入保存的学号密码
    didLogin=[[NSUserDefaults standardUserDefaults]boolForKey:@"login"];
    if(didLogin==YES){
        [name setHidden:TRUE];
        [password setHidden:TRUE];
        [loginButton setTitle:@"SIGN OUT" forState:UIControlStateNormal];
        [labelmm setHidden:TRUE];
        [labelxh setHidden:TRUE];
        labelsigned.text=@"已登陆:";
        signedxh.text=name.text;
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AVAnalytics beginLogPageView:@"Login1.0"];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"Login1.0"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)noaction:(id)sender
{
    [password resignFirstResponder];
    [name resignFirstResponder];
}

- (IBAction)_login:(id)sender
{
    [password resignFirstResponder];
    [name resignFirstResponder];
    [indicator startAnimating];
    loginButton.enabled = NO;
    [loginButton setBackgroundColor:[UIColor colorWithRed:2./255. green:184./255. blue:255./255. alpha:1.0]];
    if (didLogin==NO){
        if ([name.text isEqualToString:@""]) {
            //prompt.text=@"你的学号呢？";
            [self loginAlert:@"你的学号呢？\n(+_+)"];
            [indicator stopAnimating];
        }else if([password.text isEqualToString:@""]){
            //prompt.text=@"你的密码呢？";
            [self loginAlert:@"你的密码呢？\n(+_+)"];
            [indicator stopAnimating];
        }else{
            if ([name.text length]!=10) {
                //prompt.text=@"学号不是10位的吗？";
                [self loginAlert:@"学号不是10位的吗？\n(+_+)#"];
                [indicator stopAnimating];
                return;
            }
        
            //[ASIHTTPRequest setShouldThrottleBandwidthForWWAN:YES];
            NSString *urlString = [NSString stringWithFormat:@"http://jwbinfosys.zju.edu.cn/default2.aspx"];
            ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
            [requestForm setPostValue:@"Button1" forKey:@"__EVENTTARGET"];
            [requestForm setPostValue:@"" forKey:@"__EVENTARGUMENT"];
            [requestForm setPostValue:@"dDwxNTc0MzA5MTU4Ozs+RGE82+DpWCQpVjFtEpHZ1UJYg8w=" forKey:@"__VIEWSTATE"];
            [requestForm setPostValue:name.text forKey:@"TextBox1"];
            [requestForm setPostValue:password.text forKey:@"TextBox2"];
            [requestForm setPostValue:@"学生" forKey:@"RadioButtonList1"];
            [requestForm setPostValue:@"submit" forKey:@"_eventId"];
            [requestForm setPostValue:@"" forKey:@"Text1"];
            [requestForm setDefaultResponseEncoding:GB2312_ENCODING];
//            [requestForm setPostValue:name.text forKey:@"stuID"];
//            [requestForm setPostValue:password.text forKey:@"password"];
            [requestForm setDelegate:self];
            [requestForm setDidFinishSelector:@selector(loginSuccess:)];
            [requestForm setDidFailSelector:@selector(requestError:)];
//            requestForm.shouldWaitToInflateCompressedResponses=NO;
//            requestForm.allowCompressedResponse=NO;
            
//            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_2312_80);
//            [requestForm setStringEncoding:enc];
            
            [requestForm startAsynchronous];
        }
    }else{
        //注销！！！！！
        BOOL pushh = [[NSUserDefaults standardUserDefaults] boolForKey:@"Push"];
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"] length]!=0 && pushh == YES) {
            AVQuery *query=[AVQuery queryWithClassName:@"studentPush"];
            [query whereKey:@"deviceToken" equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    for (AVObject *object in objects){
                        //[object deleteInBackground];
                        [object deleteEventually];
                    }
                    [ASIHTTPRequest setSessionCookies:nil];
                    //prompt.text=@"注销成功";
                    [self logoutAlert];
                    didLogin=NO;
                    [indicator stopAnimating];
                    loginButton.enabled = YES;
                    [[NSUserDefaults standardUserDefaults] setBool:didLogin forKey:@"login"];
                    //延迟1s后返回
                    //[[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"2012-2013-1"];
                    //[[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"2012-2013-2"];
                    
                    NSDate * senddate=[NSDate date];
                    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
                    [dateformatter setDateFormat:@"HH:mm"];
                    NSCalendar * cal=[NSCalendar currentCalendar];
                    NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
                    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
                    NSInteger year=[conponent year];
                    NSLog(@"%d",year);
                    
                    NSString *deviceToken1=[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"];
                    NSString *name1=[[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
                    NSString *password1=[[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
                    NSString *wifiUsername = [[NSUserDefaults standardUserDefaults]objectForKey:@"wifiUsername"];
                    NSString *wifiPassword = [[NSUserDefaults standardUserDefaults]objectForKey:@"wifiPassword"];
                    BOOL newVersion = [[NSUserDefaults standardUserDefaults]boolForKey:@"newVersion1.2"];
                    [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [[NSUserDefaults standardUserDefaults] setObject:deviceToken1 forKey:@"deviceToken"];
                    [[NSUserDefaults standardUserDefaults] setObject:name1 forKey:@"name"];
                    [[NSUserDefaults standardUserDefaults] setObject:password1 forKey:@"password"];
                    [[NSUserDefaults standardUserDefaults] setObject:wifiPassword forKey:@"wifiPassword"];
                    [[NSUserDefaults standardUserDefaults] setObject:wifiUsername forKey:@"wifiUsername"];
                    [[NSUserDefaults standardUserDefaults] setBool:newVersion forKey:@"newVersion1.2"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self performSelector:@selector(_return2) withObject:nil afterDelay:0.8];
                    
                    [self refreshLeft];
                    
                    
                } else {
                    
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                    
                    [self loginAlert:@"注销失败！\n无法删除推送记录，请连接网络再试。"];
                    [indicator stopAnimating];
                    loginButton.enabled = YES;
                }
            }];
        }else {
            [ASIHTTPRequest setSessionCookies:nil];
            //prompt.text=@"注销成功";
            [self logoutAlert];
            didLogin=NO;
            [indicator stopAnimating];
            loginButton.enabled = YES;
            [[NSUserDefaults standardUserDefaults] setBool:didLogin forKey:@"login"];
            //延迟1s后返回
            //[[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"2012-2013-1"];
            //[[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"2012-2013-2"];
            
            NSDate * senddate=[NSDate date];
            NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"HH:mm"];
            NSCalendar * cal=[NSCalendar currentCalendar];
            NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
            NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
            NSInteger year=[conponent year];
            NSLog(@"%d",year);
            
            NSString *deviceToken1=[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"];
            NSString *name1=[[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
            NSString *password1=[[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
            NSString *wifiUsername = [[NSUserDefaults standardUserDefaults]objectForKey:@"wifiUsername"];
            NSString *wifiPassword = [[NSUserDefaults standardUserDefaults]objectForKey:@"wifiPassword"];
            BOOL newVersion = [[NSUserDefaults standardUserDefaults]boolForKey:@"newVersion1.2"];
            BOOL mode = [[NSUserDefaults standardUserDefaults]boolForKey:@"mode"];
            [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults] setObject:deviceToken1 forKey:@"deviceToken"];
            [[NSUserDefaults standardUserDefaults] setObject:name1 forKey:@"name"];
            [[NSUserDefaults standardUserDefaults] setObject:password1 forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] setObject:wifiPassword forKey:@"wifiPassword"];
            [[NSUserDefaults standardUserDefaults] setObject:wifiUsername forKey:@"wifiUsername"];
            [[NSUserDefaults standardUserDefaults] setBool:newVersion forKey:@"newVersion1.2"];
            [[NSUserDefaults standardUserDefaults] setBool:mode forKey:@"mode"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self performSelector:@selector(_return2) withObject:nil afterDelay:0.8];
            
            [self refreshLeft];
        }
        
        
        
    }
}
-(void) _return1
{
    //UIViewController *grade=[[DViewController alloc]init];
    //UIViewController *grade =[DViewController new];
    //DViewController *grade =[[DViewController alloc]init];
    //firstLogin=YES;
    UIViewController *login =[[DLoginViewController alloc]init];
    loginController=login;
    //firstLogin=YES;
    DViewController *gg=[[DViewController alloc]init];
    [gg login];
    //[gg loadAll];
    //gg=[[DViewController alloc]init];
    [self.revealController setFrontViewController:gg];
    [self.revealController showViewController:self.revealController.frontViewController];
    rootController=self.revealController.frontViewController;
    //[(DViewController *)rootController login];
    //[(DViewController *)self.revealController.frontViewController loadAll];
    //rootController=self.revealController.frontViewController;
}


-(void) _return2
{
    UIViewController *login =[[DLoginViewController alloc]init];
    loginController=login;
    [self.revealController setFrontViewController:loginController];
    
}

- (void)loginSuccess:(ASIFormDataRequest *)requestForm
{
    loginButton.enabled = YES;
    NSString *result2=[requestForm responseString];
//    NSData *result1 = [requestForm responseData];
//    NSString *result2 = [[NSString alloc] initWithData:result1 encoding:0x80000632];
//    if ([result2 rangeOfString:@"浙江大学"].location==NSNotFound) {
//        NSData *result1=[requestForm responseData];
//        result2=[[NSString alloc]initWithData:result1 encoding:0x80000632];
//    }
//    NSData *result1=[requestForm responseData];
//    NSString *result2 = [[NSString alloc] initWithData:result1 encoding:0x80000632];
//    NSLog(@"%@",result2);
//    NSLog(@"%@",result1);
    NSRange range=[result2 rangeOfString:@"密码错误"];
    //NSRange range6=[result2 rangeOfString:@"学籍状态不正确"];
    if (range.location!=NSNotFound){
        //NSString *times
        //[self loginAlert:[result2 substringWithRange:NSMakeRange(16,16)]];
        [self loginAlert:@"密码错误，再认真输一下？"];
        [indicator stopAnimating];
        return;
    }
    if ([result2 isEqualToString:@"用户名不存在"]) {
        [self loginAlert:@"你确定这是你的学号吗？"];
        [indicator stopAnimating];
        return;
    }
    if ([result2 isEqualToString:@"学籍"]) {
        [self loginAlert:@"学籍状态不正确！"];
        [indicator stopAnimating];
        return;
    }
    if ([result2 isEqualToString:@"欠费"]) {
        [self loginAlert:@"欠费了呢，暂时无法登陆~"];
        [indicator stopAnimating];
        return;
    }
    if ([result2 isEqualToString:@"控制学号访问"]) {
        [self loginAlert:@"学校控制了学号访问，待会儿吧~"];
        [indicator stopAnimating];
        return;
    }
    range=[result2 rangeOfString:@"个人信息"];
    if (range.location!=NSNotFound){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://jwbinfosys.zju.edu.cn/xs_zxzmdy.aspx?xh=%@", name.text]];
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
        [request setDefaultResponseEncoding:GB2312_ENCODING];
        [request setResponseEncoding:GB2312_ENCODING];
        [request setDidFinishSelector:@selector(getNameFinished:)];
        [request setDidFailSelector:@selector(requestError:)];
        [request setDelegate:self];
        [request startAsynchronous];
        
        
        //NSLog(@"%@",result2);
    }else{
        [self loginAlert:@"和教务网连接似乎有问题？"];
        [indicator stopAnimating];
        return;
    }
}

- (void)getNameFinished:(ASIHTTPRequest *)request
{
    NSString *result = [request responseString];
    NSRange range = [result rangeOfString:@"blxm\">"];
    NSString *result1 = [result substringFromIndex:range.location + range.length];
    range = [result1 rangeOfString:@"</span>"];
    NSString *xm = [result1 substringWithRange:NSMakeRange(0, range.location)];

    [indicator stopAnimating];
    
    [self loginAlert:@"开心地登录啦…\n(^o^)"];
    didLogin=YES;
    NSUserDefaults *usersave=[NSUserDefaults standardUserDefaults];
    [usersave setObject:name.text forKey:@"name"];
    [usersave setObject:password.text forKey:@"password"];
    [usersave setBool:YES forKey:@"login"];
    [usersave setObject:xm forKey:@"xm"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //延迟返回
    [self performSelector:@selector(_return1) withObject:nil afterDelay:0.3];
    //[self getName];
    [self refreshLeft];
}

- (void)loginAlert:(NSString *)str
{
    [[SIAlertView appearance]setTitleFont:[UIFont systemFontOfSize:16]];
    [[SIAlertView appearance]setMessageFont:[UIFont systemFontOfSize:15]];
    [[SIAlertView appearance]setViewBackgroundColor:[UIColor colorWithRed:1. green:1. blue:1. alpha:1.]];
    [[SIAlertView appearance]setButtonFont:[UIFont systemFontOfSize:17]];
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"登录" andMessage:str];
    //    [alertView addButtonWithTitle:@"Cancel"
    //                             type:SIAlertViewButtonTypeCancel
    //                          handler:^(SIAlertView *alertView) {
    //                              NSLog(@"Cancel Clicked");
    //                          }];
    [alertView addButtonWithTitle:@"我明白了"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"OK Clicked");
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    [alertView show];
}

- (void)logoutAlert
{
    [[SIAlertView appearance]setTitleFont:[UIFont systemFontOfSize:16]];
    [[SIAlertView appearance]setMessageFont:[UIFont systemFontOfSize:15]];
    [[SIAlertView appearance]setViewBackgroundColor:[UIColor colorWithRed:1. green:1. blue:1. alpha:1.]];
    [[SIAlertView appearance]setButtonFont:[UIFont systemFontOfSize:17]];
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"注销" andMessage:@"不开心地注销了…\n(￣^￣)"];
    [alertView addButtonWithTitle:@"我明白了"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"OK Clicked");
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    [alertView show];
}

- (void)requestError:(ASIFormDataRequest *)requestForm
{
    [indicator stopAnimating];
    NSError *error = [requestForm error];
    NSLog(@"%@", [error localizedDescription]);
    [[SIAlertView appearance]setTitleFont:[UIFont systemFontOfSize:16]];
    [[SIAlertView appearance]setMessageFont:[UIFont systemFontOfSize:15]];
    [[SIAlertView appearance]setViewBackgroundColor:[UIColor colorWithRed:1. green:1. blue:1. alpha:1.]];
    [[SIAlertView appearance]setButtonFont:[UIFont systemFontOfSize:17]];
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"网络错误" andMessage:@"你确定  你联网了吗？"];
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
    loginButton.enabled = YES;
}

- (void)refreshLeft
{
    //UIViewController *tempViewController =rootController;
    //[self.revealController setFrontViewController:rootController];
    UIViewController *leftViewController =[[DLeftViewController alloc]init];
    //rootController=tempViewController;
    [self.revealController setLeftViewController:leftViewController];
}

- (IBAction)_loginDown:(id)sender
{
    
    [loginButton setBackgroundColor:[UIColor colorWithRed:0. green:153./255. blue:240./255. alpha:1.0]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag==1) {
        if (range.location >= 10)
            return NO; // return NO to not change text
        return YES;
    }
    if (textField.tag==2) {
        if (range.location >= 20)
            return NO; // return NO to not change text
        return YES;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self _login:nil];
    return YES;
}


- (void)showLeftView:(id)sender
{
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.leftViewController)
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.frontViewController];
    }
    else
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.leftViewController];
    }
    
    
    
    
    
    
}



@end