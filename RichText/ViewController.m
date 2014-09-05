//
//  ViewController.m
//  RichText
//
//  Created by v2m on 14-9-2.
//  Copyright (c) 2014年 v2m. All rights reserved.
//

#import "ViewController.h"
#import "CoreText/CoreText.h"


@interface ViewController ()
{
    RichTextView* v1;
}

@property(nonatomic,strong) TextInfo* info;

@end

@implementation ViewController

- (void)setupTextInfo
{
    _info = [[TextInfo alloc] init];
    
    _info.textFont = [UIFont systemFontOfSize:20.0f];
    
    // 颜色/colors
    _info.colorStyle = ColorStyleTwoEach;
    _info.gradientStartColor = [UIColor blueColor];
    _info.gradientEndColor = [UIColor redColor];
    
    // border
    _info.borderWidth = 10;
    _info.borderColor = [UIColor greenColor];
    _info.borderJoin = kCGLineJoinMiter;
    
    // shadow
    _info.shadowSize = CGSizeMake(0, 0);
    _info.shadowBlur = 0.0;
    _info.shadowColor = [UIColor greenColor];
    
    // alignment
    _info.alignment = NSTextAlignmentLeft;
    _info.characterSpacing = 40.0f;
    _info.lineSpacing = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setupTextInfo];
    
    UIView* v = _myTextView.subviews[0]; // ios 6 -2
    v1 = [[RichTextView alloc] initWithFrame:v.bounds];
    v1.backgroundColor = [UIColor clearColor];
    v1.userInteractionEnabled = NO;
    v1.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleBottomMargin;
    v1.info = _info;
    [v addSubview:v1];
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = _info.lineSpacing;
    paragraphStyle.maximumLineHeight = _info.lineSpacing;
//    paragraphStyle.minimumLineHeight = _info.lineSpacing;
//    paragraphStyle.paragraphSpacingBefore = _info.lineSpacing;
//    paragraphStyle.paragraphSpacing = _info.lineSpacing;
    
    
    
    NSDictionary * textAttributes =
  @{ NSFontAttributeName            : _info.textFont,
     NSParagraphStyleAttributeName : paragraphStyle,
     NSKernAttributeName: @(_info.characterSpacing),
     NSForegroundColorAttributeName:[UIColor clearColor]
     };
    
    _myTextView.attributedText = [[NSAttributedString alloc] initWithString:@"Hello123321gg" attributes:textAttributes];
    
    v1.string = [[NSAttributedString alloc] initWithString:@"Hello123321gg" attributes:textAttributes];
    
    
    UITextRange *startTextRange = [_myTextView characterRangeAtPoint:CGPointMake(10, 25.3599987 + 10)];
    CGRect caretRect = [_myTextView caretRectForPosition:startTextRange.end];
    CGFloat topMargin = CGRectGetMinY(caretRect);
    CGFloat lineHeight = CGRectGetHeight(caretRect);
    
//    caretRect = [_myTextView caretRectForPosition:_myTextView.selectedTextRange.end];
    CGFloat caretTop = CGRectGetMinY(caretRect);
    NSInteger lineIndex = (caretTop - topMargin) / lineHeight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)textViewDidChange:(UITextView *)textView
{
    v1.string = textView.attributedText;
}


@end
