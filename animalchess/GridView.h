//
//  GridView.h
//  animalchess
//
//  Created by 徐豪俊 on 16/1/19.
//  Copyright © 2016年 徐豪俊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimalChessGame.h"

@interface GridView : UIView

@property (nonatomic,strong) UIImage *backgroundImage;
@property (nonatomic) BOOL chosenOnePiece;
@property (nonatomic) NSUInteger currentPlayer;
@property (nonatomic,strong) AnimalChessGame *game;
@property (nonatomic,strong) NSString *message;

- (void)updatePiece;
- (void)restartGame;
@end
