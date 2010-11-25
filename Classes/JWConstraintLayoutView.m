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
 
    CGFloat rVal = 0.0f;
    switch (relativeAttribute)
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
    return (rVal * scale) + offset;
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
    return [NSString stringWithFormat:@"%p (%@) depends on %p (%@)", view, [self attributeToString:attribute], relativeView, [self attributeToString:relativeAttribute]];
}

@end

@interface JWConstraintGraphNode : NSObject
{
    NSArray *constraints;
    NSMutableArray *dependancies;
}

+ (id)nodeWithConstraints:(NSArray*)aConstraint;
- (id)initWithConstraints:(NSArray*)aConstraint;
- (void)addDependancy:(JWConstraintGraphNode*)aNode;
- (void)removeDependancy:(JWConstraintGraphNode*)aNode;
- (NSArray*)constraints;
- (NSArray*)dependancies;

@end

@implementation JWConstraintGraphNode

+ (id)nodeWithConstraints:(NSArray*)theConstraints;
{
    return [[[JWConstraintGraphNode alloc] initWithConstraints:theConstraints] autorelease];
}

- (id)initWithConstraints:(NSArray*)theConstraints;
{
    if ((self = [super init]))
    {
        constraints = [theConstraints copy];
        dependancies = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc;
{
    [constraints release], constraints = nil;
    [dependancies release], dependancies = nil;
    [super dealloc];
}

- (void)addDependancy:(JWConstraintGraphNode*)aNode;
{
    if (![dependancies containsObject:aNode])
        [dependancies addObject:aNode];
}

- (void)removeDependancy:(JWConstraintGraphNode*)aNode;
{
    if ([dependancies containsObject:aNode])
        [dependancies removeObject:aNode];
}

- (NSArray*)dependancies;
{
    return dependancies;
}

- (NSArray*)constraints;
{
    return constraints;
}

- (NSString*)description:(NSUInteger)tabLevel;
{
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < tabLevel; ++i)
        [str appendString:@"  "];
    [str appendFormat:@"%@\n",[constraints description]];
    for (JWConstraintGraphNode *node in dependancies)
    {
        for (int i = 0; i < tabLevel + 1; ++i)
            [str appendString:@"  "];
        [str appendString:@"|\n"];
        [str appendFormat:@"%@", [node description:tabLevel+1]];
    }
    return [NSString stringWithString:str];
}

- (NSString*)description;
{
    return [NSString stringWithFormat:@"constraints: %@ dependancies:%d",constraints, [dependancies count]];
}

@end



@interface JWConstraintLayoutView ()
- (void)setupDefaults;
- (void)solveConstraints;
- (void)solveAxis:(NSArray*)axis;
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
    [self solveConstraints];
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

#define ATTRIBUTE_TO_AXIS(A) ({__typeof(A) __A = A; __A == kJWConstraintMinX || \
                                                    __A == kJWConstraintMidX || \
                                                    __A == kJWConstraintMaxX || \
                                                    __A == kJWConstraintWidth ? 0 : 1;})

NSInteger compare_deps(id arg1, id arg2, void *arg3)
{
    JWConstraintGraphNode *n1 = arg1;
    JWConstraintGraphNode *n2 = arg2;
    
    return [[n1 dependancies] count] - [[n2 dependancies] count];
}

- (void)solveConstraints;
{
    //Seperate into arrays of constraints on views
    //Want to use views as keys, so need to use lower level dict
    CFMutableDictionaryRef viewConstraintsDict = CFDictionaryCreateMutable(NULL, 0, NULL, &kCFTypeDictionaryValueCallBacks);
    
    for (JWConstraint *constraint in constraints)
    {
        NSArray *viewConstraintsAxis = [(id)viewConstraintsDict objectForKey:[constraint view]];
        if (!viewConstraintsAxis)
        {
            viewConstraintsAxis = [NSArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], nil];
            CFDictionarySetValue(viewConstraintsDict, [constraint view], viewConstraintsAxis);
        }
        [[viewConstraintsAxis objectAtIndex:ATTRIBUTE_TO_AXIS([constraint attribute])] addObject:constraint];
    }
    
    NSMutableArray *nodes = [NSMutableArray array];
    for (NSArray *axii in [(id)viewConstraintsDict allValues])
    {
        if ([[axii objectAtIndex:0] count])
            [nodes addObject:[JWConstraintGraphNode nodeWithConstraints:[axii objectAtIndex:0]]];
        if ([[axii objectAtIndex:1] count])
            [nodes addObject:[JWConstraintGraphNode nodeWithConstraints:[axii objectAtIndex:1]]];
    }
  
    
    CFRelease(viewConstraintsDict);
    //Attach nodes (better way than n^2?)
    //For each node
    for (JWConstraintGraphNode *node in nodes)
    {
        //Check all of its values
        for (JWConstraint * constraint in [node constraints])
        {
            //Against every other node
            for (JWConstraintGraphNode *otherNode in nodes)
            {
                if (otherNode == node)
                    continue;
                
                for (JWConstraint *constraint2 in [otherNode constraints])
                {
                    if ([constraint relativeView] == [constraint2 view] && 
                        ATTRIBUTE_TO_AXIS([constraint relativeAttribute]) == ATTRIBUTE_TO_AXIS([constraint2 attribute]))
                    {
                        [node addDependancy:otherNode];
                        break;
                    }
                }
            }
        }
    }
    //Need to go through and clean dependancies as they get solved
    
    
    //Sort based on the number of dependancies in the nodes
    [nodes sortUsingFunction:compare_deps context:NULL];
    
    NSMutableArray *nodesLeft = [NSMutableArray arrayWithArray:nodes];
    
    while ([nodesLeft count])
    {
        JWConstraintGraphNode *firstNode = [nodesLeft objectAtIndex:0];
        [nodesLeft removeObjectAtIndex:0];
        
        //NSLog(@"Solving for: %@", firstNode);
        [self solveAxis:[firstNode constraints]];
        
        for (JWConstraintGraphNode *node in nodesLeft)
        {
            [node removeDependancy:firstNode];
        }
        [nodesLeft sortUsingFunction:compare_deps context:NULL];
    }
}

