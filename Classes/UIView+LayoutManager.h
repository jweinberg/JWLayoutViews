//
//  UIView+LayoutManager.h
//  LayoutTest
//
//  Created by Joshua Weinberg on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWLayoutManager.h"

@interface UIView (JWLayoutManager)
- (id<JWLayoutManager>)jw_layoutManager;
- (void)jw_setLayoutManager:(id<JWLayoutManager>)aLayoutManager;
@end
