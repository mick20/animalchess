//
//  GridCell.h
//  animalchess
//
//  Created by 徐豪俊 on 16/1/19.
//  Copyright © 2016年 徐豪俊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface GridCell : NSObject

@property (nonatomic) NSUInteger row;

@property (nonatomic) NSUInteger column;

@property (nonatomic,strong) NSString *cellType;

@property (nonatomic) NSUInteger player;

@end

