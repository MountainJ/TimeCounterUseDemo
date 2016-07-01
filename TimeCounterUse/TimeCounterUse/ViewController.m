//
//  ViewController.m
//  TimeCounterUse
//
//  Created by JayZY on 16/7/1.
//  Copyright © 2016年 KKTJ. All rights reserved.
//

#import "ViewController.h"

#import "ZYControlCreationTool.h"

@interface ViewController ()

@property (nonatomic,strong) UIButton *verifyCodeBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor redColor];
    
    self.verifyCodeBtn = [ZYControlCreationTool buttonWithFrame:CGRectMake(50, 100, 100, 50) backGroundColor:[UIColor blueColor] textColor:[UIColor whiteColor] clickAction:@selector(startCountTime) clickTarget:self addToView:self.view buttonText:@"获取验证码"];
    
}

- (void)startCountTime
{
    [[ZYControlCreationTool sharedControlTool] startCountTimeWithTimeInterval:10 changedButton:self.verifyCodeBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
