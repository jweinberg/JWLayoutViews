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

#import "JWConstraintGraphNode.h"

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
        outgoingEdges = [[NSMutableArray alloc] init];
        incomingEdges = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc;
{
    [constraints release], constraints = nil;
    [incomingEdges release], incomingEdges = nil;
    [outgoingEdges release], outgoingEdges = nil;
    [super dealloc];
}

- (void)addIncoming:(JWConstraintGraphNode*)aNode;
{
    if (![incomingEdges containsObject:aNode])
        [incomingEdges addObject:aNode];
}

- (void)addOutgoing:(JWConstraintGraphNode*)aNode;
{
    if (![outgoingEdges containsObject:aNode])
        [outgoingEdges addObject:aNode];
}

- (void)removeOutgoing:(JWConstraintGraphNode*)aNode;
{
    if ([outgoingEdges containsObject:aNode])
        [outgoingEdges removeObject:aNode];
}

- (void)removeIncoming:(JWConstraintGraphNode*)aNode;
{
    if ([incomingEdges containsObject:aNode])
        [incomingEdges removeObject:aNode];
}

- (NSArray*)outgoing;
{
    return outgoingEdges;
}

- (NSArray*)incoming;
{
    return incomingEdges;
}

- (NSArray*)constraints;
{
    return constraints;
}

#pragma mark Debugging

- (NSString*)description;
{
    return [NSString stringWithFormat:@"constraints: %@", constraints];
}

@end


