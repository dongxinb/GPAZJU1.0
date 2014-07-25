//
//  DLeftViewController.h
//  GradeZJU
//
//  Created by Desolate on 13-8-13.
//  Copyright (c) 2013年 董鑫宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLeftViewController : UIViewController{
    
    __weak IBOutlet UILabel *labelxh;
    __weak IBOutlet UILabel *labelname;
    __weak IBOutlet UIButton *loginbutton;

}
@property (weak, nonatomic) IBOutlet UILabel *xm;
- (IBAction)login:(id)sender;
- (IBAction)grade:(id)sender;
- (IBAction)setting:(id)sender;
- (IBAction)statistics:(id)sender;

@end
