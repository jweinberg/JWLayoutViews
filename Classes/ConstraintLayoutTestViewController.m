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
#import "JWConstraintLayoutView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ConstraintLayoutTestViewController
@synthesize layoutView;
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
    //[UIView beginAnimations:nil context:nil];
    CGRect r = sender.frame;
    r.size = CGSizeMake(UNIFORM_RAND() * 25.0f + 25.0f, UNIFORM_RAND() * 25.0f + 25.0f);
    sender.frame = r;
    //    [UIView commitAnimations];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    UIView *viewA = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    viewA.frame = CGRectMake(0.0,0.0,100.0,25.0);
    viewA.layer.borderWidth = 2.0;
    
    
    [layoutView addSubview:viewA];
    
    [layoutView addConstraint:[JWConstraint 
                               constraintWithView:viewA
                               attribute:kJWConstraintMidY
                               relativeTo:nil
                               attribute:kJWConstraintMidY]];
    
    [layoutView addConstraint:[JWConstraint constraintWithView:viewA
                                                     attribute:kJWConstraintMidX
                                                    relativeTo:nil
                                                     attribute:kJWConstraintMidX]];
    
    
    UIView *viewB = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    viewB.backgroundColor = [UIColor redColor];
    viewB.layer.borderWidth = 2.0;
    
    [layoutView addSubview:viewB];
    
    
    [layoutView addConstraint:[JWConstraint  constraintWithView:viewB
                                                      attribute:kJWConstraintWidth
                                                     relativeTo:viewA
                                                      attribute:kJWConstraintWidth]];
    
    [layoutView addConstraint:[JWConstraint constraintWithView:viewB
                                                     attribute:kJWConstraintMidX
                                                    relativeTo:viewA
                                                     attribute:kJWConstraintMidX]];
    
    
    [layoutView addConstraint:[JWConstraint constraintWithView:viewB
                                                     attribute:kJWConstraintMinY
                                                    relativeTo:viewA
                                                     attribute:kJWConstraintMaxY
                                                        offset:10.0]];
    
    [layoutView addConstraint:[JWConstraint constraintWithView:viewB
                                                     attribute:kJWConstraintMaxY
                                                    relativeTo:nil
                                                     attribute:kJWConstraintMaxY
                                                        offset:-10.0]];
    
 
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

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
    [layoutView release], layoutView = nil;
    [super dealloc];
}


@end
