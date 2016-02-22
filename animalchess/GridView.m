//
//  GridView.m
//  animalchess
//
//  Created by 徐豪俊 on 16/1/19.
//  Copyright © 2016年 徐豪俊. All rights reserved.
//

#import "GridView.h"
#import "AnimalChessGame.h"
#import "GridCell.h"
#import "PieceView.h"
#import "Piece.h"
#import "ViewController.h"

typedef struct {
    NSUInteger row;
    NSUInteger column;
} GridIndex;

#define chessboardHeightRatio 12;
#define chessboardWidthRatio 7;



@interface GridView()

@property (assign,nonatomic) CGSize lastSize;
@property (assign,nonatomic) CGRect gridRect;
@property (assign,nonatomic) CGSize blockSize;
@property (assign,nonatomic) GridIndex touchedBlockIndex;
@property (assign,nonatomic) CGFloat gap;
@property (copy,nonatomic) NSMutableArray *PieceViews;

@property (nonatomic,strong) Piece *chosenPiece;
@property (nonatomic,strong) NSMutableArray *outPiecesOfPlayer0;
@property (nonatomic,strong) NSMutableArray *outPiecesOfPlayer1;
@end

@implementation GridView

- (NSMutableArray *)PieceViews
{
    if (!_PieceViews) {
        _PieceViews = [[NSMutableArray alloc] init];
    }
    return _PieceViews;
}

- (NSMutableArray *)outPiecesOfPlayer0
{
    if (!_outPiecesOfPlayer0) {
        _outPiecesOfPlayer0 = [[NSMutableArray alloc] init];
    }
    return _outPiecesOfPlayer0;
}

- (NSMutableArray *)outPiecesOfPlayer1
{
    if (!_outPiecesOfPlayer1) {
        _outPiecesOfPlayer1 = [[NSMutableArray alloc] init];
    }
    return _outPiecesOfPlayer1;
}

- (AnimalChessGame *)game
{
    if (!_game) {
        _game = [[AnimalChessGame alloc] init];
        _game.winner = -1;
    }
    return _game;
}

- (void)setGridRect:(CGRect)gridRect
{
    _gridRect = gridRect;
    [self setNeedsDisplay];
}

- (void)setBlockSize:(CGSize)blockSize
{
    _blockSize = blockSize;
    [self setNeedsDisplay];
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self commonInit];
    [self updatePiece];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self commonInit];
    [self updatePiece];
    return self;
}

- (void)commonInit
{
    [self calculateGridForSize:self.bounds.size];
    _touchedBlockIndex.row = NSNotFound;
    _touchedBlockIndex.column = NSNotFound;
}

- (void)calculateGridForSize:(CGSize)size
{
    CGFloat chessboardHeight;
    CGFloat chessboardWidth;
    if (size.height/size.width < 12/7.1) {
        chessboardHeight = size.height / 12 * 9;
        chessboardWidth = size.height / 12 * 7;
    } else {
        chessboardWidth = size.width;
        chessboardHeight = chessboardWidth / 7 * 9;
    }
    CGFloat cellSize = chessboardWidth / 7;
    _blockSize = CGSizeMake(cellSize, cellSize);
    _gridRect = CGRectMake((size.width - chessboardWidth) / 2 ,
                           (size.height - chessboardHeight) / 2,
                           chessboardWidth,
                           chessboardHeight);
    
}

- (void)drawRect:(CGRect)rect
{
    
    CGSize size = self.bounds.size;
    if (!CGSizeEqualToSize(size, self.lastSize)) {
        self.lastSize = size;
        [self calculateGridForSize:size];
    }
    
    //棋盘,考虑放置背景图片
    UIColor *bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"water"]];
    [self setBackgroundColor:bgColor];

    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
        [self drawRestartButton];
    
    for (NSUInteger row = 0; row < 9; row++) {
        for (NSUInteger column = 0; column < 7; column++) {
            
            [self drawBlockAtRow:row andColumn:column];
            
        }
    }
    
}


- (CGRect)restartButtonRect
{
    CGRect buttonRect;
    CGFloat rectWidth = self.gridRect.origin.x;
    CGFloat rectHeight = self.gridRect.origin.y;
    CGFloat blocklength = MIN(rectHeight, rectWidth);
    
    if (blocklength == rectWidth) {
        buttonRect = CGRectMake(0, rectHeight - blocklength, rectWidth, rectHeight);
    } else {
        buttonRect = CGRectMake(rectWidth - blocklength, 0, rectWidth, rectHeight);
    }
    return buttonRect;
}

