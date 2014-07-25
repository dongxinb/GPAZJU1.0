//
//  DCell.h
//  simpleTable
//
//  Created by 董鑫宝 on 13-8-18.
//  Copyright (c) 2013年 com.dongxinbao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCell : UITableViewCell



@property (strong, nonatomic) IBOutlet UILabel *kecheng;
@property (strong, nonatomic) IBOutlet UILabel *grade;
@property (strong, nonatomic) IBOutlet UILabel *xuefen;
@property (strong, nonatomic) IBOutlet UILabel *parentYear;
@property (strong, nonatomic) IBOutlet UILabel *isNewLabel;

@property (strong, nonatomic) IBOutlet UILabel *parentGrade;
@property (strong, nonatomic) IBOutlet UILabel *parentXN;
@property (strong, nonatomic) IBOutlet UILabel *xueqi;
@end
