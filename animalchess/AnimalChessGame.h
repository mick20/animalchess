//
//  AnimalChessGame.h
//  animalchess
//
//  Created by 徐豪俊 on 16/1/20.
//  Copyright © 2016年 徐豪俊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Piece.h"
@interface AnimalChessGame : NSObject

@property (nonatomic,copy) NSMutableArray *gridCellArray; // of 63 gridCells
@property (nonatomic,copy) NSMutableArray *piecesOfPlayer0; //of 8 pieces
@property (nonatomic,copy) NSMutableArray *piecesOfPlayer1; //of 8 pieces
@property (nonatomic,copy) NSMutableArray *pieces; //of 16pieces
@property (nonatomic) NSUInteger currentPlayer;
@property (nonatomic,strong) Piece *chosenPiece;
@property (nonatomic) NSUInteger winner;

- (instancetype)init;

- (BOOL)checkAnyAvailablePieceAtRow:(NSUInteger)row andColumn:(NSUInteger)column;


- (BOOL)checkTheActionAtRow:(NSUInteger)row andColumn:(NSUInteger)column;


- (void)choosePieceAtRow:(NSUInteger)row andColumn:(NSUInteger)column;
@end
