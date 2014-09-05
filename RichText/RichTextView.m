//
//  RichTextView.m
//  RichText
//
//  Created by v2m on 14-9-3.
//  Copyright (c) 2014年 v2m. All rights reserved.
//

#import "RichTextView.h"
#import <CoreText/CoreText.h>

@implementation RichTextView

- (void)setString:(NSAttributedString *)string
{
    _string = string;
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    NSLog(@"View rect===>:%@",NSStringFromCGRect(rect));
    
    CGRect drawRect = UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(8, 5, 8, 5));
    
    NSString* s = _string.string;
    NSRange range = NSMakeRange(0, _string.length);
    NSMutableDictionary* textAttributes = [NSMutableDictionary dictionaryWithDictionary:[_string attributesAtIndex:0 effectiveRange:&range]];
    textAttributes[NSForegroundColorAttributeName] = _info.borderColor;
    
    /*
     *===========> 画边框和阴影
     */
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetLineJoin(context, _info.borderJoin);
    CGContextSetLineWidth(context, _info.borderWidth);
    
    CGContextSetTextDrawingMode(context, kCGTextFillStroke);
    CGContextSetStrokeColorWithColor(context, _info.borderColor.CGColor);
    CGContextSetShadowWithColor(context, _info.shadowSize, _info.shadowBlur, _info.shadowColor.CGColor);

    
    NSAttributedString* as = [[NSAttributedString alloc] initWithString:s attributes:textAttributes];
    [as drawInRect:drawRect];
//    [s drawInRect:drawRect withAttributes:textAttributes];
    CGContextRestoreGState(context);
    
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    
    //**
    // get line ========>
    //**
    // Create the framesetter with the attributed string.
    NSMutableAttributedString* strstr = [[NSMutableAttributedString alloc] initWithAttributedString:_string];
    [strstr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, _string.string.length)];
    
    CGRect drawRect2 = drawRect;
    drawRect2.size.height += 1000;
    CGPathRef path = CGPathCreateWithRect(drawRect2, NULL);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)strstr);
    
    // Create a frame.
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0, 0), path, NULL);
    
    
    // Draw the specified frame in the given context.
    //    CTFrameDraw(frame, context);
    
    CFArrayRef lines = CTFrameGetLines(frame);
    CFIndex linesCount = CFArrayGetCount(lines);
    
    NSLog(@"count:%ld",linesCount);
    
    CGPoint origins[linesCount];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    
    for (CFIndex i = 0; i < linesCount; i++) {
        NSLog(@"origin%ld:%@",i,NSStringFromCGPoint(origins[i]));
    }
    
//    for (CFIndex i = 0; i < linesCount; i++) {
//        CFRange range = CTLineGetStringRange(CFArrayGetValueAtIndex(lines, i));
//        NSString* s = [_string.string substringWithRange:NSMakeRange(range.location, range.length)];
//        NSLog(@"string%ld:%@",i,s);
//    }

    
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, drawRect2.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGFloat totalLeading = 0;
    for (int i = 0; i< linesCount; i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        CGRect lineRect1 = CTLineGetBoundsWithOptions(line,kCTLineBoundsUseOpticalBounds);
        //                CTFontRef
        
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        int count = CFArrayGetCount(runs);
        for (int i = 0; i<count; i++) {
            CTRunRef run = CFArrayGetValueAtIndex(runs, i);
            CGFloat ascent, descent, leading ;
            CGFloat width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading);
            
            NSLog(@"RUN==>ascent:%f,decent:%f,leading:%f",ascent,descent,leading);
        }
        
        
        //                NSLog(@"rect%d:%@",i,NSStringFromCGRect(lineRect1));
        
        
        
        
        CGFloat ascent, descent, leading ;
        CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading) ;
        CGRect lineRect = CGRectMake(0, 0, width, ascent+descent+leading) ;
        
        lineRect.origin = origins[i];
        
        
        NSLog(@"ascent:%f,decent:%f,leading:%f",ascent,descent,leading);
        
        totalLeading += (lineRect.size.height - _info.textFont.lineHeight) + leading;
        lineRect.origin.x = origins[i].x + drawRect2.origin.x ;
        lineRect.origin.y =  origins[i].y - drawRect2.origin.y + totalLeading ;
        
        //                lineRect.size.height = lineRect1.size.height;
        
        
        
        NSLog(@"rect%d:%@ leading:%f",i,NSStringFromCGRect(lineRect),totalLeading);
        
