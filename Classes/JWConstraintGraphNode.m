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

@interface JWConstraintGraphNode ()
@property (nonatomic, copy) NSArray *constraints;
@property (nonatomic, retain) NSMutableArray *outgoingEdges;
@property (nonatomic, retain) NSMutableArray *incomingEdges;
@end

@implementation JWConstraintGraphNode
@synthesize constraints, incomingEdges, outgoingEdges;

+ (id)nodeWithConstraints:(NSArray*)theConstraints;
{
    return [[[JWConstraintGraphNode alloc] initWithConstraints:theConstraints] autorelease];
}

- (id)initWithConstraints:(NSArray*)theConstraints;
{
    if ((self = [super init]))
    {
        self.constraints = theConstraints;
        self.outgoingEdges = [NSMutableArray array];
        self.incomingEdges = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc;
{
    self.constraints = nil;
    self.outgoingEdges = nil;
    self.incomingEdges = nil;
    [super dealloc];
}

- (void)addIncoming:(JWConstraintGraphNode*)aNode;
{
    if (![self.incomingEdges containsObject:aNode])
        [(NSMutableArray *)self.incomingEdges addObject:aNode];
}

- (void)addOutgoing:(JWConstraintGraphNode*)aNode;
{
    if (![self.outgoingEdges containsObject:aNode])
        [(NSMutableArray *)self.outgoingEdges addObject:aNode];
}

- (void)removeOutgoing:(JWConstraintGraphNode*)aNode;
{
    if ([self.outgoingEdges containsObject:aNode])
        [(NSMutableArray *)self.outgoingEdges removeObject:aNode];
}

- (void)removeIncoming:(JWConstraintGraphNode*)aNode;
{
    if ([self.incomingEdges containsObject:aNode])
        [(NSMutableArray *)self.incomingEdges removeObject:aNode];
}

#pragma mark Debugging

- (NSString*)description;
{
    return [NSString stringWithFormat:@"constraints: %@", self.constraints];
}

@end


