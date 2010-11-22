//
//  JWConstraintLayoutView.h
//  LayoutTest
//
//  Created by Josh Weinberg on 11/22/10.
//  Copyright 2010 Roundarch Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	kJWConstraintAttributeMinX,
	kJWConstraintAttributeMidX,
	kJWConstraintAttributeMaxX,
	kJWConstraintAttributeWidth,
	kJWConstraintAttributeMinY,
	kJWConstraintAttributeMidY,
	kJWConstraintAttributeMaxY,
	kJWConstraintAttributeHeight,
}JWConstraintAttribute;

@interface JWConstraint : NSObject
{
	UIView *view;
	JWConstraintAttribute attribute;
	UIView *relativeView;
	JWConstraintAttribute relativeAttribute;
	CGFloat scale;
	CGFloat offset;
}

+ (id)constraintWithView:(UIView*)aView
			   attribute:(JWConstraintAttribute)anAttribute 
			  relativeTo:(UIView*)aRelativeView 
			   attribute:(JWConstraintAttribute)aRelativeAttribute 
				   scale:(CGFloat)aScale 
				  offset:(CGFloat)aOffset;

- (id)initWithView:(UIView*)aView
		 attribute:(JWConstraintAttribute)anAttribute 
		relativeTo:(UIView*)aRelativeView 
		 attribute:(JWConstraintAttribute)aRelativeAttribute 
			 scale:(CGFloat)aScale 
			offset:(CGFloat)aOffset;

@property (nonatomic, readonly, retain) UIView *view;
@property (nonatomic, readonly, retain) UIView *relativeView;
@property (nonatomic, readonly, assign) JWConstraintAttribute attribute;
@property (nonatomic, readonly, assign) JWConstraintAttribute relativeAttribute;
@property (nonatomic, readonly, assign) CGFloat scale;
@property (nonatomic, readonly, assign) CGFloat offset;
@end



@interface JWConstraintLayoutView : UIView 
{
	NSMutableSet *constraints;
}

- (void)addConstraint:(JWConstraint*)constraint;
- (void)removeConstraint:(JWConstraint*)constraint;
@end
