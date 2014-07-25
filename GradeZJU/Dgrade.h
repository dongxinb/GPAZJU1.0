//
//  Dgrade.h
//  GradeZJU
//
//  Created by 董鑫宝 on 13-8-6.
//  Copyright (c) 2013年 董鑫宝. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dgrade : NSObject<NSCoding>{
    NSString *name;
    NSString *grade;
    double xuefen;
    NSString *kechenghao;
    double jidian;
}
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *grade;
@property (nonatomic,assign) double xuefen;
@property (nonatomic,retain) NSString *kechenghao;
@property (nonatomic,assign) double jidian;
@end
