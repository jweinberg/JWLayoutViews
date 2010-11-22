//
//  JWConstraintLayoutView.m
//  LayoutTest
//
//  Created by Josh Weinberg on 11/22/10.
//  Copyright 2010 Roundarch Inc. All rights reserved.
//

#import "JWConstraintLayoutView.h"

@interface JWConstraint ()
@property (nonatomic, retain) UIView *view;
@property (nonatomic, retain) UIView *relativeView;
@property (nonatomic, assign) JWConstraintAttribute attribute;
@property (nonatomic, assign) JWConstraintAttribute relativeAttribute;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat offset;

- (void)applyConstraint;
@end


@implementation JWConstraint

@synthesize view, relativeView, attribute, relativeAttribute, scale, offset;

+ (id)constraintWithView:(UIView*)aView
			   attribute:(JWConstraintAttribute)anAttribute 
			  relativeTo:(UIView*)aRelativeView 
			   attribute:(JWConstraintAttribute)aRelativeAttribute 
				   scale:(CGFloat)aScale 
				  offset:(CGFloat)aOffset
{
	return [[[JWConstraint alloc] initWithView:aView
									attribute:anAttribute
								   relativeTo:aRelativeView
									attribute:aRelativeAttribute
										scale:aScale
										offset:aOffset] autorelease];
}

- (id)initWithView:(UIView*)aView
		 attribute:(JWConstraintAttribute)anAttribute 
		relativeTo:(UIView*)aRelativeView 
		 attribute:(JWConstraintAttribute)aRelativeAttribute 
			 scale:(CGFloat)aScale 
			offset:(CGFloat)aOffset
{
	if ((self = [self init]))
	{
		view = [aView retain];
		relativeView = [aRelativeView retain];
		
		attribute = anAttribute;
		relativeAttribute = aRelativeAttribute;
		
		scale = aScale;
		offset = aOffset;
	}
	return self;
}

- (void)dealloc;
{
	[view release], view = nil;
	[relativeView release], relativeView = nil;
	[super dealloc];
}

- (CGFloat)relativeValue;
{
	CGRect frame = [relativeView frame];
	switch (relativeAttribute)
	{
		case kJWConstraintAttributeMinX:
			return CGRectGetMinX(frame);
		case kJWConstraintAttributeMidX:
			return CGRectGetMidX(frame);
		case kJWConstraintAttributeMaxX:
			return CGRectGetMaxX(frame);
		case kJWConstraintAttributeWidth:
			return CGRectGetWidth(frame);
		case kJWConstraintAttributeMinY:
			return CGRectGetMinY(frame);
		case kJWConstraintAttributeMidY:
			return CGRectGetMidY(frame);
		case kJWConstraintAttributeMaxY:
			return CGRectGetMaxY(frame);
		case kJWConstraintAttributeHeight:
			return CGRectGetHeight(frame);
	}
	return 0.0f;
}

- (void)applyConstraint;
{
	CGFloat rVal = [self relativeValue];
	rVal = (rVal * scale) + offset;
	
	CGRect frame = [view frame];
	
	switch (attribute)
	{
		case kJWConstraintAttributeMinX:
			frame.origin.x = rVal;
			break;
		case kJWConstraintAttributeMidX:
			frame.origin.x = rVal - frame.size.width / 2.0f;
			break;
		case kJWConstraintAttributeMaxX:
			frame.origin.x = rVal - frame.size.width;
			break;
		case kJWConstraintAttributeWidth:
			frame.size.width = rVal;
			break;			
		case kJWConstraintAttributeMinY:
			frame.origin.y = rVal;
			break;			
		case kJWConstraintAttributeMidY:
			frame.origin.y = rVal - frame.size.height / 2.0f;
			break;			
		case kJWConstraintAttributeMaxY:
			frame.origin.y = rVal - frame.size.height;
			break;			
		case kJWConstraintAttributeHeight:
			frame.size.height = rVal;
			break;			
	}
	
	view.frame = frame;
}

@end

@interface JWConstraintLayoutView ()
- (void)setupDefaults;
@end


@implementation JWConstraintLayoutView


- (id)initWithFrame:(CGRect)frame 
{
	if ((self = [super initWithFrame:frame]))
	{
		[self setupDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder;
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		[self setupDefaults];
	}
	return self;
}

- (void)dealloc 
{
	[constraints release], constraints = nil;
    [super dealloc];
}

- (void)layoutSubviews;
{
	[super layoutSubviews];
	for (JWConstraint *constraint in constraints)
		[constraint applyConstraint];
}

#pragma mark Constraint Managment
- (void)addConstraint:(JWConstraint*)constraint;
{
	[constraints addObject:constraint];
	[self setNeedsLayout];
}

- (void)removeConstraint:(JWConstraint*)constraint;
{
	[constraints removeObject:constraint];
	[self setNeedsLayout];
}

#pragma mark Private
- (void)setupDefaults;
{
	constraints = [[NSMutableArray alloc] init];
}

@end
