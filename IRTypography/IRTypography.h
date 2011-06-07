//
//  MilkTypography.h
//  Milk
//
//  Created by Evadne Wu on 2/3/11.
//  Copyright 2011 Iridia Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

#import <OmniAppKit/OATextAttributes.h>
#import <OmniAppKit/OATextStorage.h>
#import <OmniAppKit/OATextAttachment.h>
#import <OmniAppKit/OATextAttachmentCell.h>

#import <OmniUI/OUITextLayout.h>

#import <objc/objc.h>
#import <objc/runtime.h>

#import "IRTypographyDefines.h"

#import "IRManagedObjectTypographyPersisting.h"
#import "IRManagedObjectTypographyPresenting.h"
#import "IRManagedObjectTypographyPresentationPrecalculating.h"

#import "NSAttributedString+IRTypographyAdditions.h"






@interface IRTypography : NSObject

+ (IRTypography *) sharedTypography;

@end





@interface IRTypography (Foundation)

+ (NSMutableDictionary *) baseAttributesForFont:(UIFont *)aFont lineHeight:(CGFloat)aLineHeight;
+ (NSMutableDictionary *) baseAttributesForFont:(UIFont *)aFont color:(UIColor *)aColor lineHeight:(CGFloat)aLineHeight;

+ (CTParagraphStyleRef) paragraphStyleForLineHeight:(CGFloat)inLineHeight lineSpacing:(CGFloat)inLineSpacing;

+ (void) yieldFont:(UIFont *)inFont toAttributes:(NSMutableDictionary *)modifiedDictionary;
+ (void) yieldColor:(UIColor *)inColor toAttributes:(NSMutableDictionary *)modifiedDictionary;
+ (void) yieldLineHeight:(CGFloat)inLineHeight lineSpacing:(CGFloat)inLineSpacing toAttributes:(NSMutableDictionary *)modifiedDictionary;

@end





@interface IRTypography (DataDetection)

+ (NSDataDetector *) sharedLinkDetector;

@end





@interface IRTypography (AttributedStringsTransformingConveniences)

- (NSAttributedString *) presentableAttributedStringForPersistedAttributedString:(NSAttributedString *)inPersistedAttributedString inDomain:(NSString *)aDomainName;

- (NSAttributedString *) persistableAttributedStringForBaseString:(NSString *)aBaseString inDomain:(NSString *)aDomainName;

@end

@interface IRTypography (AttributedStringsTransforming)

- (NSDictionary *) baseAttributesForDomainNamed:(NSString *)aDomainName;
- (void) setBaseAttributes:(NSDictionary *)attributes forDomainNamed:(NSString *)aDomainName;

- (IRAttributedStringTransformer) persistableAttributedStringTramsformerForDomainNamed:(NSString *)aDomainName;
- (void) setPersistableAttributedStringTransformer:(NSAttributedString * (^)(NSAttributedString *inString))aGenerator forDomainNamed:(NSString *)aDomainName;

- (IRAttributedStringTransformer) presentableAttributedStringTramsformerForDomainNamed:(NSString *)aDomainName;
- (void) setPresentableAttributedStringTransformer:(NSAttributedString * (^)(NSAttributedString *inString))aGenerator forDomainNamed:(NSString *)aDomainName;

@end






#import "IRTextAttachmentLineHeightHackingCell.h"

@interface IRTypography (Experimental)

+ (NSAttributedString *) sharedLineHeightMaintenanceStringForAscent:(CGFloat)inAscent descent:(CGFloat)inDescent prefix:(NSAttributedString *)prefixOrNil suffix:(NSAttributedString *)suffixOrNil;

+ (NSAttributedString *) sharedLineHeightMaintenanceStringForAscent:(CGFloat)inAscent descent:(CGFloat)inDescent;

@end





extern NSString * const kIRActionableTextAttributeName;

//	It could be a void(^)(void) block, or an NSURL


extern NSString * const kIRActionableTextDidInvokeLinkNotification;
extern NSString * const kIRActionableTextDidRequestLinkInspectionNotification;

//	The notifications will be fired only if the attribute is an NSURL.  In case of a block it’s immediately invoked


@interface IRTypography (Interactivity)

+ (BOOL) hasValidActionForAttribute:(id)anAttribute;
+ (BOOL) invokeActionForAttribute:(id)anAttribute;

@end





@interface IRTypography (CoreText)

+ (void) enumerateLinesInFrame:(CTFrameRef)aFrame withBlock:(void(^)(CTLineRef aLine, CGPoint lineOrigin, BOOL *stop))aBlock;
+ (void) enumerateRunsInLine:(CTLineRef)aLine withBlock:(void(^)(CTRunRef aRun, double runWidth, BOOL *stop))aBlock;

@end
