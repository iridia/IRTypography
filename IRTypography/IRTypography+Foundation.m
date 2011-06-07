//
//  IRTypography+Foundation.m
//  Milk
//
//  Created by Evadne Wu on 2/11/11.
//  Copyright 2011 Iridia Productions. All rights reserved.
//

#import "IRTypography.h"


@implementation IRTypography (Foundation)

+ (NSMutableDictionary *) baseAttributesForFont:(UIFont *)aFont lineHeight:(CGFloat)aLineHeight {

	return [self baseAttributesForFont:aFont color:[UIColor blackColor] lineHeight:aLineHeight];

}

+ (NSMutableDictionary *) baseAttributesForFont:(UIFont *)aFont color:(UIColor *)aColor lineHeight:(CGFloat)aLineHeight {

	NSMutableDictionary *returnedDictionary = [NSMutableDictionary dictionary];
	
	[self yieldFont:aFont toAttributes:returnedDictionary];
	[self yieldLineHeight:aLineHeight lineSpacing:0 toAttributes:returnedDictionary];
	[self yieldColor:aColor toAttributes:returnedDictionary];
	
	return returnedDictionary;

}





+ (CTParagraphStyleRef) paragraphStyleForLineHeight:(CGFloat)inLineHeight lineSpacing:(CGFloat)inLineSpacing {

//	CGFloat lineHeightMultiple = 0.000001;
	CGFloat decoyLineHeight = 1.0;
	CGFloat realLineHeight = inLineHeight - decoyLineHeight;	// Compensate
	CGFloat realLineSpacing = realLineHeight;	// FIXME: Respect inLineSpacing;
//	CGFloat zero = 0.0;
	CGFloat pad = 1.0;	//	https://github.com/omnigroup/omnigroup/issues/issue/12
	

//	HACK.  Make the line height to 1.0, and hack with the spacing, so every line has the exact same height and visual spacing

	CTParagraphStyleSetting paragraphStyleSettings[] = {

	//	{ kCTParagraphStyleSpecifierLineHeightMultiple, sizeof(lineHeightMultiple), &lineHeightMultiple },
		{ kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(decoyLineHeight), &decoyLineHeight },
		{ kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(decoyLineHeight), &decoyLineHeight },	
		
#ifdef __IPHONE_4_3
		
		{ kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(realLineSpacing), &realLineSpacing },
		{ kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(realLineSpacing), &realLineSpacing },
		{ kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(realLineSpacing), &realLineSpacing },
		
#else
		
		{ kCTParagraphStyleSpecifierLineSpacing, sizeof(realLineSpacing), &realLineSpacing },
		
#endif
		
		{ kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(pad), &pad },

	};

	CTParagraphStyleRef paragraphStyleRef = CTParagraphStyleCreate(paragraphStyleSettings, sizeof(paragraphStyleSettings) / sizeof(CTParagraphStyleSetting));
	
	return paragraphStyleRef;

}





+ (void) yieldFont:(UIFont *)inFont toAttributes:(NSMutableDictionary *)modifiedDictionary {

	CTFontRef fontRef = CTFontCreateWithName((CFStringRef)(inFont.fontName), inFont.pointSize, NULL);

	[modifiedDictionary setObject:(id)fontRef forKey:(NSString *)kCTFontAttributeName];

	CFRelease(fontRef);

}

+ (void) yieldColor:(UIColor *)inColor toAttributes:(NSMutableDictionary *)modifiedDictionary {

	[modifiedDictionary setObject:(id)inColor.CGColor forKey:(NSString *)kCTForegroundColorAttributeName];

}

+ (void) yieldLineHeight:(CGFloat)inLineHeight lineSpacing:(CGFloat)inLineSpacing toAttributes:(NSMutableDictionary *)modifiedDictionary {

	CTParagraphStyleRef paragraphStyleRef = [self paragraphStyleForLineHeight:inLineHeight lineSpacing:inLineSpacing];

	[modifiedDictionary setObject:(id)paragraphStyleRef forKey:(NSString *)kCTParagraphStyleAttributeName];

	CFRelease(paragraphStyleRef);

}

@end
