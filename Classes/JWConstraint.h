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

#import <Foundation/Foundation.h>

typedef enum {
    kJWConstraintMinX = 1 << 0,
    kJWConstraintMidX = 1 << 1,
    kJWConstraintMaxX = 1 << 2,
    kJWConstraintWidth = 1 << 3,
    kJWConstraintMinY = 1 << 4,
    kJWConstraintMidY = 1 << 5,
    kJWConstraintMaxY = 1 << 6,
    kJWConstraintHeight = 1 << 7,
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

+ (id)constraintWithView:(UIView*)aView
               attribute:(JWConstraintAttribute)anAttribute 
              relativeTo:(UIView*)aRelativeView 
               attribute:(JWConstraintAttribute)aRelativeAttribute 
                  offset:(CGFloat)aOffset;

+ (id)constraintWithView:(UIView*)aView
               attribute:(JWConstraintAttribute)anAttribute 
              relativeTo:(UIView*)aRelativeView 
               attribute:(JWConstraintAttribute)aRelativeAttribute;

- (id)initWithView:(UIView*)aView
         attribute:(JWConstraintAttribute)anAttribute 
        relativeTo:(UIView*)aRelativeView 
         attribute:(JWConstraintAttribute)aRelativeAttribute 
             scale:(CGFloat)aScale 
            offset:(CGFloat)aOffset;

- (CGFloat)relativeValue;

@property (nonatomic, readonly, retain) UIView *view;
@property (nonatomic, readonly, retain) UIView *relativeView;
@property (nonatomic, readonly, assign) JWConstraintAttribute attribute;
@property (nonatomic, readonly, assign) JWConstraintAttribute relativeAttribute;
@property (nonatomic, readonly, assign) CGFloat scale;
@property (nonatomic, readonly, assign) CGFloat offset;
@end

