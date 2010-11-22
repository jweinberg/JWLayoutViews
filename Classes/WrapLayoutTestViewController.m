//  Copyright (c) 2010, Josh Weinberg
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  * Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  * Neither the name of the Josh Weinberg nor the
//  names of its contributors may be used to endorse or promote products
//  derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL Josh Weinberg BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "WrapLayoutTestViewController.h"
#import "JWWrapLayoutView.h"

@implementation WrapLayoutTestViewController

@synthesize layoutView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    //layoutView.minRowHeight = 100.0;
    layoutView.verticalRowAlignment = JWVerticalRowAlignmentCenter;
    layoutView.horizontalRowAlignment = JWHorizontalRowAlignmentCenter;
}

#define UNIFORM_RAND() ((float)rand()/RAND_MAX)

- (void)sizeAnimate:(UIView*)sender;
{
    //[UIView beginAnimations:nil context:nil];
    CGRect r = sender.frame;
    r.size = CGSizeMake(UNIFORM_RAND() * 25.0f + 25.0f, UNIFORM_RAND() * 25.0f + 25.0f);
    sender.frame = r;
//    [UIView commitAnimations];
}

- (IBAction)addTestView:(id)sender;
{
    UIButton * tmp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [tmp addTarget:self action:@selector(sizeAnimate:) forControlEvents:UIControlEventTouchUpInside];
    [tmp setFrame:CGRectMake(0, 0, 50, 50)];
    tmp.backgroundColor = [UIColor colorWithRed:UNIFORM_RAND() green:UNIFORM_RAND() blue:UNIFORM_RAND() alpha:1.0];
    [layoutView addSubview:tmp];
}

- (IBAction)setLeft:(UISlider*)sender;
{
    insets.left = sender.value;
    layoutView.subviewMargins = insets;
}

- (IBAction)setTop:(UISlider*)sender;
{
    insets.top = sender.value;
    layoutView.subviewMargins = insets;
}

- (IBAction)setRight:(UISlider*)sender;
{
    insets.right = sender.value;
    layoutView.subviewMargins = insets;
}

- (IBAction)setBottom:(UISlider*)sender;
{
    insets.bottom = sender.value;
    layoutView.subviewMargins = insets;
}

- (IBAction)horiz:(id)sender;
{
    switch (layoutView.horizontalRowAlignment)
    {
        case JWHorizontalRowAlignmentCenter:
            layoutView.horizontalRowAlignment = JWHorizontalRowAlignmentRight;
            break;
        case JWHorizontalRowAlignmentRight:
            layoutView.horizontalRowAlignment = JWHorizontalRowAlignmentLeft;
            break;
        case JWHorizontalRowAlignmentLeft:
            layoutView.horizontalRowAlignment = JWHorizontalRowAlignmentCenter;
            break;
    }
}

- (IBAction)vert:(id)sender;
{
    switch (layoutView.verticalRowAlignment)
    {
        case JWVerticalRowAlignmentCenter:
            layoutView.verticalRowAlignment = JWVerticalRowAlignmentBottom;
            break;
        case JWVerticalRowAlignmentBottom:
            layoutView.verticalRowAlignment = JWVerticalRowAlignmentTop;
            break;
        case JWVerticalRowAlignmentTop:
            layoutView.verticalRowAlignment = JWVerticalRowAlignmentCenter;
            break;
    }    
}

- (void)dealloc 
{
    [layoutView release], layoutView = nil;
    [super dealloc];
}

@end
