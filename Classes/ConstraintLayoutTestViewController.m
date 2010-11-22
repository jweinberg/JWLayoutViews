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

#define UNIFORM_RAND() ((float)rand()/RAND_MAX)
- (void)sizeAnimate:(UIView*)sender;
{
	//[UIView beginAnimations:nil context:nil];
	CGRect r = sender.frame;
	r.size = CGSizeMake(UNIFORM_RAND() * 25.0f + 25.0f, UNIFORM_RAND() * 25.0f + 25.0f);
	sender.frame = r;
	//	[UIView commitAnimations];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];

	UIButton *topView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[topView addTarget:self action:@selector(sizeAnimate:) forControlEvents:UIControlEventTouchUpInside];
	[topView setFrame:CGRectMake(100, 100, 50, 50)];
	[layoutView addSubview:topView];
	
	UIView *awesomeView = [[UIView alloc] init];
	[awesomeView setBackgroundColor:[UIColor greenColor]];
	[layoutView addSubview:awesomeView];
	
	UIView *a2 = [[UIView alloc] init];
	[a2 setBackgroundColor:[UIColor redColor]];
	[layoutView addSubview:a2];
	
	JWConstraint *width = [JWConstraint constraintWithView:awesomeView 
													  attribute:kJWConstraintAttributeWidth 
													 relativeTo:topView
													  attribute:kJWConstraintAttributeWidth
														  scale:.5f
														 offset:0];
	
	JWConstraint *height = [JWConstraint constraintWithView:awesomeView 
												 attribute:kJWConstraintAttributeHeight 
												relativeTo:topView
												 attribute:kJWConstraintAttributeHeight
													 scale:2.f
													offset:0];
	
	JWConstraint *x = [JWConstraint constraintWithView:awesomeView 
												  attribute:kJWConstraintAttributeMinX 
												 relativeTo:topView
												  attribute:kJWConstraintAttributeMaxX
													  scale:1.0
													 offset:10];
	
	JWConstraint *y = [JWConstraint constraintWithView:awesomeView 
											 attribute:kJWConstraintAttributeMinY 
											relativeTo:topView
											 attribute:kJWConstraintAttributeMinY
												 scale:1.0
												offset:0];
	
	JWConstraint * h2 = [JWConstraint constraintWithView:a2
											   attribute:kJWConstraintAttributeHeight
											  relativeTo:awesomeView 
											   attribute:kJWConstraintAttributeWidth
												   scale:1.0
												  offset:0];
	
	JWConstraint * w2 = [JWConstraint constraintWithView:a2
											   attribute:kJWConstraintAttributeWidth
											  relativeTo:awesomeView 
											   attribute:kJWConstraintAttributeWidth
												   scale:1.0
												  offset:0];
	
	JWConstraint * y2 = [JWConstraint constraintWithView:a2
											   attribute:kJWConstraintAttributeMinY
											  relativeTo:awesomeView 
											   attribute:kJWConstraintAttributeMaxY
												   scale:1.0
												  offset:0];
	
	JWConstraint * x2 = [JWConstraint constraintWithView:a2
											   attribute:kJWConstraintAttributeMidX
											  relativeTo:nil 
											   attribute:kJWConstraintAttributeMidX
												   scale:1.0
												  offset:0];
	
	[layoutView addConstraint:width];
	[layoutView addConstraint:height];
	[layoutView addConstraint:x];
	[layoutView addConstraint:y];
	[layoutView addConstraint:h2];
	[layoutView addConstraint:w2];
	[layoutView addConstraint:y2];
	[layoutView addConstraint:x2];
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