#define CORNER_FONT_STANDARD_HEIGHT 500.0

- (CGFloat)cornerScaleFactor {return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }

- (void)drawRestartButton
{
    //[text drawInRect:buttonRect withAttributes:@{NSForegroundColorAttributeName : [self tintColor] , }];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *restartButtonFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    restartButtonFont = [restartButtonFont fontWithSize:restartButtonFont.pointSize * [self cornerScaleFactor]];
    
    NSAttributedString *restartText = [[NSAttributedString alloc] initWithString:@"重新开始" attributes:@{ NSFontAttributeName : restartButtonFont, NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : self.tintColor }];
    [restartText drawInRect:[self restartButtonRect]];
}


- (void)drawBlockAtRow:(NSUInteger)row andColumn:(NSUInteger)column
{
    
    CGFloat startX = self.gridRect.origin.x + self.blockSize.width * column;
    CGFloat startY = self.gridRect.origin.y + self.blockSize.height * row;
    CGRect blockFrame = CGRectMake(startX, startY, self.blockSize.width, self.blockSize.height);
    [self.tintColor setStroke];
    [[UIColor whiteColor] setFill];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:blockFrame];
    [path fill];
    [path stroke];
    
    GridCell *gridCell = [self.game.gridCellArray objectAtIndex:7 *row + column];
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *textFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    textFont = [textFont fontWithSize:textFont.pointSize * 1.0];
    if (gridCell) {
        if ([gridCell.cellType isEqualToString:@"Water"]) {
            [[UIImage imageNamed:@"Water"] drawInRect:blockFrame blendMode:normal alpha:0.5];
        } else if ([gridCell.cellType isEqualToString:@"Lair"]) {
            NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"兽穴" attributes:@{ NSFontAttributeName : textFont, NSParagraphStyleAttributeName : paragraphStyle }];
            
            CGRect textBounds;
            textBounds.origin = CGPointMake(startX + (_blockSize.width - text.size.width) / 2,
                                            startY + (_blockSize.height - text.size.height) / 2);
            textBounds.size = [text size];
            [text drawInRect:textBounds];
        } else if ([gridCell.cellType isEqualToString:@"Trap"]) {
            NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"陷阱" attributes:@{ NSFontAttributeName : textFont, NSParagraphStyleAttributeName : paragraphStyle }];
            
            CGRect textBounds;
            textBounds.origin = CGPointMake(startX + (_blockSize.width - text.size.width) / 2,
                                            startY + (_blockSize.height - text.size.height) / 2);
            textBounds.size = [text size];
            [text drawInRect:textBounds];
        } else {}
    }
    
}


