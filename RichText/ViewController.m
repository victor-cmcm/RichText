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
    
    _info.textFont = [UIFont systemFontOfSize:40];
    
    // 颜色/colors
    _info.colorStyle = ColorStyleTwoEach;
    _info.gradientStartColor = [UIColor blueColor];
    _info.gradientEndColor = [UIColor redColor];
    
    // border
    _info.borderWidth = 0;
    _info.borderColor = [UIColor greenColor];
    _info.borderJoin = kCGLineJoinMiter;
    
    // shadow
    _info.shadowSize = CGSizeMake(0, 0);
    _info.shadowBlur = 0.0;
    _info.shadowColor = [UIColor greenColor];
    
    // alignment
    _info.alignment = NSTextAlignmentLeft;
    _info.characterSpacing = 40.0f;
    _info.lineSpacing = 40.0f;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setupTextInfo];
    
    UIView* v = _myTextView.subviews[0];
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
    paragraphStyle.minimumLineHeight = _info.lineSpacing;
    
    
    NSDictionary * textAttributes =
  @{ NSFontAttributeName            : _info.textFont,
     NSParagraphStyleAttributeName : paragraphStyle,
     NSKernAttributeName: @(_info.characterSpacing),
     NSForegroundColorAttributeName:[UIColor blackColor]
     };
    
    _myTextView.attributedText = [[NSAttributedString alloc] initWithString:@"Hello" attributes:textAttributes];
    
    v1.string = [[NSAttributedString alloc] initWithString:@"Hello" attributes:textAttributes];
    

//    UITextPosition* position = [_myTextView positionWithinRange:0 atCharacterOffset:1];
//    CGRect rect = [_myTextView caretRectForPosition:position];
//    _myTextView.font.lineHeight
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


-(void)pinchEvent:(UIPinchGestureRecognizer*)pg
{
    switch (pg.state) {
        case UIGestureRecognizerStateChanged:
            _myTextView.transform = CGAffineTransformMakeScale(pg.scale, pg.scale);
            break;
        case UIGestureRecognizerStateEnded:{
            CGRect rect = _myTextView.frame;
            CGAffineTransform transform = _myTextView.transform;
            
            _myTextView.transform = CGAffineTransformIdentity;
            _myTextView.frame = rect;
            
            
            _info.textFont = [UIFont systemFontOfSize:_info.textFont.pointSize * pg.scale];
            _info.characterSpacing *= pg.scale;
            _info.lineSpacing *= pg.scale;
            
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineHeightMultiple = _info.lineSpacing;
            paragraphStyle.maximumLineHeight = _info.lineSpacing;
            
            
            
            NSDictionary * textAttributes =
            @{ NSFontAttributeName            : _info.textFont,
               NSParagraphStyleAttributeName : paragraphStyle,
               NSKernAttributeName: @(_info.characterSpacing),
               NSForegroundColorAttributeName:[UIColor clearColor]
               };
            
            NSString* s = _myTextView.attributedText.string;
            _myTextView.attributedText = [[NSAttributedString alloc] initWithString:s attributes:textAttributes];
            
            v1.string = [[NSAttributedString alloc] initWithString:s attributes:textAttributes];
        }
            break;
            
        default:
            break;
    }
    
}

@end