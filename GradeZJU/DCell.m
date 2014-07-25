//
//  DCell.m
//  simpleTable
//
//  Created by 董鑫宝 on 13-8-18.
//  Copyright (c) 2013年 com.dongxinbao. All rights reserved.
//

#import "DCell.h"

@implementation DCell

@synthesize kecheng;
@synthesize xuefen;
@synthesize grade;
@synthesize xueqi;
@synthesize isNewLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
