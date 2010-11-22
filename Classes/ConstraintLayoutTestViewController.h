//
//  ConstraintLayoutTestViewController.h
//  LayoutTest
//
//  Created by Josh Weinberg on 11/22/10.
//  Copyright 2010 Roundarch Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JWConstraintLayoutView;

@interface ConstraintLayoutTestViewController : UIViewController {
	JWConstraintLayoutView *layoutView;
}

@property (nonatomic, retain) IBOutlet JWConstraintLayoutView *layoutView;
@end
