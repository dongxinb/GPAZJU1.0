//
//  DWifiViewController.h
//  GPAZJU
//
//  Created by 董鑫宝 on 13-11-3.
//  Copyright (c) 2013年 董鑫宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWifiViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UILabel *connectStatus;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *myIndicator;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
- (IBAction)textDidOnExit:(UITextField *)sender;
- (IBAction)clearInformation:(UIButton *)sender;


@end
