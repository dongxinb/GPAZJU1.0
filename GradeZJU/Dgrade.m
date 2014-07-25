//
//  Dgrade.m
//  GradeZJU
//
//  Created by 董鑫宝 on 13-8-6.
//  Copyright (c) 2013年 董鑫宝. All rights reserved.
//

#import "Dgrade.h"

@implementation Dgrade

@synthesize name;
@synthesize grade;
@synthesize xuefen;
@synthesize kechenghao;
@synthesize jidian;
-(void)encodeWithCoder:(NSCoder *)aCoder//要一一对应
{
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:grade forKey:@"grade"];
    [aCoder encodeDouble:jidian forKey:@"jidian"];
    [aCoder encodeDouble:xuefen forKey:@"xuefen"];
    [aCoder encodeObject:kechenghao forKey:@"kechenghao"];
}
-(id)initWithCoder:(NSCoder *)aDecoder//和上面对应
{
    if (self=[super init]) {
        self.name=[aDecoder decodeObjectForKey:@"name"];
        self.grade=[aDecoder decodeObjectForKey:@"grade"];
        self.jidian=[aDecoder decodeDoubleForKey:@"jidian"];
        self.xuefen=[aDecoder decodeDoubleForKey:@"xuefen"];
        self.kechenghao=[aDecoder decodeObjectForKey:@"kechenghao"];
    }
    return self;
}
@end
