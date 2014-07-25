//
//  DLoginViewController.h
//  GradeZJU
//
//  Created by 董鑫宝 on 13-8-5.
//  Copyright (c) 2013年 董鑫宝. All rights reserved.
//

#import <UIKit/UIKit.h>
Boolean didLogin;
UIViewController *rootController;
UIViewController *loginController;
@interface DLoginViewController : UIViewController<UITextFieldDelegate>{

    __weak IBOutlet UITextField *name;
    __weak IBOutlet UITextField *password;
    __weak IBOutlet UILabel *prompt;
    __weak IBOutlet UIButton *loginButton;
    __weak IBOutlet UIActivityIndicatorView *indicator;
    __weak IBOutlet UILabel *labelxh;
    __weak IBOutlet UILabel *labelmm;
    __weak IBOutlet UILabel *signedxh;
    __weak IBOutlet UILabel *labelsigned;
}

- (IBAction)noaction:(id)sender;
- (IBAction)_login:(id)sender;
- (IBAction)_loginDown:(id)sender;

@end


