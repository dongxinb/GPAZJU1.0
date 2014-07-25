//
//  DViewController.m
//  GradeZJU
//
//  Created by 董鑫宝 on 13-8-5.
//  Copyright (c) 2013年 董鑫宝. All rights reserved.
//

#import "DViewController.h"
#import "DLoginViewController.h"
#import "DAboutViewController.h"
#import "DLeftViewController.h"
#import "PKRevealController.h"
#import "Dgrade.h"
#import "ASIFormDataRequest.h"
#import "SIAlertView.h"
@interface DViewController ()

@end

@implementation DViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.revealController showViewController:self.revealController.frontViewController];
    didLogin=[[NSUserDefaults standardUserDefaults]boolForKey:@"login"];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)login
{
    NSString *xh=[[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
    NSString *password=[[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    NSString *urlString = [NSString stringWithFormat:@"http://jwbinfosys.zju.edu.cn/default2.aspx"];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setPostValue:@"Button1" forKey:@"__EVENTTARGET"];
    [request setPostValue:@"" forKey:@"__EVENTARGUMENT"];
    [request setPostValue:@"dDwxOTEwMzI3NDAyOzs+hurYK255qc/CsDx7/bCGtJreiuI=" forKey:@"__VIEWSTATE"];
    [request setPostValue:xh forKey:@"TextBox1"];
    [request setPostValue:password forKey:@"TextBox2"];
    [request setPostValue:@"学生" forKey:@"RadioButtonList1"];
    [request setPostValue:@"submit" forKey:@"_eventId"];
    [request setPostValue:@"" forKey:@"Text1"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(refresh:)];
    [request setDidFailSelector:@selector(requestError:)];
    [request startAsynchronous];
}

- (void) refresh:(ASIFormDataRequest *)request
{
    //获取年份
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSCalendar * cal=[NSCalendar currentCalendar];
    NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger year=[conponent year];
    NSLog(@"%d",year);
    
    NSString *xh=[[NSUserDefaults standardUserDefaults]stringForKey:@"name"];
    NSString *urlString = [NSString stringWithFormat:@"http://jwbinfosys.zju.edu.cn/xscj.aspx?xh=%@",xh];
    ASIFormDataRequest *requestForm;
    int j;
    for (int i=2012; i<year; i++) {
        for (j=1; j<=2; j++) {
            requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
            [requestForm setPostValue:@"dDwyMTQ0OTczMjA5O3Q8O2w8aTwxPjs+O2w8dDw7bDxpPDI+O2k8NT47aTwyMT47aTwyMz47aTwzNz47aTwzOT47aTw0MT47aTw0Mz47PjtsPHQ8dDw7dDxpPDE0PjtAPFxlOzIwMDEtMjAwMjsyMDAyLTIwMDM7MjAwMy0yMDA0OzIwMDQtMjAwNTsyMDA1LTIwMDY7MjAwNi0yMDA3OzIwMDctMjAwODsyMDA4LTIwMDk7MjAwOS0yMDEwOzIwMTAtMjAxMTsyMDExLTIwMTI7MjAxMi0yMDEzOzIwMTMtMjAxNDs+O0A8XGU7MjAwMS0yMDAyOzIwMDItMjAwMzsyMDAzLTIwMDQ7MjAwNC0yMDA1OzIwMDUtMjAwNjsyMDA2LTIwMDc7MjAwNy0yMDA4OzIwMDgtMjAwOTsyMDA5LTIwMTA7MjAxMC0yMDExOzIwMTEtMjAxMjsyMDEyLTIwMTM7MjAxMy0yMDE0Oz4+Oz47Oz47dDx0PHA8cDxsPERhdGFUZXh0RmllbGQ7RGF0YVZhbHVlRmllbGQ7PjtsPHh4cTt4cTE7Pj47Pjt0PGk8Nz47QDxcZTvnp4s75YasO+efrTvmmKU75aSPO+efrTs+O0A8XGU7MXznp4s7MXzlhqw7MXznn607MnzmmKU7MnzlpI87Mnznn607Pj47Pjs7Pjt0PHA8O3A8bDxvbmNsaWNrOz47bDx3aW5kb3cucHJpbnQoKVw7Oz4+Pjs7Pjt0PHA8O3A8bDxvbmNsaWNrOz47bDx3aW5kb3cuY2xvc2UoKVw7Oz4+Pjs7Pjt0PEAwPDs7Ozs7Ozs7Ozs+Ozs+O3Q8QDA8Ozs7Ozs7Ozs7Oz47Oz47dDxAMDw7Ozs7Ozs7Ozs7Pjs7Pjt0PHA8cDxsPFRleHQ7PjtsPFpKRFg7Pj47Pjs7Pjs+Pjs+Pjs+y0ElZ9Hn+SlXToKugoUwAneDL5w=" forKey:@"__VIEWSTATE"];
            [requestForm setPostValue:[NSString stringWithFormat:@"%d-%d",i,i+1] forKey:@"ddlXN"];
            if (j==1) {
                [requestForm setPostValue:@"1|秋" forKey:@"ddlXQ"];//春夏为2|春 秋冬为1|秋
            }else{
                [requestForm setPostValue:@"2|春" forKey:@"ddlXQ"];//春夏为2|春 秋冬为1|秋
            }
            [requestForm setPostValue:@"按学期查询" forKey:@"Button1"];//Button1为学期 Button5为学年
            [requestForm setDelegate:self];
            [requestForm setDidFinishSelector:@selector(siftGrade:)];
            //[requestForm setDidFailSelector:@selector(requestError:)];
            [requestForm startAsynchronous];
            
        }
    }
    
}

- (void)siftGrade:(ASIFormDataRequest *)requestForm
{
    NSData *res1=[requestForm responseData];
    NSString *result = [[NSString alloc] initWithData:res1 encoding:0x80000632];
    //test.text=result;
    
    NSMutableString *temp=[[NSMutableString alloc]init];
    temp=[NSMutableString stringWithString:result];
    //NSLog(@"%@",temp);
    NSRange range=[temp rangeOfString:@"selected\" value=\""];
    //NSLog(@"%d",range.length);
    [temp deleteCharactersInRange:NSMakeRange(0, range.length+range.location)];
    range=[temp rangeOfString:@"\">"];
    NSString *xuenian=[temp substringToIndex:range.location];
    
    range=[temp rangeOfString:@"\"selected\" value=\""];
    [temp deleteCharactersInRange:NSMakeRange(0, range.length+range.location)];
    range=[temp rangeOfString:@"|"];
    int xueqi=[[temp substringToIndex:range.location]intValue];
    
    NSMutableDictionary *kc=[[NSMutableDictionary alloc]init];
    Dgrade *kemu;
    range=[temp rangeOfString:@"补考成绩"];
    [temp deleteCharactersInRange:NSMakeRange(0, range.location+range.length)];
    range=[temp rangeOfString:@"</td><td>"];
    NSData *tempkm=[[NSData alloc]init];
    while (range.location!=NSNotFound) {
        kemu=[Dgrade new];
        kemu.kechenghao=[temp substringWithRange:NSMakeRange(range.location-32,32)];
        [temp deleteCharactersInRange:NSMakeRange(0, range.location+range.length)];
        range=[temp rangeOfString:@"</td><td>"];
        kemu.name=[temp substringToIndex:range.location];
        [temp deleteCharactersInRange:NSMakeRange(0, range.location+range.length)];
        range=[temp rangeOfString:@"</td><td>"];
        kemu.grade=[[temp substringToIndex:range.location] intValue];
        [temp deleteCharactersInRange:NSMakeRange(0, range.location+range.length)];
        range=[temp rangeOfString:@"</td><td>"];
        kemu.xuefen=[[temp substringToIndex:range.location] doubleValue];
        range=[temp rangeOfString:@"&nbsp;"];
        [temp deleteCharactersInRange:NSMakeRange(0, range.location+range.length)];
        range=[temp rangeOfString:@"</td><td>"];
        
        tempkm=[NSKeyedArchiver archivedDataWithRootObject:kemu];//转化成NSData
        [kc setObject:tempkm forKey:kemu.name];
    }
    NSDictionary *kcgrade=[[NSDictionary alloc]initWithDictionary:kc];
    [[NSUserDefaults standardUserDefaults]setObject:kcgrade forKey:[NSString stringWithFormat:@"%@-%d",xuenian,xueqi]];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //NSLog(@"%@",xuenian);
    
}


- (IBAction)PressButton:(id)sender {
    [self login];
    
}

- (IBAction)tempButton:(id)sender {
    /*
    NSDictionary *a;
    Dgrade *km;
    NSData *datakm;
    int j;
    for (int i=2008; i<=2012; i++) {
        for (j=1; j<=2; j++) {
            a=[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%d-%d-%d",i,i+1,j]];
            for (datakm in a) {
                km=[NSKeyedUnarchiver unarchiveObjectWithData:datakm];
                NSLog(@"%@:%d,%lf\n",km.name,km.grade,km.xuefen);
            }
            NSLog(@"\n\n");
        }
    }*/
    
    NSDictionary *a=[[NSUserDefaults standardUserDefaults]objectForKey:@"2012-2013-2"];
    
//    for(NSData *abc in a){
//        Dgrade *temp=[NSKeyedUnarchiver unarchiveObjectWithData:abc];
//        NSLog(@"%@",temp.name);
//    }
    NSData *temp=[a objectForKey:@"程序设计综合实验"];
    Dgrade *gg=[NSKeyedUnarchiver unarchiveObjectWithData:temp];
NSLog(@"%@",gg.kechenghao);
}

- (void)requestError:(ASIFormDataRequest *)requestForm
{
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
}


@end


