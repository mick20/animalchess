//
//  ViewController.m
//  animalchess
//
//  Created by 徐豪俊 on 16/1/19.
//  Copyright © 2016年 徐豪俊. All rights reserved.
//

#import "ViewController.h"
#import "GridView.h"

@interface ViewController ()

@property (nonatomic,strong) GridView *gridView;

@end

@implementation ViewController
- (IBAction)newGame:(UIButton *)sender {
    [self.gridView restartGame];
    
}
-(void)dosomething{
    //do nothing. just test
    //test again;
    
    //something will failing!!!
    //修复错误
}

- (GridView *)gridView
{
    if (!_gridView) {
        _gridView = [[GridView alloc] initWithFrame:self.view.bounds];
        _gridView.chosenOnePiece = NO;
        _gridView.currentPlayer = 1;
    }
    return _gridView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    [self.view addSubview:self.gridView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAlertForNewGame)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
    
}

- (void)showAlertForNewGame
{
    
    id restartString = [[NSUserDefaults standardUserDefaults] valueForKey:@"restart"];
    if (self.gridView.message) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"游戏结束"
                                                                   message:self.gridView.message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"再来一局"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [self.gridView restartGame];
                                                   }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
     //       [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"winner"];
    } else if ([restartString isEqualToString:@"restart"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"重新开始一局游戏"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * confirmButton = [UIAlertAction actionWithTitle:@"确定"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [self.gridView restartGame];
                                                       }];
        UIAlertAction * cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                                 style:UIAlertActionStyleCancel
                                                               handler:nil];
        [alert addAction:confirmButton];
        [alert addAction:cancelButton];

        [self presentViewController:alert animated:YES completion:nil];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"restart"];
    }
    
    

}

@end
