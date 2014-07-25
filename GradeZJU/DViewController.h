//
//  DViewController.h
//  GradeZJU
//
//  Created by 董鑫宝 on 13-8-18.
//  Copyright (c) 2013年 董鑫宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
BOOL firstLogin;
@interface DViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
- (void)login;
- (void)loadAll;
- (void)refreshTableView;

@end
