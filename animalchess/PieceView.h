//
//  PieceView.h
//  animalchess
//
//  Created by 徐豪俊 on 16/1/19.
//  Copyright © 2016年 徐豪俊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieceView : UIView

@property (nonatomic) NSUInteger row;

@property (nonatomic) NSUInteger column;

@property (nonatomic) int pieceType;

@property (nonatomic) NSUInteger player;

@property (nonatomic,getter=isChosen) BOOL chosen;


@end
