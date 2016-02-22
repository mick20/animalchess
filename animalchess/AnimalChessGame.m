//
//  AnimalChessGame.m
//  animalchess
//
//  Created by 徐豪俊 on 16/1/20.
//  Copyright © 2016年 徐豪俊. All rights reserved.
//

#import "AnimalChessGame.h"
#import "GridCell.h"
#import "Piece.h"
#import "Constants.h"



@interface AnimalChessGame()



@end

@implementation AnimalChessGame

#pragma mark - properties

- (NSMutableArray *)gridCellArray
{
    if (!_gridCellArray) {
        _gridCellArray = [[NSMutableArray alloc] init];
    }
    return _gridCellArray;
}

- (NSMutableArray *)piecesOfPlayer0
{
    if (!_piecesOfPlayer0) {
        _piecesOfPlayer0 = [[NSMutableArray alloc] init];
    }
    return _piecesOfPlayer0;
}

- (NSMutableArray *)pieces
{
    if (!_pieces) {
        _pieces = [[NSMutableArray alloc] init];
    }
    return _pieces;
}

- (NSMutableArray *)piecesOfPlayer1
{
    if (!_piecesOfPlayer1) {
        _piecesOfPlayer1 = [[NSMutableArray alloc] init];
    }
    return _piecesOfPlayer1;
}

#pragma mark - initialization

- (instancetype)init
{
    self = [super init];
    _chosenPiece = nil;
    if (self) {
        _currentPlayer = 1;
        //init GridCells
        for (NSUInteger row = 0; row < 9; row++) {
            for (NSUInteger column = 0; column < 7; column++) {
                GridCell *gridCell = [[GridCell alloc] init];
                gridCell.row = row;
                gridCell.column = column;
                
                if ((row == 0 || row == 8) && column == 3) {
                    //兽穴图片,GridCell属性为兽穴根据row判断正反
                    gridCell.cellType = @"Lair";
                    if (row < 3 ) {
                        gridCell.player = 0;
                    } else {
                        gridCell.player = 1;
                    }
                } else if ((column == 2 && (row == 0 || row == 8))
                           || (column == 3 && (row == 1 || row == 7))
                           ||(column == 4 && (row == 0 || row == 8))) {
                    //陷阱图片 gridcell属性更改,根据row判断正反
                    gridCell.cellType = @"Trap";
                    if (row < 3 ) {
                        gridCell.player = 0;
                    } else {
                        gridCell.player = 1;
                    }
                    
                } else if ((row >= 3 && row <= 5)
                           && (column != 0 && column != 3 && column != 6)) {
                    // setbackground : Water,gridcell更改
                    
                    gridCell.cellType = @"Water";
                } else {
                    //gridcell 为normall
                    gridCell.cellType = @"Normal";
                }
                
                [self.gridCellArray insertObject:gridCell atIndex:(7 * row + column)];
            }
        }
        
        [self.piecesOfPlayer1 addObject:@"fuck"];
        //init Pieces
        for (NSUInteger player = 0; player <= 1; player++) {
            for (NSUInteger type = 0; type < 8; type++) {
                Piece *piece = [[Piece alloc] init];
                piece.player = player;
                
                
                switch (type) {
                    case kMouse:
                        piece.pieceType = kMouse;
                        piece.row = 2;
                        piece.column = 0;
                        break;
                    case kCat:
                        piece.pieceType = kCat;
                        piece.row = 1;
                        piece.column = 5;
                        break;
                    case kWolf:
                        piece.pieceType = kWolf;
                        piece.row = 2;
                        piece.column = 4;
                        break;
                    case kDog:
                        piece.pieceType = kDog;
                        piece.row = 1;
                        piece.column = 1;
                        break;
                    case kLeopard:
                        piece.pieceType = kLeopard;
                        piece.row = 2;
                        piece.column = 2;
                        break;
                    case kTiger:
                        piece.pieceType = kTiger;
                        piece.row = 0;
                        piece.column = 6;
                        break;
                    case kLion:
                        piece.pieceType = kLion;
                        piece.row = 0;
                        piece.column = 0;
                        break;
                    case kElephant:
                        piece.pieceType = kElephant;
                        piece.row = 2;
                        piece.column = 6;
                        break;
                    default:
                        break;
                }
                if (player == 1) {
                    piece.row = 8 - piece.row;
                    piece.column = 6 - piece.column;
                    //     [self.piecesOfPlayer1 addObject:piece];
                } else if (player == 0) {
                    //     [self.piecesOfPlayer0 addObject:piece];
                }
                [self.pieces addObject:piece];
            }
        }
        
    }
    return self;
}

