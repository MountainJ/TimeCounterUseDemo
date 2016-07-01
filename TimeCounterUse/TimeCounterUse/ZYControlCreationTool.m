//
//  ZYControlCreationTool.m
//  AnimationTestDemo
//
//  Created by JayZY on 15/12/11.
//  Copyright © 2015年 MountainJ. All rights reserved.
//

#import "ZYControlCreationTool.h"

#define kDownLabelEstimatedH 30.0 //上图下文按钮下方文字高度

@interface ZYControlCreationTool ()

{
    dispatch_source_t _timeQueue;
    NSUInteger _timeCountNum;
}

@end



@implementation ZYControlCreationTool

+(instancetype)sharedControlTool
{
    static ZYControlCreationTool *controlTool;
    if (!controlTool) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            controlTool = [[self alloc] init];
        });
        
    }
    return controlTool;
}

/**
 *  创建一个Label
 */
+(UILabel *)labelWithFrame:(CGRect)frame
           backGroundColor:(UIColor *)backGroundColor
                 textColor:(UIColor *)textColor
                  textFont:(UIFont *)font
             textAlignment:(NSTextAlignment*)alignment
                 addToView:(UIView *)targetView
                 labelText:(NSString *)labelText
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = backGroundColor;
    label.textColor = textColor;
    label.font = font;
    label.text = labelText;
    label.textAlignment = *(alignment);
    [targetView addSubview:label];
    return label;
}
/**
 *  创建一个Button
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame backGroundColor:(UIColor *)backGroundColor textColor:(UIColor *)textColor  clickAction:(SEL)actionSel clickTarget:(id)aClass   addToView:(UIView *)targetView buttonText:(NSString *)btnText
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =frame;
    btn.backgroundColor = backGroundColor;
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    [btn setTitle:btnText forState:UIControlStateNormal];
    [btn addTarget:aClass action:actionSel forControlEvents:UIControlEventTouchUpInside];
    [targetView addSubview:btn];
    return btn;
}

/**
 *  自动添加上图下文按钮到视图上,实现点击
 */
+ (void)creatButtonsUPPictureArray :(NSArray *)pictureArray downTextArray:(NSArray *)textArray textFont:(CGFloat)fontSize addToView :(UIView *)parentView  toTarget:(id)target buttonFirstTag:(NSInteger)firstTag actionClick:(SEL)aClickAciton
{
    NSAssert(parentView!=nil, @"Button should be added to a parentView");
    CGFloat horMargin = 10.0;//水平间距
    CGFloat btnWidth = (float)(parentView.bounds.size.width - horMargin*(pictureArray.count+1))/pictureArray.count;
    CGFloat btnHeight = parentView.bounds.size.height;
    CGFloat iconImgHeight = btnHeight - kDownLabelEstimatedH;
    for (int i=0; i<[pictureArray count]; i++)
    {
        //原始图片的大小
        UIImage *originImg = [UIImage imageNamed:pictureArray[i]];
        //对应尺寸生成新图片
        CGSize newImgSize = CGSizeMake(originImg.size.width*iconImgHeight/originImg.size.height, iconImgHeight);
        UIImage *newImg = [ZYControlCreationTool scaleImage:[ UIImage imageNamed:pictureArray[i]] withSize:newImgSize];
        UIButton *iconButton =[UIButton buttonWithType:UIButtonTypeCustom];
        iconButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        iconButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        
        iconButton.frame = CGRectMake(horMargin+i*(btnWidth+horMargin), 0, btnWidth, btnHeight);
        [iconButton setImage:newImg forState:UIControlStateNormal];
        [iconButton setTitle:textArray[i] forState:UIControlStateNormal];
        [iconButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        iconButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [iconButton addTarget:target action:aClickAciton forControlEvents:UIControlEventTouchUpInside];
        iconButton.tag = firstTag+i;
        
        iconButton.imageEdgeInsets = UIEdgeInsetsMake(0, iconButton.currentImage.size.width/2, 0, -iconButton.currentImage.size.width/2);
        iconButton.titleEdgeInsets = UIEdgeInsetsMake(iconButton.currentImage.size.height+2, -[ZYControlCreationTool labelWidthWithStr:iconButton.titleLabel.text font:iconButton.titleLabel.font Height:80]/2,-iconButton.currentImage.size.height+2, [ZYControlCreationTool labelWidthWithStr:iconButton.titleLabel.text font:iconButton.titleLabel.font Height:80]/2 );
        [parentView addSubview:iconButton];
    }
}

+ (UIImage*)scaleImage:(UIImage *)image withSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    UIImage *originImage =image;
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    [originImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (CGFloat)labelWidthWithStr:(NSString *)commentStr font:(UIFont *)font Height :(CGFloat)height
{
    CGSize retSize;
    NSDictionary *attribute = @{NSFontAttributeName: font};
    retSize = [commentStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    return retSize.width;
}


- (void)startCountTimeWithTimeInterval:(NSUInteger)timeCount changedButton:(UIButton *)vefityButton
{

    _timeCountNum = timeCount;
dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timeQueue = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, globalQueue);
    dispatch_source_set_timer(_timeQueue, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timeQueue, ^{
        
        if (_timeCountNum == 1) {
            dispatch_source_cancel(_timeQueue);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [vefityButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                vefityButton.backgroundColor  = [UIColor blueColor];
                vefityButton.userInteractionEnabled = YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                vefityButton.userInteractionEnabled = NO;
                _timeCountNum --;
                [vefityButton setTitle:[NSString stringWithFormat:@"%ld秒",(long)_timeCountNum] forState:UIControlStateNormal];
                vefityButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                vefityButton.backgroundColor = [UIColor lightGrayColor];
                
            });
            
        }
        
    });
    
    dispatch_resume(_timeQueue);

}


@end