CGFloat AxisAttributeValue(CGRect frame, JWConstraintAxisValues axisVal, BOOL isYAxis)
{
    CGFloat val = 0.0f;
    
    JWConstraintAttribute attribute = axisVal << (isYAxis ? 4 : 0);
    
    switch (attribute)
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
    
    return val;
}

- (void)solveAxis:(NSArray*)axis;
{
    //There are 4 possible entries on each axis
    //Min, Mid, Max and Size
    //At most 2 should be specified per axis
    //Each pair/single needs to be solved individually?
    
    uint8_t combined = 0x00;
    
    UIView *view = [[axis objectAtIndex:0] view];
    CGRect rect = [view frame];
    
    CGFloat minR = CGFLOAT_MAX;
    CGFloat midR = CGFLOAT_MAX;
    CGFloat maxR = CGFLOAT_MAX;
    CGFloat sizeR = CGFLOAT_MAX;
    
    for (JWConstraint *constraint in axis)
    {
        combined |= [constraint attribute];
        
        CGFloat rel = [constraint relativeValue];
        switch ([constraint attribute] >= 1 << 4 ? [constraint attribute] >> 4 : [constraint attribute])
        {
            case kJWConstraintMin:
                minR = rel;
                break;
            case kJWConstraintMid:
                midR = rel;
                break;
            case kJWConstraintMax:
                maxR = rel;
                break;
            case kJWConstraintSize:
                sizeR = rel;
                break;
        }
    }
    
    BOOL isYAxis = combined >= 1 << 4;
    
    if (isYAxis)
    {
        combined >>= 4;
    }
    
    CGFloat min = AxisAttributeValue(rect, kJWConstraintMin, isYAxis);
    CGFloat mid = AxisAttributeValue(rect, kJWConstraintMid, isYAxis);
    CGFloat max = AxisAttributeValue(rect, kJWConstraintMax, isYAxis);
    CGFloat size = AxisAttributeValue(rect, kJWConstraintSize, isYAxis);
    
    switch (combined) 
    {
        case kJWConstraintMin:
        {
            //Only change the min value, max need to stay
            CGFloat minDiff = minR - min;
            min += minDiff;
            //Width doesn't change
        }
            break;
        case kJWConstraintMid:
        {
            //Only change the min value, max need to stay
            CGFloat midDiff = midR - mid;
            min += midDiff;
            //Width doesn't change
        }
            break;
        case kJWConstraintMax:
        {
            //Only change the min value, max need to stay
            CGFloat maxDiff = maxR - max;
            min += maxDiff;
            //Width doesn't change
        }
            break;
        case kJWConstraintSize:
            //Shrink around the origin, (0,0)
            size = sizeR;
            break;
        case kJWConstraintMin | kJWConstraintMid:
            min = minR;
            mid = midR;
            max = mid + (mid - min);
            size = max - min;
            break;
        case kJWConstraintMin | kJWConstraintMax:
            min = minR;
            size = maxR - minR;
            break;
        case kJWConstraintMin | kJWConstraintSize:
            min = minR;
            size = sizeR;
            break;
        case kJWConstraintMid | kJWConstraintMax:
            mid = midR;
            max = maxR;
            min = mid - (max - mid);
            size = max - min;
            break;
        case kJWConstraintMid | kJWConstraintSize:
            mid = midR;
            size = sizeR;
            CGFloat hSize = size / 2.0;
            min = mid - hSize;
            break;
        case kJWConstraintMax | kJWConstraintSize:
            max = maxR;
            size = sizeR;
            min = max - size;
            break;
        default:
            NSLog(@"What did you dooooooooo!!");
            break;
    }

    if (isYAxis)
    {
        rect.origin.y = min;
        rect.size.height = size;
    }
    else
    {
        rect.origin.x = min;
        rect.size.width = size;
    }
    
    [view setFrame: rect];
}

@end