#pragma mark - game methods

- (BOOL)checkAnyAvailablePieceAtRow:(NSUInteger)row andColumn:(NSUInteger)column
{
    BOOL result = NO;
    
    
    if (self.pieces) {
        for (int index = 0; index < [self.pieces count]; index++) {
            Piece *piece = [self.pieces objectAtIndex:index];
            
            if (piece.row == row && piece.column == column && piece.player == self.currentPlayer) {
                //piece改为chosen,需要重新放入pieces中(会更新显示) 同时把chosenpiece设为该piece.
                
                result = YES;
                break;
            }
        }
    }
    
    
    
    return result;
}

- (void)choosePieceAtRow:(NSUInteger)row andColumn:(NSUInteger)column
{
    for (int index = 0; index < [self.pieces count]; index++) {
        Piece *piece = [self.pieces objectAtIndex:index];
        if (piece.chosen) {
            piece.chosen = NO;
            //     [self.pieces replaceObjectAtIndex:index withObject:piece];
        }
    }
    self.chosenPiece = nil;
    
    for (int index = 0; index < [self.pieces count]; index++) {
        Piece *piece = [self.pieces objectAtIndex:index];
        if (piece.row == row && piece.column == column) {
            piece.chosen = YES;
            self.chosenPiece = piece;
            // [self.pieces replaceObjectAtIndex:index withObject:piece];
        }
        
    }
    for (int index = 0; index < [self.pieces count]; index++) {
        Piece *piece = [self.pieces objectAtIndex:index];
        if (piece.chosen) {
            NSLog(@"chosen piece type: %d",piece.pieceType);
            //     [self.pieces replaceObjectAtIndex:index withObject:piece];
        }
    }
    
}

