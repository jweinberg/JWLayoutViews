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

#import "JWConstraint.h"
#import "UIView+LayoutManager.h"

@interface JWConstraint ()
@property (nonatomic, copy) NSString *view;
@property (nonatomic, copy) NSString *relativeView;
@property (nonatomic, assign) JWConstraintAttribute attribute;
@property (nonatomic, assign) JWConstraintAttribute relativeAttribute;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat offset;
@end

@implementation JWConstraint

@synthesize view, relativeView, attribute, relativeAttribute, scale, offset;

+ (id)constraintWithView:(NSString*)aView
               attribute:(JWConstraintAttribute)anAttribute 
              relativeTo:(NSString*)aRelativeView 
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

+ (id)constraintWithView:(NSString*)aView
               attribute:(JWConstraintAttribute)anAttribute 
              relativeTo:(NSString*)aRelativeView 
               attribute:(JWConstraintAttribute)aRelativeAttribute;
{
    return [[[JWConstraint alloc] initWithView:aView
                                     attribute:anAttribute
                                    relativeTo:aRelativeView
                                     attribute:aRelativeAttribute
                                         scale:1.0
                                        offset:0] autorelease];
    
}

+ (id)constraintWithView:(NSString*)aView
               attribute:(JWConstraintAttribute)anAttribute 
              relativeTo:(NSString*)aRelativeView 
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

- (id)initWithView:(NSString*)aView
         attribute:(JWConstraintAttribute)anAttribute 
        relativeTo:(NSString*)aRelativeView 
         attribute:(JWConstraintAttribute)aRelativeAttribute 
             scale:(CGFloat)aScale 
            offset:(CGFloat)aOffset
{
    if ((self = [self init]))
    {
        self.view = aView;
        self.relativeView = aRelativeView;
        
        self.attribute = anAttribute;
        self.relativeAttribute = aRelativeAttribute;
        
        self.scale = aScale;
        self.offset = aOffset;
    }
    return self;
}

- (void)dealloc;
{
    self.view = nil;
    self.relativeView = nil;
    [super dealloc];
}

- (CGFloat)relativeValueInView:(UIView*)superview;
{
    CGRect frame = CGRectZero;
    if (self.relativeView)
        frame = [[superview jw_subviewWithName:self.relativeView] frame];
    else
    
        frame = [superview bounds];
    CGFloat rVal = 0.0f;
    switch (self.relativeAttribute)
    {
        case kJWConstraintMinX:
            rVal = CGRectGetMinX(frame);
            break;
        case kJWConstraintMidX:
            rVal = CGRectGetMidX(frame);
            break;
        case kJWConstraintMaxX:
            rVal = CGRectGetMaxX(frame);
            break;
        case kJWConstraintWidth:
            rVal = CGRectGetWidth(frame);
            break;
        case kJWConstraintMinY:
            rVal = CGRectGetMinY(frame);
            break;
        case kJWConstraintMidY:
            rVal = CGRectGetMidY(frame);
            break;
        case kJWConstraintMaxY:
            rVal = CGRectGetMaxY(frame);
            break;
        case kJWConstraintHeight:
            rVal = CGRectGetHeight(frame);
            break;
    }
    return (rVal * self.scale) + self.offset;
}

#pragma mark Debugging
- (NSString*)attributeToString:(JWConstraintAttribute)aAttribute;
{
    switch (aAttribute)
    {
        case kJWConstraintMinX:
            return @"Min-X";
        case kJWConstraintMidX:
            return @"Mid-X";
        case kJWConstraintMaxX:
            return @"Max-X";
        case kJWConstraintWidth:
            return @"Width";
        case kJWConstraintMinY:
            return @"Min-Y";
        case kJWConstraintMidY:
            return @"Mid-Y";
        case kJWConstraintMaxY:
            return @"Max-Y";
        case kJWConstraintHeight:
            return @"Height";
    }
    return @"";
}

- (NSString*)description;
{
    return [NSString stringWithFormat:@"%p (%@) depends on %p (%@)", self.view, [self attributeToString:self.attribute], self.relativeView, [self attributeToString:self.relativeAttribute]];
}

@end
