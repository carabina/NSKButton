//
//  NSKButton.m
//  NSKButtonObjC
//
//  Created by NSSimpleApps on 21.08.16.
//  Copyright © 2016 NSSimpleApps. All rights reserved.
//

#import "NSKButton.h"
#import "NSKDefaultImageLayout.h"
#import "NSKRightImageLayout.h"
#import "NSKTopImageLayout.h"
#import "NSKBottomImageLayout.h"

static NSString *const NSKImagePositionKey = @"nskImagePosition";
static NSString *const NSKImageLayoutKey = @"nskImageLayout";

@interface NSKButton ()

@property (nonatomic, strong) Class nskImageLayout;

@end

@implementation NSKButton

- (Class)nskImageLayout {
    
    if (_nskImageLayout == Nil) {
        
        _nskImageLayout = [NSKDefaultImageLayout class];
    }
    
    return _nskImageLayout;
}

- (void)setNskImagePosition:(NSKImagePosition)nskImagePosition {
    
    if ((nskImagePosition >= 0) && (nskImagePosition <= 3) && (_nskImagePosition != nskImagePosition)) {
        
        if (nskImagePosition == NSKImagePositionDefault) {
            
            self.nskImageLayout = [NSKDefaultImageLayout class];
            
        } else if (nskImagePosition == NSKImagePositionRight) {
            
            self.nskImageLayout = [NSKRightImageLayout class];
            
        } else if (nskImagePosition == NSKImagePositionTop) {
            
            self.nskImageLayout = [NSKTopImageLayout class];
            
        } else if (nskImagePosition == NSKImagePositionBottom) {
            
            self.nskImageLayout = [NSKBottomImageLayout class];
        }
        
        if ((ABS(_nskImagePosition - nskImagePosition) >= 2) ||
            ((_nskImagePosition == NSKImagePositionRight) && (nskImagePosition == NSKImagePositionTop)) ||
            ((_nskImagePosition == NSKImagePositionTop) && (nskImagePosition == NSKImagePositionRight))) {
            
            [self invalidateIntrinsicContentSize];
        }
            
        [self setNeedsLayout];
        
        _nskImagePosition = nskImagePosition;
    }
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGRect defaultTitleRect = [super titleRectForContentRect:contentRect];
    CGRect imageRect = [super imageRectForContentRect:contentRect];
    
    return [self.nskImageLayout titleRectForContentRect:contentRect
                                       defaultTitleRect:defaultTitleRect
                                              imageRect:imageRect
                                        titleEdgeInsets:self.titleEdgeInsets];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGRect titleRect = [super titleRectForContentRect:contentRect];
    CGRect defaultImageRect = [super imageRectForContentRect:contentRect];
    
    return [self.nskImageLayout imageRectForContentRect:contentRect
                                       defaultImageRect:defaultImageRect
                                              titleRect:titleRect
                                        imageEdgeInsets:self.imageEdgeInsets];
}

- (CGSize)intrinsicContentSize {
    
    CGRect contentRect = [self contentRectForBounds:self.bounds];
    CGRect imageRect = [super imageRectForContentRect:contentRect];
    CGRect titleRect = [super titleRectForContentRect:contentRect];
    CGSize defaultIntrinsicContentSize = [super intrinsicContentSize];
    
    return
    [self.nskImageLayout intrinsicContentSizeForDefault:defaultIntrinsicContentSize
                                              imageRect:imageRect
                                              titleRect:titleRect];
}

#pragma -mark NSCoding-protocol conformance

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeInteger:self.nskImagePosition forKey:NSKImagePositionKey];
    [aCoder encodeObject:NSStringFromClass(self.nskImageLayout) forKey:NSKImageLayoutKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        NSString *nskImageLayoutString = [aDecoder decodeObjectForKey:NSKImageLayoutKey];
        
        if (nskImageLayoutString == nil) {
            
            self.nskImageLayout = [NSKDefaultImageLayout class];
            
        } else {
            
            Class decodedClass = NSClassFromString(nskImageLayoutString);
            
            if (decodedClass == Nil) {
                
                self.nskImageLayout = [NSKDefaultImageLayout class];
                
            } else {
                
                self.nskImageLayout = decodedClass;
            }
        }
        
        NSInteger decodedInteger = [aDecoder decodeIntegerForKey:NSKImagePositionKey];
        
        if (decodedInteger >= 0 && decodedInteger <= 3) {
            
            self.nskImagePosition = decodedInteger;
            
        } else {
            
            self.nskImagePosition = NSKImagePositionDefault;
        }
    }
    
    return self;
}

@end

