//  Copyright (c) 2011, Josh Weinberg
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

#import "UIView+LayoutManager.h"
#import <objc/runtime.h>

static const char * const kJWLayoutManagerKey = "com.jweinberg.layoutmanager";
static const char * const kJWViewNameKey = "com.jweinberg.name";

static void jw_layoutSubviews(UIView *self, SEL _cmd)
{
	Class superclass = class_getSuperclass([self class]);
	IMP superLayout = class_getMethodImplementation(superclass, _cmd);
    [[self jw_layoutManager] layoutSubviewsOfView:self];
    superLayout(self, _cmd);
}

@implementation UIView (JWLayoutManager)

- (NSString *)jw_name;
{
    return objc_getAssociatedObject(self, kJWViewNameKey);
}

- (void)jw_setName:(NSString *)aName;
{
    objc_setAssociatedObject(self, kJWViewNameKey, aName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

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

//Need to cache these?
- (UIView *)jw_subviewWithName:(NSString *)name;
{
    for (UIView *subview in [self subviews])
    {
        if ([[subview jw_name] isEqualToString:name])
            return subview;
    }
    return nil;
}

@end
