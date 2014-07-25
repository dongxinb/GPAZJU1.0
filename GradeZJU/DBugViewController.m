//
//  DBugViewController.m
//  GPAZJU
//
//  Created by 董鑫宝 on 13-10-15.
//  Copyright (c) 2013年 董鑫宝. All rights reserved.
//

#import "DBugViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AVOSCloud/AVOSCloud.h>
#import "SIAlertView.h"
#import "DSettingViewController.h"
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface DBugViewController ()

@end

@implementation DBugViewController
@synthesize bugText,myIndicator,sendButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (iPhone5) {
        self = [super initWithNibName:@"DBugViewController" bundle:nibBundleOrNil];
    }else{
        self = [super initWithNibName:@"DBugViewController35" bundle:nibBundleOrNil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    myIndicator.hidesWhenStopped = YES;
    bugText.delegate=self;
    bugText.layer.borderColor=[UIColor grayColor].CGColor;
    bugText.layer.borderWidth=1.5;
    sendButton.enabled = NO;
    [sendButton setBackgroundColor:[UIColor grayColor]];
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self bugSend:sendButton];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length]==0) {
        [sendButton setBackgroundColor:[UIColor grayColor]];
        sendButton.enabled = NO;
    }else{
        [sendButton setBackgroundColor:[UIColor colorWithRed:2./255. green:184./255. blue:255./255. alpha:1.0]];
        sendButton.enabled = YES;
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
    [bugText resignFirstResponder];
}

- (IBAction)bugSend:(UIButton *)sender
{
    if ([bugText.text length]!=0) {
        sender.enabled = NO;
        [myIndicator startAnimating];
        [sender setBackgroundColor:[UIColor grayColor]];
        AVObject *bug = [AVObject objectWithClassName:@"bugFeedback"];
        [bug setObject:bugText.text forKey:@"content"];
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"]length]!=0) {
            [bug setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"] forKey:@"deviceToken"];
        }
        [bug saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (succeeded) {
                sender.enabled = YES;
                [myIndicator stopAnimating];
                [sender setBackgroundColor:[UIColor colorWithRed:2./255. green:184./255. blue:255./255. alpha:1.0]];
                [self feedbackWithTitle:@"FEEDBACK" message:@"提交成功啦~谢谢合作~"];
            }else{
                sender.enabled = YES;
                [sender setBackgroundColor:[UIColor colorWithRed:2./255. green:184./255. blue:255./255. alpha:1.0]];
                [myIndicator stopAnimating];
                [self feedbackWithTitle:@"FEEDBACK" message:@"网络好像出问题了?"];
            }
        }];
    }else{
        [self feedbackWithTitle:@"FEEDBACK" message:@"你忘记写内容啦？"];
    }
    
}

- (void)feedbackWithTitle:(NSString *)title message:(NSString *)message
{
    [[SIAlertView appearance]setTitleFont:[UIFont systemFontOfSize:16]];
    [[SIAlertView appearance]setMessageFont:[UIFont systemFontOfSize:15]];
    [[SIAlertView appearance]setViewBackgroundColor:[UIColor colorWithRed:1. green:1. blue:1. alpha:1.]];
    [[SIAlertView appearance]setButtonFont:[UIFont systemFontOfSize:17]];
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:title andMessage:message];
    [alertView addButtonWithTitle:@"好的"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    [alertView show];
}
@end