//        CGRect r1 = CGRectMake(lineRect.origin.x,lineRect.origin.y,lineRect.size.width,lineRect.size.height / 2);
//        CGRect r2 = CGRectMake(lineRect.origin.x,lineRect.origin.y + lineRect.size.height / 2,lineRect.size.width,lineRect.size.height / 2);
//        
//        CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
//        CGContextFillRect(context, r1);
//        CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
//        CGContextFillRect(context, r2);
        CGContextSetTextPosition(context, lineRect.origin.x, lineRect.origin.y);
        CTLineDraw(line, context);
    }
    CGContextRestoreGState(context);
    
    return;
    
    //**
    // ========> mask
    //**
    
    // create mask
    CGImageRef alphaMask = NULL;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    CGContextRef subContext = UIGraphicsGetCurrentContext();
    [s drawInRect:drawRect withAttributes:textAttributes];
    alphaMask = CGBitmapContextCreateImage(subContext);
    UIGraphicsEndImageContext();

    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, drawRect2.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
//    CGContextClipToMask(context, self.bounds, alphaMask);

    NSArray *Ocolors = [NSArray arrayWithObjects:_info.gradientStartColor,_info.gradientEndColor, nil];
    switch (_info.colorStyle) {
        case ColorStyleGradientLinearEach:
        {
            //create array of pre-blended CGColors
            NSMutableArray *colors = [NSMutableArray arrayWithCapacity:0];
            for (UIColor *color in Ocolors)
            {
                UIColor *blended = [self FXLabel_color:color.CGColor blendedWithColor:_info.gradientStartColor.CGColor];
                            [colors addObject:(__bridge id)blended.CGColor];
            }
        
            //draw gradient
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 0, self.bounds.size.height);
            CGContextScaleCTM(context, 1.0, -1.0);
        
            CGGradientRef gradient = CGGradientCreateWithColors(NULL, (__bridge CFArrayRef)colors, NULL);
        
            for (int i = 0; i< linesCount; i++) {
                CTLineRef line = CFArrayGetValueAtIndex(lines, i);
                
                CGRect rect = CTLineGetBoundsWithOptions(line,0);
                rect.origin = origins[i];
                
                CGContextSaveGState(context);
        
                CGContextClipToRect(context, rect);
                CGPoint startPoint = CGPointMake(rect.origin.x,rect.origin.y);
                CGPoint endPoint = CGPointMake(rect.origin.x,
                                                           rect.origin.y + rect.size.height);
                CGContextDrawLinearGradient(context, gradient, startPoint, endPoint,
                                                        kCGGradientDrawsAfterEndLocation | kCGGradientDrawsBeforeStartLocation);
                CGContextRestoreGState(context);
            }
        
            CGGradientRelease(gradient);
            CGContextRestoreGState(context);
        }
                        break;
        case ColorStyleGradientLinearWhole:
        {
            NSArray* _gradientColors = @[_info.gradientStartColor,_info.gradientEndColor];
            NSMutableArray *colors = [NSMutableArray arrayWithCapacity:[_gradientColors count]];
            for (UIColor *color in _gradientColors)
            {
                UIColor *blended = [self FXLabel_color:color.CGColor blendedWithColor:[UIColor blackColor].CGColor];
                [colors addObject:(__bridge id)blended.CGColor];
            }
            
            //draw gradient
            CGContextSaveGState(context);
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextTranslateCTM(context, 0, -self.bounds.size.height);
            CGContextTranslateCTM(context, 0, 0);
            
            CGGradientRef gradient = CGGradientCreateWithColors(NULL, (__bridge CFArrayRef)colors, NULL);
            CGPoint startPoint = CGPointMake((CGRectGetMaxX(drawRect) - drawRect.origin.x) / 2, drawRect.origin.y);
            CGPoint endPoint = CGPointMake((CGRectGetMaxX(drawRect) - drawRect.origin.x) / 2, CGRectGetMaxY(drawRect));
            CGContextDrawLinearGradient(context, gradient, startPoint, endPoint,
                                        kCGGradientDrawsAfterEndLocation | kCGGradientDrawsBeforeStartLocation);
            
            CGGradientRelease(gradient);
            CGContextRestoreGState(context);
        }
                        break;
        
        case ColorStyleTwoEach:
        {
            UIColor *color1 = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.3];
            UIColor *color2 = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.3];
        
