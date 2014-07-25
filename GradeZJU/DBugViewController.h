//
//  DBugViewController.h
//  GPAZJU
//
//  Created by 董鑫宝 on 13-10-15.
//  Copyright (c) 2013年 董鑫宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBugViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *myIndicator;
@property (weak, nonatomic) IBOutlet UITextView *bugText;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

- (IBAction)bugSend:(UIButton *)sender;

@end
