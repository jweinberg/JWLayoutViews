//
//  UIView+LayoutManager.m
//  LayoutTest
//
//  Created by Joshua Weinberg on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UIView+LayoutManager.h"
#import <objc/runtime.h>

static const char * const kJWLayoutManagerKey = "com.jweinberg.layoutmanager";

static void jw_layoutSubviews(UIView *self, SEL _cmd)
{
	Class superclass = class_getSuperclass([self class]);
	IMP superLayout = class_getMethodImplementation(superclass, _cmd);
    [[self jw_layoutManager] layoutSubviewsOfView:self];
    superLayout(self, _cmd);
}




@implementation UIView (JWLayoutManager)

- (id<JWLayoutManager>)jw_layoutManager;
{    
    return objc_getAssociatedObject(self, kJWLayoutManagerKey);
}

- (void)jw_setLayoutManager:(id<JWLayoutManager>)aLayoutManager;
{
    Class viewClass = [self class];
    if (![NSStringFromClass(viewClass) hasPrefix:@"JWLAYOUT_"])
    {
        NSString *subclassName = [NSString stringWithFormat:@"JWLAYOUT_%@_LayoutCompatible", NSStringFromClass(viewClass)];
        Class subclass = NSClassFromString(subclassName);
        if (subclass == nil)
        {
            subclass = objc_allocateClassPair(viewClass, [subclassName UTF8String], 0);
            Method layoutSubviews = class_getInstanceMethod(viewClass, @selector(layoutSubviews));
            class_addMethod(subclass, @selector(layoutSubviews), (IMP)jw_layoutSubviews, method_getTypeEncoding(layoutSubviews));
            objc_registerClassPair(subclass);
        }
        
        object_setClass(self, subclass);
    }
    objc_setAssociatedObject(self, kJWLayoutManagerKey, aLayoutManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

@end