//            CGContextSaveGState(context);
//            CGContextTranslateCTM(context, 0, self.bounds.size.height);
//            CGContextScaleCTM(context, 1.0, -1.0);
        
//            CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
        
            CGFloat totalLeading = 0;
            for (int i = 0; i< linesCount; i++) {
                CTLineRef line = CFArrayGetValueAtIndex(lines, i);
                
                CGRect lineRect1 = CTLineGetBoundsWithOptions(line,kCTLineBoundsUseOpticalBounds);
//                CTFontRef
                
                CFArrayRef runs = CTLineGetGlyphRuns(line);
                int count = CFArrayGetCount(runs);
                for (int i = 0; i<count; i++) {
                    CTRunRef run = CFArrayGetValueAtIndex(runs, i);
                    CGFloat ascent, descent, leading ;
                    CGFloat width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading);
                
                    NSLog(@"RUN==>ascent:%f,decent:%f,leading:%f",ascent,descent,leading);
                }
                
                
//                NSLog(@"rect%d:%@",i,NSStringFromCGRect(lineRect1));

                
                
                
                CGFloat ascent, descent, leading ;
                CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading) ;
                CGRect lineRect = CGRectMake(0, 0, width, ascent+descent+leading) ;

                lineRect.origin = origins[i];
                
                
                NSLog(@"ascent:%f,decent:%f,leading:%f",ascent,descent,leading);

                lineRect.origin.x = origins[i].x + drawRect2.origin.x;
                lineRect.origin.y = origins[i].y - drawRect2.origin.y;
                
//                lineRect.size.height = lineRect1.size.height;
                
                totalLeading += leading;
                
                NSLog(@"rect%d:%@",i,NSStringFromCGRect(lineRect));
                
                CGRect r1 = CGRectMake(lineRect.origin.x,lineRect.origin.y,lineRect.size.width,lineRect.size.height / 2);
                CGRect r2 = CGRectMake(lineRect.origin.x,lineRect.origin.y + lineRect.size.height / 2,lineRect.size.width,lineRect.size.height / 2);
        
                CGContextSetFillColorWithColor(context, color1.CGColor);
                CGContextFillRect(context, r1);
                CGContextSetFillColorWithColor(context, color2.CGColor);
                CGContextFillRect(context, r2);
                }
//                CGContextRestoreGState(context);
            }
            break;
        
//                    case ColorStyleGradientRadialWhole:
//                    {
//                        NSAssert(NO, @"ColorStyleGradientRadial not implement");
//                    }
//                        break;
                    default:
                        break;
                }
    
    
    [super drawRect:rect];
}

- (UIColor *)FXLabel_color:(CGColorRef)a blendedWithColor:(CGColorRef)b
{
    CGFloat aRGBA[4];
    [self FXLabel_getComponents:aRGBA forColor:a];
    CGFloat bRGBA[4];
    [self FXLabel_getComponents:bRGBA forColor:b];
    CGFloat source = aRGBA[3];
    CGFloat dest = 1.0f - source;
    return [UIColor colorWithRed:source * aRGBA[0] + dest * bRGBA[0]
                           green:source * aRGBA[1] + dest * bRGBA[1]
                            blue:source * aRGBA[2] + dest * bRGBA[2]
                           alpha:bRGBA[3] + (1.0f - bRGBA[3]) * aRGBA[3]];
}

- (void)FXLabel_getComponents:(CGFloat *)rgba forColor:(CGColorRef)color
{
    CGColorSpaceModel model = CGColorSpaceGetModel(CGColorGetColorSpace(color));
    const CGFloat *components = CGColorGetComponents(color);
    switch (model)
    {
        case kCGColorSpaceModelMonochrome:
        {
            rgba[0] = components[0];
            rgba[1] = components[0];
            rgba[2] = components[0];
            rgba[3] = components[1];
            break;
        }
        case kCGColorSpaceModelRGB:
        {
            rgba[0] = components[0];
            rgba[1] = components[1];
            rgba[2] = components[2];
            rgba[3] = components[3];
            break;
        }
        default:
        {
            rgba[0] = 0.0f;
            rgba[1] = 0.0f;
            rgba[2] = 0.0f;
            rgba[3] = 1.0f;
            break;
        }
    }
}

@end
