//
//  ViewController.h
//  RichText
//
//  Created by v2m on 14-9-2.
//  Copyright (c) 2014年 v2m. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RichTextView.h"


@interface ViewController : UIViewController<UITextViewDelegate>

@property (nonatomic,weak) IBOutlet UITextView* myTextView;

-(IBAction)pinchEvent:(id)sender;

@end
