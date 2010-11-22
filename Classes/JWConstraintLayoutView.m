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

+ (id)constraintWithView:(UIView*)aView
               attribute:(JWConstraintAttribute)anAttribute 
              relativeTo:(UIView*)aRelativeView 
               attribute:(JWConstraintAttribute)aRelativeAttribute;
{
    return [[[JWConstraint alloc] initWithView:aView
                                     attribute:anAttribute
                                    relativeTo:aRelativeView
                                     attribute:aRelativeAttribute
                                         scale:1.0
                                        offset:0] autorelease];
    
}

+ (id)constraintWithView:(UIView*)aView
               attribute:(JWConstraintAttribute)anAttribute 
              relativeTo:(UIView*)aRelativeView 
               attribute:(JWConstraintAttribute)aRelativeAttribute 
                  offset:(CGFloat)aOffset;
{
    return [[[JWConstraint alloc] initWithView:aView
                                     attribute:anAttribute
                                    relativeTo:aRelativeView
                                     attribute:aRelativeAttribute
                                         scale:1.0
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
    CGRect frame = CGRectZero;
    if (relativeView)
        frame = [relativeView frame];
    else
        frame = [[view superview] frame];
    
    switch (relativeAttribute)
    {
        case kJWConstraintMinX:
            return CGRectGetMinX(frame);
        case kJWConstraintMidX:
            return CGRectGetMidX(frame);
        case kJWConstraintMaxX:
            return CGRectGetMaxX(frame);
        case kJWConstraintWidth:
            return CGRectGetWidth(frame);
        case kJWConstraintMinY:
            return CGRectGetMinY(frame);
        case kJWConstraintMidY:
            return CGRectGetMidY(frame);
        case kJWConstraintMaxY:
            return CGRectGetMaxY(frame);
        case kJWConstraintHeight:
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
        case kJWConstraintMinX:
            frame.origin.x = rVal;
            break;
        case kJWConstraintMidX:
            frame.origin.x = rVal - frame.size.width / 2.0f;
            break;
        case kJWConstraintMaxX:
            frame.size.width = rVal - frame.origin.x;
            break;
        case kJWConstraintWidth:
            frame.size.width = rVal;
            break;            
        case kJWConstraintMinY:
            frame.origin.y = rVal;
            break;            
        case kJWConstraintMidY:
            frame.origin.y = rVal - frame.size.height / 2.0f;
            break;            
        case kJWConstraintMaxY:
            frame.size.height = rVal - frame.origin.y;
            
            break;            
        case kJWConstraintHeight:
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
