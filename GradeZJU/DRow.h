//
//  DRow.h
//  GradeZJU
//
//  Created by 董鑫宝 on 13-8-18.
//  Copyright (c) 2013年 董鑫宝. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRow : NSObject

@property (nonatomic) int level; //Cell 的level
@property (nonatomic) int superId; // 当前Cell 的父Cell 的ID
@property (nonatomic) int selfId; //当前Cell 自己的ID
@property (nonatomic) BOOL isExpanded; //当前Cell 是不是扩展开的
@property (nonatomic) BOOL isNew;
@property (nonatomic) NSString *kechengtemp;
@property (nonatomic) NSString *gradetemp;
@property (nonatomic) NSString *jidiantemp;
@property (nonatomic) NSString *xuefentemp;
@property (nonatomic) NSString *kechenghao;
@property (nonatomic) int year;
@property (nonatomic) NSString *xueqitemp;
@end
