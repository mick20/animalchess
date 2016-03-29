//
//  PieceView.m
//  animalchess
//
//  Created by 徐豪俊 on 16/1/19.
//  Copyright © 2016年 徐豪俊. All rights reserved.
//

#import "PieceView.h"
#import "Constants.h"

@interface PieceView ()

@property (nonatomic) CGRect blockRect;

@end

@implementation PieceView
#pragma mark - properties
- (void)setRow:(NSUInteger)row
{
    _row = row;
    [self setNeedsDisplay];
}

- (void)setColumn:(NSUInteger)column
{
    _column = column;
    [self setNeedsDisplay];
}

- (void)setPieceType:(int)pieceType
{
    _pieceType = pieceType;
    [self setNeedsDisplay];
}

- (void)setPlayer:(NSUInteger)player
{
    _player = player;
    [self setNeedsDisplay];
}

- (void)setChosen:(BOOL)chosen
{
    _chosen = chosen;
    [self setNeedsDisplay];
}

#pragma mark - drawing

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    
    CGFloat gap = self.bounds.size.height / 10;
    CGRect edgeRect = CGRectInset(self.bounds, gap, gap);
    UIBezierPath *OvalPath = [UIBezierPath bezierPathWithOvalInRect:edgeRect];
    [OvalPath addClip];
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    if (self.player == 0) {
        // [[UIColor blackColor] setStroke];
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    } else {
        //  [[UIColor redColor] setStroke];
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    }
    
    //[OvalPath stroke];
    CGContextAddEllipseInRect(context, edgeRect);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    UIImage *faceImage = [UIImage imageNamed:[self getPieceString]];
    if (faceImage) {
        CGRect imageRect = CGRectInset(edgeRect, 0, 0);
        [faceImage drawInRect:imageRect];
    }
    if (self.chosen) {
        UIBezierPath *mask = [UIBezierPath bezierPathWithOvalInRect:edgeRect];
        [mask addClip];
        UIColor *maskColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:0.1];
        [maskColor setFill];
        [mask fill];
    }

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *textFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    textFont = [textFont fontWithSize:textFont.pointSize * 1.0];
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:[self getPieceString] attributes:@{ NSFontAttributeName : textFont, NSParagraphStyleAttributeName : paragraphStyle }];
    
    CGRect textBounds;
    textBounds.origin = CGPointMake(edgeRect.origin.x + (edgeRect.size.width - text.size.width) / 2,
                                    edgeRect.origin.y + edgeRect.size.height - text.size.height);
    
    textBounds.size = [text size];
    

    CGRect smallOvalRect = CGRectInset(textBounds, - textBounds.size.width / 10, - textBounds.size.height / 10);
    smallOvalRect.origin.y = smallOvalRect.origin.y - textBounds.size.height / 10 / 2;
    CGContextSetLineWidth(context, 1.0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    // [smallOvalpath stroke];
    CGContextAddEllipseInRect(context, smallOvalRect);
    CGContextDrawPath(context, kCGPathFillStroke);
    [text drawInRect:textBounds];
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);

    if (self.player == 0) {
        // [[UIColor blackColor] setStroke];
        
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    } else {
        //  [[UIColor redColor] setStroke];
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    }
    
    //[OvalPath stroke];
    CGContextAddEllipseInRect(context, edgeRect);
    CGContextDrawPath(context, kCGPathFillStroke);
    
}

- (NSString *)getPieceString
{
    if (self.pieceType == kMouse) {
        return @"鼠";
    } else if (self.pieceType == kCat) {
        return @"猫";
    } else if (self.pieceType == kWolf) {
        return @"狼";
    } else if (self.pieceType == kDog) {
        return @"狗";
    } else if (self.pieceType == kLeopard)  {
        return @"豹";
    } else if (self.pieceType == kTiger) {
        return @"虎";
    } else if (self.pieceType == kLion) {
        return @"狮";
    } else if (self.pieceType == kElephant) {
        return @"象";
    } else {
        return @"?";
    }
}

#pragma mark - Initialization
- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    [self setNeedsDisplay];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self setup];
    [self setNeedsDisplay];
    return self;
}

@end