- (void)updateView:(UIView *)view ForPiece:(Piece *)piece
{
    if ([view isKindOfClass:[PieceView class]]) {
        PieceView *pieceView = (PieceView *)view;
        pieceView.row = piece.row;
        pieceView.column = piece.column;
        pieceView.player = piece.player;
        pieceView.pieceType = piece.pieceType;
        pieceView.chosen = piece.chosen;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.touchedBlockIndex = [self touchedGridIndexFromTouches:touches];
    NSLog(@"touched row: %d, column: %d", self.touchedBlockIndex.row, self.touchedBlockIndex.column);
    [self touchedGridIndex:self.touchedBlockIndex];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    GridIndex touched = [self touchedGridIndexFromTouches:touches];
    if (touched.row != self.touchedBlockIndex.row ||
        touched.column != self.touchedBlockIndex.column) {
        _touchedBlockIndex = touched;
        [self touchedGridIndex:self.touchedBlockIndex];
    }
}

- (GridIndex)touchedGridIndexFromTouches:(NSSet<UITouch *> *)touches
{
    GridIndex result;
    result.row = -1;
    result.column = -1;
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    if (CGRectContainsPoint(_gridRect, location)) {
        location.x -= _gridRect.origin.x;
        location.y -= _gridRect.origin.y;
        result.column = location.x * 7.0 / _gridRect.size.width;
        result.row = location.y * 9.0 / _gridRect.size.height;
    } else if (CGRectContainsPoint([self restartButtonRect], location)) {
        result.column = -1;
        result.row = -1;
    }
    return result;
}

- (void)touchedGridIndex:(GridIndex)gridIndex
{
    if (gridIndex.row == -1 && gridIndex.column == -1) {
        [[NSUserDefaults standardUserDefaults] setObject:@"restart" forKey:@"restart"];
    }
    if (self.chosenOnePiece == NO) {
        //未选棋子
        //  NSLog(@"have not chose");
        if([self.game checkAnyAvailablePieceAtRow:gridIndex.row andColumn:gridIndex.column]) {
            [self.game choosePieceAtRow:gridIndex.row andColumn:gridIndex.column];
            self.chosenOnePiece = YES;
            self.chosenPiece = self.game.chosenPiece;
            [self updatePiece];
            //该piece属性已更改,pieceView自动绘制.
        }
    } else {
        // NSLog(@"already chosen row:%d column:%d",self.chosenPiece.row, self.chosenPiece.column);
        
        if ([self.game checkAnyAvailablePieceAtRow:gridIndex.row andColumn:gridIndex.column]) {
            //    NSLog(@"Change Choosing");
            self.chosenOnePiece = YES;
            self.chosenPiece = self.game.chosenPiece;
            [self.game choosePieceAtRow:gridIndex.row andColumn:gridIndex.column];
            [self updatePiece];
        } else {//确定没有可选棋子,要么没棋子要么敌方棋子
            //已选棋子
            if ([self.game checkTheActionAtRow:gridIndex.row andColumn:gridIndex.column]) {
                //如果有棋子,吃掉,没有棋子,移动
                NSLog(@"Action!");
                for (Piece *piece in self.game.pieces) {
                    if (piece.row == gridIndex.row && piece.column == gridIndex.column) {
                        if (piece.player == 0) {
                            [self.outPiecesOfPlayer0 addObject:piece];
                            piece.row = 10;
                            piece.column = [self.outPiecesOfPlayer0 indexOfObject:piece];
                        } else {
                            [self.outPiecesOfPlayer1 addObject:piece];
                            piece.row = 11;
                            piece.column = [self.outPiecesOfPlayer1 indexOfObject:piece];
                        }
                    }
                }
                
                for (Piece *piece in self.game.pieces) {
                    if (piece.chosen) {
                        piece.row = gridIndex.row;
                        piece.column = gridIndex.column;
                    }
                }
                
                self.chosenPiece = nil;
                self.chosenOnePiece = NO;
                [self updatePiece];
                
                if (self.game.winner != -1) {
                    if (self.game.winner == 1) {
                        self.message = @"红方获胜";
                    } else if (self.game.winner == 0) {
                        self.message = @"黑方获胜";
                    }
                    [[NSUserDefaults standardUserDefaults] setObject:self.message forKey:@"winner"];
                }
            }
        }
        
    }
}

- (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}


- (void)restartGame
{
    self.game = nil;
    [self updatePiece];
}

- (void)updatePiece
{
    if ([self.PieceViews count] < 16) {
        
        //creat cardView and frame
        self.PieceViews = nil;
        for (Piece *piece in self.game.pieces) {
            CGRect blockFrame = [self blockFrameForPiece:piece];
            PieceView *pieceView = [[PieceView alloc] initWithFrame:blockFrame];
            
            [self updateView:pieceView ForPiece:piece];
            pieceView.bounds = blockFrame;
            NSLog(@"%d", pieceView.pieceType);
            
            [self addSubview:pieceView];
            [self.PieceViews addObject:pieceView];
            
        }
        
    } else if ([self.PieceViews count] == 16) {
        //updateCardView and frame,如果pieceView和piece frame(row+column)相同,则不动, 否则animate移动frame
        //first,检查
        for (int index = 0; index < [self.game.pieces count]; index++) {
            PieceView *pieceView = [self.PieceViews objectAtIndex:index];
            Piece *piece = [self.game.pieces objectAtIndex:index];
            if (pieceView.row != piece.row || pieceView.column != piece.column) {
                CGRect blockFrame = [self blockFrameForPiece:piece];
                
                [UIView animateWithDuration:0.5
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     pieceView.frame = blockFrame;
                                 } completion:NULL];
            }
        }
        
        
        
        //last, update state(choose)
        for (int index = 0; index < [self.game.pieces count]; index++ ) {
            Piece *piece = [self.game.pieces objectAtIndex:index];
            PieceView *pieceView = [self.PieceViews objectAtIndex:index];
            [self updateView:pieceView ForPiece:piece];
        }
    }
}

- (CGRect)blockFrameForPiece:(Piece *)piece
{
    CGFloat startX = self.gridRect.origin.x + self.blockSize.width * piece.column;
    CGFloat startY = self.gridRect.origin.y + self.blockSize.height * piece.row;
    CGRect blockFrame = CGRectMake(startX, startY, self.blockSize.width, self.blockSize.height);
    return blockFrame;
}

- (void)awakeFromNib
{
    [self updatePiece];
}


@end
