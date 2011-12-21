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

#import "JWWrapLayoutManager.h"

@interface JWWrapLayoutManager ()
- (void)alignRow:(CGRect*)rowStart length:(NSUInteger)rowLength height:(CGFloat)rowHeight inFrame:(CGRect)frame;
@end

@implementation JWWrapLayoutManager
@synthesize minRowHeight, verticalRowAlignment, horizontalRowAlignment, subviewMargins;

- (id)init;
{
    if ((self = [super init]))
    {
        self.minRowHeight = CGFLOAT_MIN;
        self.verticalRowAlignment = JWVerticalRowAlignmentCenter;
        self.horizontalRowAlignment = JWHorizontalRowAlignmentCenter;
        self.subviewMargins = UIEdgeInsetsZero;
    }
    return self;
}

- (void)layoutSubviewsOfView:(UIView *)view;
{
    CGPoint currentOffset = CGPointMake(0, self.subviewMargins.top);
    CGFloat rowHeight = self.minRowHeight;
    
    //Temp storage for all the frames
    CGRect * frames = calloc([[view subviews] count], sizeof(CGRect));
    
    NSUInteger idx = 0;
    //The row that is currently being processed
    NSRange rowRange = NSMakeRange(0,0);
    
    UIEdgeInsets flippedInsets = UIEdgeInsetsMake(-self.subviewMargins.top, 
                                                  -self.subviewMargins.left, 
                                                  -self.subviewMargins.bottom,
                                                  -self.subviewMargins.right);
    
    for (UIView *subview in [view subviews])
    {
        currentOffset.x += self.subviewMargins.left;
        //Setup the frame storage
        frames[idx] = subview.frame;
        CGRect *newFrame = &frames[idx];
        
        newFrame->origin = currentOffset;
        
        //Need to check if the frame is inside the view
        if (!CGRectContainsRect(view.frame, UIEdgeInsetsInsetRect(*newFrame, flippedInsets)))
        {
            //Because this view wasn't inside, we know that the row is ready
            //Go over the current row and center them vertically
            [self alignRow:&frames[rowRange.location] 
                    length:rowRange.length 
                    height:rowHeight
                   inFrame:view.frame];
            
            //Jump to the next row
            currentOffset.y += rowHeight + self.subviewMargins.top + self.subviewMargins.bottom;
            currentOffset.x = self.subviewMargins.left;
            
            newFrame->origin = currentOffset;
            
            rowHeight = MAX(self.minRowHeight, newFrame->size.height);
            rowRange.location = idx;
            rowRange.length = 0;
        }
        
        
        rowRange.length++;
        
        //Adjust the row height if needed
        if (newFrame->size.height > rowHeight)
            rowHeight = MAX(self.minRowHeight, newFrame->size.height);
        
        //Shift the cursor to the next location
        currentOffset.x += newFrame->size.width + self.subviewMargins.right;
        
        idx++;
    }
    
    [self alignRow:&frames[rowRange.location] 
            length:rowRange.length 
            height:rowHeight
           inFrame:view.frame];
    
    idx = 0;
    for (UIView *subview in [view subviews])
    {
        [subview setFrame:frames[idx++]];
    }
    
    free(frames);
}

#pragma mark Property Overrides

#pragma mark Private

- (void)alignRow:(CGRect*)rowStart length:(NSUInteger)rowLength height:(CGFloat)rowHeight inFrame:(CGRect)frame;
{
    CGFloat rowWidth = 0;
    
    //Align vertically
    for (int i = 0; i < rowLength; ++i)
    {
        CGRect * rFrame = &rowStart[i];
        switch (self.verticalRowAlignment)
        {
            case JWVerticalRowAlignmentCenter:
                rFrame->origin.y += (rowHeight - rFrame->size.height) / 2.0;
                break;
            case JWVerticalRowAlignmentBottom:
                rFrame->origin.y += (rowHeight - rFrame->size.height);
                break;
            default:
                break;
        }
        rowWidth += rFrame->size.width + self.subviewMargins.left + self.subviewMargins.right;
    }
    
    CGFloat currentX = 0;
    switch (self.horizontalRowAlignment)
    {
        case JWHorizontalRowAlignmentCenter:
            currentX = (frame.size.width - rowWidth) / 2.0;
            break;
        case JWHorizontalRowAlignmentRight:
            currentX = frame.size.width - rowWidth;
            break;
        default:
            break;
    }
    
    
    for (int i = 0; i < rowLength; ++i)
    {
        currentX += self.subviewMargins.left;
        CGRect * rFrame = &rowStart[i];
        rFrame->origin.x = currentX;
        currentX += rFrame->size.width + self.subviewMargins.right;
    }
        
}


@end
