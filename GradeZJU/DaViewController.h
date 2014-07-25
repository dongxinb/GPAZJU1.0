//
//  DViewController.h
//  GradeZJU
//
//  Created by 董鑫宝 on 13-8-5.
//  Copyright (c) 2013年 董鑫宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface DViewController : UIViewController{
    __weak IBOutlet UITextView *test;
}
- (void)refresh:(ASIFormDataRequest *) request;
- (IBAction)PressButton:(id)sender;

- (IBAction)tempButton:(id)sender;

@end
