//
//  ZYControlCreationTool.h
//  AnimationTestDemo
//
//  Created by JayZY on 15/12/11.
//  Copyright © 2015年 MountainJ. All rights reserved.
// 快速创建Label,Button

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface ZYControlCreationTool : NSObject


+ (instancetype)sharedControlTool;



/**
 *  创建一个Label
 */
+(UILabel *)labelWithFrame:(CGRect)frame
           backGroundColor:(UIColor *)backGroundColor
                 textColor:(UIColor *)textColor
                  textFont:(UIFont *)font
             textAlignment:(NSTextAlignment*)alignment
                 addToView:(UIView *)targetView
                 labelText:(NSString *)labelText;
/**
 *  创建一个Button
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame
              backGroundColor:(UIColor *)backGroundColor
                    textColor:(UIColor *)textColor
                  clickAction:(SEL)actionSel
                  clickTarget:(id)aTarget
                    addToView:(UIView *)targetView
                   buttonText:(NSString *)btnText;
/**
 *  自动添加上图下文按钮到视图上,实现点击
 *
 *  @param pictureArray 存储图片的数组
 *  @param textArray    存储文字的数组
 *  @param fontSize     文字的字体
 *  @param parentView   添加到哪一个视图上
 *  @param buttonSize   按钮的尺寸
 *  @param iconSize     显示图标的尺寸
 *  @param target       添加对象
 *  @param firstTag     第一个按钮的tag
 */
+(void)creatButtonsUPPictureArray :(NSArray *)pictureArray downTextArray:(NSArray *)textArray
                          textFont:(CGFloat)fontSize addToView :(UIView *)parentView
                          toTarget:(id)target buttonFirstTag:(NSInteger)firstTag actionClick:(SEL)aClickAciton;


/**
 *  计时器开始计时
 *
 *  @param timeCount    计时时间
 *  @param vefityButton 改变状态的按钮
 */
- (void)startCountTimeWithTimeInterval:(NSUInteger)timeCount
                         changedButton:(UIButton *)vefityButton;





@end
