//
//  TextInfo.h
//  RichText
//
//  Created by v2m on 14-9-3.
//  Copyright (c) 2014年 v2m. All rights reserved.
//

#import <Foundation/Foundation.h>

// 用于描述复杂的颜色样式
typedef NS_ENUM(NSInteger, ColorStyle) {
    ColorStyleNone,
    ColorStyleGradientLinearEach,   // 每个文字都线性渐变色
//    ColorStyleGradientRadialWhole,  // 全部文本径直型渐变色
    ColorStyleGradientLinearWhole,  // 全部文本
    ColorStyleTwoEach,              // 每个文字两种颜色，不渐变
    ColorStyleCount,
};

@interface TextInfo : NSObject

@property(nonatomic,strong) UIFont* textFont;

// 颜色/colors
@property (nonatomic, assign) ColorStyle    colorStyle;
@property (nonatomic, strong) UIColor       *gradientStartColor;
@property (nonatomic, strong) UIColor       *gradientEndColor;

// border
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic,strong) UIColor *borderColor;
@property (nonatomic) CGLineJoin borderJoin;

// shadow
@property (nonatomic) CGSize shadowSize;
@property (nonatomic) CGFloat shadowBlur;
@property (nonatomic, strong) UIColor* shadowColor;

// alignment
@property (nonatomic) UITextAlignment alignment;
@property (nonatomic) CGFloat characterSpacing;
@property (nonatomic) CGFloat lineSpacing;

@end
