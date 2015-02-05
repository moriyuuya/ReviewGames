//
//  ViewController.m
//  ReviewGames
//
//  Created by 森　祐哉 on 2015/02/05.
//  Copyright (c) 2015年 森　祐哉. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIBezierPath *bezierPath;
    UIImage *lastDrawImage;
    NSMutableArray *undoStack;
    NSMutableArray *redoStack;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    undoStack = [NSMutableArray array];
    redoStack = [NSMutableArray array];
    
    // ボタンのenabledを設定します。
    self.undoBtn.enabled = NO;
    self.redoBtn.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)undoBtnPressed:(id)sender
{
    // undoスタックからパスを取り出しredoスタックに追加します。
    UIBezierPath *undoPath = undoStack.lastObject;
    [undoStack removeLastObject];
    [redoStack addObject:undoPath];
    
    // 画面をクリアします。
    lastDrawImage = nil;
    self.canvas.image = nil;
    
    // 画面にパスを描画します。
    for (UIBezierPath *path in undoStack) {
        [self drawLine:path];
        lastDrawImage = self.canvas.image;
    }
    
    // ボタンのenabledを設定します。
    self.undoBtn.enabled = (undoStack.count > 0);
    self.redoBtn.enabled = YES;
}

- (IBAction)redoBtnPressed:(id)sender
{
    // redoスタックからパスを取り出しundoスタックに追加します。
    UIBezierPath *redoPath = redoStack.lastObject;
    [redoStack removeLastObject];
    [undoStack addObject:redoPath];
    
    // 画面にパスを描画します。
    [self drawLine:redoPath];
    lastDrawImage = self.canvas.image;
    
    // ボタンのenabledを設定します。
    self.undoBtn.enabled = YES;
    self.redoBtn.enabled = (redoStack.count > 0);
}

- (IBAction)clearBtnPressed:(id)sender
{
    // 保持しているパスを全部削除します。
    [undoStack removeAllObjects];
    [redoStack removeAllObjects];
    
    // 画面をクリアします。
    lastDrawImage = nil;
    self.canvas.image = nil;
    
    // ボタンのenabledを設定します。
    self.undoBtn.enabled = NO;
    self.redoBtn.enabled = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // タッチした座標を取得します。
    CGPoint currentPoint = [[touches anyObject] locationInView:self.canvas];
    
    // ボタン上の場合は処理を終了します。
    if (CGRectContainsPoint(self.undoBtn.frame, currentPoint)
        || CGRectContainsPoint(self.redoBtn.frame, currentPoint)
        || CGRectContainsPoint(self.clearBtn.frame, currentPoint)){
        return;
    }
    
    // パスを初期化します。
    bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineCapStyle = kCGLineCapRound;
    bezierPath.lineWidth = 4.0;
    [bezierPath moveToPoint:currentPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // タッチ開始時にパスを初期化していない場合は処理を終了します。
    if (bezierPath == nil){
        return;
    }
    
    // タッチした座標を取得します。
    CGPoint currentPoint = [[touches anyObject] locationInView:self.canvas];
    
    // パスにポイントを追加します。
    [bezierPath addLineToPoint:currentPoint];
    
    // 線を描画します。
    [self drawLine:bezierPath];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // タッチ開始時にパスを初期化していない場合は処理を終了します。
    if (bezierPath == nil){
        return;
    }
    
    // タッチした座標を取得します。
    CGPoint currentPoint = [[touches anyObject] locationInView:self.canvas];
    
    // パスにポイントを追加します。
    [bezierPath addLineToPoint:currentPoint];
    
    // 線を描画します。
    [self drawLine:bezierPath];
    
    // 今回描画した画像を保持します。
    lastDrawImage = self.canvas.image;
    
    // undo用にパスを保持して、redoスタックをクリアします。
    [undoStack addObject:bezierPath];
    [redoStack removeAllObjects];
    bezierPath = nil;
    
    // ボタンのenabledを設定します。
    self.undoBtn.enabled = YES;
    self.redoBtn.enabled = NO;
}

- (void)drawLine:(UIBezierPath*)path
{
    // 非表示の描画領域を生成します。
    UIGraphicsBeginImageContext(self.canvas.frame.size);
    
    // 描画領域に、前回までに描画した画像を、描画します。
    [lastDrawImage drawAtPoint:CGPointZero];
    
    // 色をセットします。
    [[UIColor blackColor] setStroke];
    
    // 線を引きます。
    [path stroke];
    
    // 描画した画像をcanvasにセットして、画面に表示します。
    self.canvas.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 描画を終了します。
    UIGraphicsEndImageContext();
}

@end