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

#import "ConstraintLayoutTestViewController.h"
#import "JWConstraintLayoutManager.h"
#import "JWWrapLayoutManager.h"
#import "UIView+LayoutManager.h"
#import <QuartzCore/QuartzCore.h>

@implementation ConstraintLayoutTestViewController
@synthesize contentView;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
{
    return YES;
}

#define UNIFORM_RAND() ((float)rand()/RAND_MAX)
- (void)sizeAnimate:(UIView*)sender;
{
    CGRect r = sender.frame;
    r.size = CGSizeMake(UNIFORM_RAND() * 25.0f + 25.0f, UNIFORM_RAND() * 25.0f + 25.0f);
    sender.frame = r;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    center = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [center jw_setName:@"center"];
    center.frame = CGRectMake(0.0,0.0,25.0,25.0);
    center.layer.borderWidth = 2.0;
    
    JWConstraintLayoutManager *layoutManager = [[[JWConstraintLayoutManager alloc] init] autorelease];
    
    [self.contentView addSubview:center];
    
    [layoutManager addConstraint:[JWConstraint 
                               constraintWithView:@"center"
                               attribute:kJWConstraintMidY
                               relativeTo:nil
                               attribute:kJWConstraintMidY]];
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"center"
                                                     attribute:kJWConstraintMidX
                                                    relativeTo:nil
                                                     attribute:kJWConstraintMinX
                                                        offset:50]];
    
    
    UIView *bottom = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    bottom.backgroundColor = [UIColor redColor];
    bottom.layer.borderWidth = 2.0;
    [bottom jw_setName:@"bottom"];
    [self.contentView addSubview:bottom];
    
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"bottom"
                                                      attribute:kJWConstraintWidth
                                                     relativeTo:@"center"
                                                      attribute:kJWConstraintWidth]];
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"bottom"
                                                     attribute:kJWConstraintMidX
                                                    relativeTo:@"center"
                                                     attribute:kJWConstraintMidX]];
    
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"bottom"
                                                     attribute:kJWConstraintMinY
                                                    relativeTo:@"center"
                                                     attribute:kJWConstraintMaxY
                                                        offset:10.0]];
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"bottom"
                                                     attribute:kJWConstraintMaxY
                                                    relativeTo:nil
                                                     attribute:kJWConstraintMaxY
                                                        offset:-10.0]];
    
 
    UIView *top = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    top.backgroundColor = [UIColor orangeColor];
    top.layer.borderWidth = 2.0;
    [top jw_setName:@"top"];
    [self.contentView addSubview:top];
    
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"top"
                                                     attribute:kJWConstraintWidth
                                                    relativeTo:@"center"
                                                     attribute:kJWConstraintWidth]];
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"top"
                                                     attribute:kJWConstraintMidX
                                                    relativeTo:@"center"
                                                     attribute:kJWConstraintMidX]];
    
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"top"
                                                     attribute:kJWConstraintMaxY
                                                    relativeTo:@"center"
                                                     attribute:kJWConstraintMinY
                                                        offset:-10.0]];
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"top"
                                                     attribute:kJWConstraintMinY
                                                    relativeTo:nil
                                                     attribute:kJWConstraintMinY
                                                        offset:10.0]];
    
    
    UIView *right = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    right.backgroundColor = [UIColor blueColor];
    right.layer.borderWidth = 2.0;
    [right jw_setName:@"right"];
    
    [self.contentView addSubview:right];
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"right"
                                                     attribute:kJWConstraintHeight
                                                    relativeTo:@"center"
                                                     attribute:kJWConstraintHeight
                                                         scale:3.0
                                                        offset:0]];
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"right"
                                                     attribute:kJWConstraintMidY
                                                    relativeTo:@"center"
                                                     attribute:kJWConstraintMidY]];
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"right"
                                                     attribute:kJWConstraintMinX
                                                    relativeTo:@"center"
                                                    attribute:kJWConstraintMaxX
                                                        offset:10]];
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"right"
                                                     attribute:kJWConstraintMaxX
                                                    relativeTo:nil
                                                     attribute:kJWConstraintMaxX
                                                        offset:-10]];
    
    
    UIView *topRight = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    topRight.backgroundColor = [UIColor purpleColor];
    topRight.layer.borderWidth = 2.0;
    [topRight jw_setName:@"topRight"];
    [self.contentView addSubview:topRight];
    
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"topRight"
                                                     attribute:kJWConstraintWidth
                                                    relativeTo:@"right"
                                                     attribute:kJWConstraintWidth]];
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"topRight"
                                                     attribute:kJWConstraintMidX
                                                    relativeTo:@"right"
                                                     attribute:kJWConstraintMidX]];
    
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"topRight"
                                                     attribute:kJWConstraintMinY
                                                    relativeTo:nil
                                                     attribute:kJWConstraintMinY
                                                        offset:10]];
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"topRight"
                                                     attribute:kJWConstraintMaxY
                                                    relativeTo:@"right"
                                                     attribute:kJWConstraintMinY
                                                        offset:-10]];
    
    UIView *left = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    left.backgroundColor = [UIColor greenColor];
    left.layer.borderWidth = 2.0;
    [left jw_setName:@"left"];
    [self.contentView addSubview:left];
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"left"
                                                     attribute:kJWConstraintHeight
                                                    relativeTo:@"center"
                                                     attribute:kJWConstraintHeight
                                                         scale:6.0
                                                        offset:0]];
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"left"
                                                     attribute:kJWConstraintMidY
                                                    relativeTo:@"center"
                                                     attribute:kJWConstraintMidY]];
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"left"
                                                     attribute:kJWConstraintMaxX
                                                    relativeTo:@"center"
                                                     attribute:kJWConstraintMinX
                                                        offset:-10]];
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"left"
                                                     attribute:kJWConstraintMinX
                                                    relativeTo:nil
                                                     attribute:kJWConstraintMinX
                                                        offset:10]];
    
    UIView *topLeft = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    topLeft.backgroundColor = [UIColor yellowColor];
    topLeft.layer.borderWidth = 2.0;
    [topLeft jw_setName:@"topLeft"];
    [self.contentView addSubview:topLeft];
    
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"topLeft"
                                                     attribute:kJWConstraintWidth
                                                    relativeTo:@"left"
                                                     attribute:kJWConstraintWidth]];
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"topLeft"
                                                     attribute:kJWConstraintMidX
                                                    relativeTo:@"left"
                                                     attribute:kJWConstraintMidX]];
    
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"topLeft"
                                                     attribute:kJWConstraintMaxY
                                                    relativeTo:@"left"
                                                     attribute:kJWConstraintMinY
                                                        offset:-10]];
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"topLeft"
                                                     attribute:kJWConstraintMinY
                                                    relativeTo:nil
                                                     attribute:kJWConstraintMinY
                                                        offset:10]];
    
    UIView *botLeft = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    botLeft.backgroundColor = [UIColor orangeColor];
    botLeft.layer.borderWidth = 2.0;
    [botLeft jw_setName:@"botLeft"];
    
    [self.contentView addSubview:botLeft];
    
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"botLeft"
                                                     attribute:kJWConstraintWidth
                                                    relativeTo:@"left"
                                                     attribute:kJWConstraintWidth]];
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"botLeft"
                                                     attribute:kJWConstraintMidX
                                                    relativeTo:@"left"
                                                     attribute:kJWConstraintMidX]];
    
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"botLeft"
                                                     attribute:kJWConstraintMaxY
                                                    relativeTo:nil
                                                     attribute:kJWConstraintMaxY
                                                        offset:-10]];
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"botLeft"
                                                     attribute:kJWConstraintMinY
                                                    relativeTo:@"left"
                                                     attribute:kJWConstraintMaxY
                                                        offset:10]];
    
    UIView *botRight = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    botRight.backgroundColor = [UIColor magentaColor];
    botRight.layer.borderWidth = 2.0;
    [botRight jw_setName:@"botRight"];
    [self.contentView addSubview:botRight];
    
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"botRight"
                                                     attribute:kJWConstraintWidth
                                                    relativeTo:@"right"
                                                     attribute:kJWConstraintWidth]];
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"botRight"
                                                     attribute:kJWConstraintMidX
                                                    relativeTo:@"right"
                                                     attribute:kJWConstraintMidX]];
    
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"botRight"
                                                     attribute:kJWConstraintMaxY
                                                    relativeTo:nil
                                                     attribute:kJWConstraintMaxY
                                                        offset:-10]];
    
    [layoutManager addConstraint:[JWConstraint constraintWithView:@"botRight"
                                                     attribute:kJWConstraintMinY
                                                    relativeTo:@"right"
                                                     attribute:kJWConstraintMaxY
                                                        offset:10]];
    
    
    
    
//    JWWrapLayoutManager *wrappingLayout = [[[JWWrapLayoutManager alloc] init] autorelease];
//    
//    
//    for (int i = 0; i < 100; ++i)
//    {
//        UIButton * tmp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [tmp addTarget:self action:@selector(sizeAnimate:) forControlEvents:UIControlEventTouchUpInside];
//        [tmp setFrame:CGRectMake(0, 0, 50, 50)];
//        tmp.backgroundColor = [UIColor colorWithRed:UNIFORM_RAND() green:UNIFORM_RAND() blue:UNIFORM_RAND() alpha:1.0];
//        [self.contentView addSubview:tmp];
//
//    }

    [[self contentView] jw_setLayoutManager:layoutManager];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (IBAction)centerHeight:(id)sender;
{
    CGFloat height = [(UISlider*)sender value];
    CGRect frame = [center frame];
    frame.size.height = height;
    center.frame = frame;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [contentView release], contentView = nil;
    [super dealloc];
}


@end
