//
//  RichTextView.h
//  RichText
//
//  Created by v2m on 14-9-3.
//  Copyright (c) 2014年 v2m. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextInfo.h"

@interface RichTextView : UIView

@property (nonatomic,strong) NSString* text;
@property (nonatomic,strong) NSDictionary* attributeInfo;

@property (nonatomic,strong) TextInfo* info;

@end
