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

#import "JWConstraintLayoutManager.h"
#import "JWConstraintGraphNode.h"
#import "UIView+LayoutManager.h"

@interface JWConstraintLayoutManager ()
@property (nonatomic, retain) NSMutableArray *constraints;
@property (nonatomic, retain) NSMutableArray *nodes;
@property (nonatomic, assign) BOOL needsConstraintsUpdate;
- (void)updateConstraintsGraph;
- (void)solveConstraintsInView:(UIView*)view;
- (void)solveAxis:(NSArray*)axis inView:(UIView*)view;
@end

@implementation JWConstraintLayoutManager
@synthesize constraints, nodes, needsConstraintsUpdate;
- (id)init;
{
    if ((self = [super init]))
    {
        self.constraints = [NSMutableArray array];
        self.nodes = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc 
{
    self.constraints = nil;
    self.nodes = nil;
    [super dealloc];
}

- (void)layoutSubviewsOfView:(UIView *)view;
{
    if (self.needsConstraintsUpdate)
        [self updateConstraintsGraph];
    [self solveConstraintsInView:view];
}

#pragma mark Constraint Managment
- (void)setNeedsConstraintsUpdate;
{
    self.needsConstraintsUpdate = YES;
}

- (void)addConstraint:(JWConstraint*)constraint;
{
    [self.constraints addObject:constraint];
    [self setNeedsConstraintsUpdate];
}

- (void)removeConstraint:(JWConstraint*)constraint;
{
    [self.constraints removeObject:constraint];
    [self setNeedsConstraintsUpdate];
}

#pragma mark Private

int attribute_to_axis(JWConstraintAttribute attribute)
{
    return ((attribute == kJWConstraintMinX) ||
            (attribute == kJWConstraintMidX) || 
            (attribute == kJWConstraintMaxX) || 
            (attribute == kJWConstraintWidth)) ? 0 : 1;
}

- (void)updateConstraintsGraph;
{
    //Seperate into arrays of constraints on views
    //Want to use views as keys, so need to use lower level dict
    CFMutableDictionaryRef viewConstraintsDict = CFDictionaryCreateMutable(NULL, 0, NULL, &kCFTypeDictionaryValueCallBacks);
    
    for (JWConstraint *constraint in self.constraints)
    {
        NSArray *viewConstraintsAxis = [(id)viewConstraintsDict objectForKey:[constraint view]];
        if (!viewConstraintsAxis)
        {
            viewConstraintsAxis = [NSArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], nil];
            CFDictionarySetValue(viewConstraintsDict, [constraint view], viewConstraintsAxis);
        }
        [[viewConstraintsAxis objectAtIndex:attribute_to_axis([constraint attribute])] addObject:constraint];
    }
    
    [self.nodes removeAllObjects];
    for (NSArray *axii in [(id)viewConstraintsDict allValues])
    {
        if ([[axii objectAtIndex:0] count])
            [self.nodes addObject:[JWConstraintGraphNode nodeWithConstraints:[axii objectAtIndex:0]]];
        if ([[axii objectAtIndex:1] count])
            [self.nodes addObject:[JWConstraintGraphNode nodeWithConstraints:[axii objectAtIndex:1]]];
    }
    
    CFRelease(viewConstraintsDict);
    
    //Attach nodes (better way than n^2?)
    //For each node
    for (JWConstraintGraphNode *node in self.nodes)
    {
        //Check all of its values
        for (JWConstraint * constraint in [node constraints])
        {
            //Against every other node
            for (JWConstraintGraphNode *otherNode in self.nodes)
            {
                if (otherNode == node)
                    continue;
                
                for (JWConstraint *constraint2 in [otherNode constraints])
                {
                    if ([constraint relativeView] == [constraint2 view] && 
                        attribute_to_axis([constraint relativeAttribute]) == attribute_to_axis([constraint2 attribute]))
                    {
                        [node addOutgoing:otherNode];
                        [otherNode addIncoming:node];
                        break;
                    }
                }
            }
        }
    }
    
    //Do a topological sort
    NSMutableArray *queue = [NSMutableArray array];
    for (JWConstraintGraphNode *n in self.nodes)
    {
        if ([[n incomingEdges] count] == 0)
            [queue addObject:n];
    }
    
    NSMutableArray *allNodes = [NSArray arrayWithArray:self.nodes];
    [self.nodes removeAllObjects];
    
    while ([queue count])
    {
        JWConstraintGraphNode *node = [queue objectAtIndex:0];
        [queue removeObjectAtIndex:0];
        [self.nodes insertObject:node atIndex:0];
        
        NSMutableArray *outgoingEdgesToRemove = [NSMutableArray array];
        for (JWConstraintGraphNode *outgoing in [node outgoingEdges])
        {
            [outgoingEdgesToRemove addObject:outgoing];
            [outgoing removeIncoming:node];
            if ([[outgoing incomingEdges] count] == 0)
            {
                [queue addObject:outgoing];
            }
        }

        for (JWConstraintGraphNode *outgoing in outgoingEdgesToRemove)
             [node removeOutgoing:outgoing];
    }
    
    for (JWConstraintGraphNode *node in allNodes)
    {
        if ([[node outgoingEdges] count] || [[node incomingEdges] count])
            [[NSException exceptionWithName:@"JWInvalidConstraint"
                                           reason:@"There is a cycle in the specified constraints"
                                         userInfo:nil] raise];
    }
    
    //NSLog(@"%@", nodes);
    
    self.needsConstraintsUpdate = NO;
}

- (void)solveConstraintsInView:(UIView *)view;
{   
    for (JWConstraintGraphNode *node in self.nodes)
        [self solveAxis:[node constraints] inView:view];
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

- (void)solveAxis:(NSArray*)axis inView:(UIView *)superview;
{
    //There are 4 possible entries on each axis
    //Min, Mid, Max and Size
    //At most 2 should be specified per axis
    //Each pair/single needs to be solved individually?
    
    uint8_t combined = 0x00;
    
    UIView *view = [superview jw_subviewWithName:[(JWConstraint*)[axis objectAtIndex:0] view]];
    CGRect rect = [view frame];
    
    CGFloat minR = CGFLOAT_MAX;
    CGFloat midR = CGFLOAT_MAX;
    CGFloat maxR = CGFLOAT_MAX;
    CGFloat sizeR = CGFLOAT_MAX;
    
    for (JWConstraint *constraint in axis)
    {
        combined |= [constraint attribute];
        
        CGFloat rel = [constraint relativeValueInView:superview];
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
            NSAssert(NO, @"Invalid axis, constraint building failed");
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