- (BOOL)checkTheActionAtRow:(NSUInteger)row andColumn:(NSUInteger)column
{
    if (!self.chosenPiece) {
        NSLog(@"check without choose!!");
        return NO;
        
    }
    
    
    BOOL result = NO;
    GridCell *gridCell = [self.gridCellArray objectAtIndex: (7 * row + column)];
    int vertical = self.chosenPiece.row - row;
    int verticalValue = abs(vertical);
    int horizontal = self.chosenPiece.column - column;
    int horizontalValue = abs(horizontal);
    
    if (verticalValue == 0 && horizontalValue == 0) {
        return NO;
    } else if ((verticalValue == 1 && horizontalValue == 0) || (verticalValue == 0 && horizontalValue == 1)) {
        //上下左右
        
        if ([gridCell.cellType isEqualToString:@"Normal"]) {
            result = [self checkIfChosenPiece:self.chosenPiece canBeMoveToRow:row andColumn:column];
            
        } else if ([gridCell.cellType isEqualToString:@"Water"]) {
            if (self.chosenPiece.pieceType == kMouse) {
                result = [self checkIfChosenPiece:self.chosenPiece canBeMoveToRow:row andColumn:column];
            }
            
            
        } else if ([gridCell.cellType isEqualToString:@"Trap"]) {
            //trap逻辑
            if (gridCell.player == self.currentPlayer) {
                result = YES;
            } else {
                result = [self checkIfChosenPiece:self.chosenPiece canBeMoveToRow:row andColumn:column];
            }
            
        } else if ([gridCell.cellType isEqualToString:@"Lair"]) {
            self.winner = self.currentPlayer;
            result = YES;
        }
        
    } else if ((verticalValue > 1 && horizontalValue == 0 ) || (horizontalValue > 1 && verticalValue == 0 )){
                    NSLog(@"horizontal jump 0");
        if ([gridCell.cellType isEqualToString:@"Normal"]
            && (self.chosenPiece.pieceType == kTiger || self.chosenPiece.pieceType == kLion)) {
            //测试是否连续水
            NSLog(@"horizontal jump 1");
            NSUInteger blockSum = 0;
            NSUInteger pieceSum = 0;
            int betweenCellSum;
            if (self.chosenPiece.row == row && horizontalValue > 1) {
                NSLog(@"horizontal jump 2");
                betweenCellSum = horizontalValue - 1;
                NSUInteger maxColumn = MAX(self.chosenPiece.column, column);
                NSUInteger minColumn = MIN(self.chosenPiece.column, column);
                
                for (NSUInteger betweenColumn = minColumn + 1; betweenColumn < maxColumn; betweenColumn++) {
                    if ([self checkWaterOrNotAtRow:row andColumn:betweenColumn]) {
                        blockSum++;
                    }
                    if ([self checkAnyPieceAtRow:row andColumn:betweenColumn]) {
                        pieceSum++;
                    }
                }
            } else if (self.chosenPiece.column == column && verticalValue > 1) {
    
                betweenCellSum = verticalValue -1;
                NSUInteger maxRow = MAX(self.chosenPiece.row, row);
                NSUInteger minRow = MIN(self.chosenPiece.row, row);
                for (NSUInteger betweenRow = minRow + 1; betweenRow < maxRow; betweenRow++) {
                    if ([self checkWaterOrNotAtRow:betweenRow andColumn:column]) {
                        blockSum++;
                    }
                    if ([self checkAnyPieceAtRow:betweenRow andColumn:column]) {
                        pieceSum++;
                    }
                }
            } else {
                //其他格子,do nothing
                NSLog(@"can not action on that block!");
            }
            if (blockSum == betweenCellSum && pieceSum == 0) { //中间全是水而且没老鼠,则判断能不能走
                NSLog(@"last checking");
                result = [self checkIfChosenPiece:self.chosenPiece canBeMoveToRow:row andColumn:column];
            }
        }
    }
    
    if (result) {
        NSLog(@"Action!!!");
        self.chosenPiece = nil;
        if (self.currentPlayer == 0) {
            self.currentPlayer = 1;
        } else {
            self.currentPlayer = 0;
        }
    }
    
    
    return result;
}

- (BOOL)checkWaterOrNotAtRow:(NSUInteger)row andColumn:(NSUInteger)column
{
    GridCell *gridCell = [self.gridCellArray objectAtIndex:(7 * row + column)];
    if ([gridCell.cellType isEqualToString:@"Water"]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)checkAnyPieceAtRow:(NSUInteger)row andColumn:(NSUInteger)column
{
    for (Piece *piece in self.pieces) {
        if (piece.row == row && piece.column == column) {
            return YES;
        }
    }
    return NO;
}


- (BOOL)checkIfChosenPiece:(Piece *)chosenPiece canBeMoveToRow:(NSUInteger)row andColumn:(NSUInteger)column
{
    BOOL pieceExist = NO;
    BOOL compareResult = NO;
    for (int index = 0; index < [self.pieces count]; index++ ) {
        Piece *piece = [self.pieces objectAtIndex:index];
        if (piece.row == row && piece.column == column && piece.player != self.chosenPiece.player) {
            pieceExist = YES;
            //格子上有敌方棋子
            if (self.chosenPiece.pieceType >= piece.pieceType && !(self.chosenPiece.pieceType == kElephant && piece.pieceType == kMouse)) {
                compareResult = YES;
            } else if (self.chosenPiece.pieceType == kMouse && piece.pieceType == kElephant) {//老鼠在水中情况.
                GridCell *chosenGridCell = [self.gridCellArray objectAtIndex:(7 * self.chosenPiece.row + self.chosenPiece.column)];
                if ([chosenGridCell.cellType isEqualToString:@"Water"]) {
                    compareResult = NO;
                } else {
                    compareResult = YES;
                }
            } else {
                compareResult = NO;
            }
            //可以吃return YES,否则return NO
            break;
        }
        
    }
    if (pieceExist == NO) {
        return YES;
    } else {
        return compareResult;
    }
}

@end
