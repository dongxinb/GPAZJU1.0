//
//  DSettingViewController.h
//  GradeZJU
//
//  Created by Desolate on 13-8-14.
//  Copyright (c) 2013年 董鑫宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface DSettingViewController : UIViewController<MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *clearButton;
- (IBAction)clearInformation:(id)sender;
- (IBAction)clearInformationSelected:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *pushIndicator;
- (IBAction)bugFeedBack:(UIButton *)sender;
- (IBAction)bugFeedBackPressed:(UIButton *)sender;
- (IBAction)aboutApp:(UIButton *)sender;
- (IBAction)aboutAppPressed:(UIButton *)sender;

@end
