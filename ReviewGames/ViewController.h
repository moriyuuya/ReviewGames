//
//  ViewController.h
//  ReviewGames
//
//  Created by 森　祐哉 on 2015/02/05.
//  Copyright (c) 2015年 森　祐哉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *canvas;
@property (weak, nonatomic) IBOutlet UIButton *undoBtn;
@property (weak, nonatomic) IBOutlet UIButton *redoBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;

- (IBAction)undoBtnPressed:(id)sender;
- (IBAction)redoBtnPressed:(id)sender;
- (IBAction)clearBtnPressed:(id)sender;



@end

