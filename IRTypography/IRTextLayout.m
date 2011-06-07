//
//  MLTextLayout.m
//  Milk
//
//  Created by Evadne Wu on 12/21/10.
//  Copyright 2010 Iridia Productions. All rights reserved.
//

#import "IRTextLayout.h"
#import "IRTypography.h"


@implementation IRTextLayout

+ (IRTextLayout *) layoutForContentText:(NSString *)inContentText font:(UIFont *)inFont lineHeight:(CGFloat)inLineHeight width:(CGFloat)inWidthConstraint {

	if (!inContentText || !inFont) return nil;
	
	
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	
	if (inFont) {

		CTFontRef fontRef = CTFontCreateWithName((CFStringRef)(inFont.fontName), inFont.pointSize, NULL);

		[attributes setObject:(id)fontRef forKey:(NSString *)kCTFontAttributeName];

		CFRelease(fontRef);
		
	}
	
	if (inLineHeight != -1) {
	
		CGFloat lineHeightMultiple = 2.0;
	
		CTParagraphStyleSetting paragraphStyleSettings[] = {
			
			{ kCTParagraphStyleSpecifierLineHeightMultiple, sizeof(CGFloat), &lineHeightMultiple },
			{ kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(inLineHeight), &inLineHeight },
			{ kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(inLineHeight), &inLineHeight }	
				
		};

		CTParagraphStyleRef paragraphStyleRef = CTParagraphStyleCreate(paragraphStyleSettings, 3);
	
		[attributes setObject:(id)paragraphStyleRef forKey:(NSString *)kCTParagraphStyleAttributeName];
		
		CFRelease(paragraphStyleRef);
	
	}
	
	
	return [[[[self class] alloc] initWithAttributedString:[[[NSAttributedString alloc] initWithString:inContentText attributes:attributes] autorelease] constraints:CGSizeMake(inWidthConstraint, -1)] autorelease];

}










- (BOOL) irRun:(CTRunRef)aRun passesAttributeTests:(NSDictionary *)attributeKeysToValuesOrNSNull {

	NSDictionary *attributes = (NSDictionary *)CTRunGetAttributes(aRun);
	if (!attributes) return NO;
	
	__block BOOL passes = YES;
	
	[attributeKeysToValuesOrNSNull enumerateKeysAndObjectsUsingBlock: ^ (id aKey, id validatorOrNSNull, BOOL *stop) {

		id attributeValue = [attributes objectForKey:aKey];
		if (!attributeValue || ((![validatorOrNSNull isEqual:[NSNull null]]) && (!((IRCTAttributeValidator)validatorOrNSNull)(aKey, attributeValue)))) {
		
			passes = NO;
			*stop = YES;
		
		}

	}];
	
	return passes;

}










- (BOOL) irFindRunForPoint:(CGPoint)aPoint usingRun:(CTRunRef *)runRefOrNull attributes:(CFDictionaryRef *)attributesOrNull {

	return [self irFindRunForPoint:aPoint usingRun:runRefOrNull attributes:attributesOrNull withTolerance:0 attributes:[NSDictionary dictionaryWithObjectsAndKeys:
	
		[NSNull null], kIRActionableTextAttributeName,
	
	nil]];

}

- (BOOL) irFindRunForPoint:(CGPoint)aPoint usingRun:(CTRunRef *)runRefOrNull attributes:(CFDictionaryRef *)attributesOrNull withTolerance:(CGFloat)tolerance attributes:(NSDictionary *)attributeKeysToValuesOrNSNull {

	CTRunRef introspectedRun = NULL;
	
//	The tolerance is at least 2 for internal use — there is absolutely no way to overlap a zero rect
//	The more area the tolerable rect overlaps a certain run, the more likely the run is the preferred one
	
	CGFloat realTolerance = (tolerance >= 2.0) ? tolerance : 2.0;

	CGRect tolerableRect = (CGRect) {
	
		(CGPoint) { aPoint.x - realTolerance * 0.5, aPoint.y - realTolerance * 0.5 }, 
		(CGSize) { realTolerance, realTolerance }
	
	};
	
	__block CTRunRef bestMatchingRun = NULL;
	__block CGFloat bestMatchingRunScore = 0;
	
	[IRTypography enumerateLinesInFrame:_frame withBlock: ^ (CTLineRef aLine, CGPoint lineOrigin, BOOL *stop) {
	
		CGFloat lineAscent, lineDescent, lineLeading;
		CTLineGetTypographicBounds(aLine, &lineAscent, &lineDescent, &lineLeading);
		
		lineOrigin = (CGPoint){ lineOrigin.x, lineOrigin.y * -1 + OUITextLayoutUnlimitedSize + lineAscent + lineDescent };
		
		if (( (lineOrigin.y + lineDescent) < CGRectGetMinY(tolerableRect) ) || ( (lineOrigin.y - lineAscent) > CGRectGetMaxY(tolerableRect) ))
		return;

		__block CGFloat usedWidth = 0;
		
		[IRTypography enumerateRunsInLine:aLine withBlock: ^ (CTRunRef aRun, double runWidth, BOOL *stopRunEnum) {
		
			usedWidth += runWidth;
			
			if (![self irRun:aRun passesAttributeTests:attributeKeysToValuesOrNSNull])
			return;
			
			CGFloat runAscent, runDescent, runLeading;
			CTRunGetTypographicBounds(aRun, (CFRange){0, 0}, &runAscent, &runDescent, &runLeading);
			
			CGRect runRect = (CGRect) {
		
				(CGPoint) { lineOrigin.x + usedWidth - runWidth, lineOrigin.y - runAscent },
				(CGSize) { runWidth, runAscent + runDescent + runLeading }
		
			};

			CGRect intersection = CGRectIntersection(tolerableRect, runRect);	
			
			if (CGRectEqualToRect(intersection, CGRectNull))
			return;
			
			CGFloat score = CGRectGetWidth(intersection) * CGRectGetHeight(intersection);
			
			if (score <= bestMatchingRunScore)
			return;
			
			bestMatchingRun = aRun;
			bestMatchingRunScore = score;
		
		}];
	
	}];
	
	introspectedRun = bestMatchingRun;
	
	if (introspectedRun == NULL)
	return NO;
	
	if (runRefOrNull != NULL) *runRefOrNull = introspectedRun;
	if (attributesOrNull != NULL) *attributesOrNull = CTRunGetAttributes(introspectedRun);
	
	return YES;

}





- (NSMutableArray *) irFindRunsAdjacentToRun:(CTRunRef)referencedRun withAttributes:(NSDictionary *)attributeKeysToValuesOrNSNull {

	if (![self irRun:referencedRun passesAttributeTests:attributeKeysToValuesOrNSNull])
	return [NSMutableArray array];
		
	NSMutableArray *returnedArray = [NSMutableArray array];
	__block BOOL hasSeenReferencedRun = NO;
	
	[IRTypography enumerateLinesInFrame:_frame withBlock: ^ (CTLineRef aLine, CGPoint lineOrigin, BOOL *stopLineEnum) {
	
		[IRTypography enumerateRunsInLine:aLine withBlock: ^ (CTRunRef aRun, double runWidth, BOOL *stopRunEnum) {
			
		//	If the run is valid just queue it
			
			if ([self irRun:aRun passesAttributeTests:attributeKeysToValuesOrNSNull]) {
			
				[returnedArray addObject:(id)aRun];
				hasSeenReferencedRun = hasSeenReferencedRun ? hasSeenReferencedRun : (aRun == referencedRun);

				return;
			
			}
			
			
		//	If an invalid run came in after we’ve seen the referenced run, it’s time to end enumeration early
			
			if (hasSeenReferencedRun) {
			
				*stopLineEnum = YES;
				*stopRunEnum = YES;
				return;
			
			}
			
		//	There is possibility that we just pushed a lot of valid but irrelevant runs
		//	Remove them all, just to be safe
				
			[returnedArray removeAllObjects];
					
		}];
	
	}];
	
	return returnedArray;	

}





- (UIBezierPath *) irGetWrappingPathForRuns:(NSArray *)runs flushingEdges:(BOOL)averageMetrics {

	return [self irGetWrappingPathForRuns:runs flushingEdges:averageMetrics withEdgeInsets:(UIEdgeInsets){ -2, -2, 0, -2 } makingIntegral:YES compensatingLeading:NO usingCornerRadius:0.0];

}

- (UIBezierPath *) irGetWrappingPathForRuns:(NSArray *)runs flushingEdges:(BOOL)averageMetrics withEdgeInsets:(UIEdgeInsets)edgeInsets makingIntegral:(BOOL)appendsIntegralRects compensatingLeading:(BOOL)shiftsAppendedRectsToCompensateLeading usingCornerRadius:(CGFloat)radius {

	UIBezierPath *returnedPath = [UIBezierPath bezierPath];
	
	if (!runs || ([runs count] == 0))
	return returnedPath;
	
	NSSet *queriedRuns = [NSSet setWithArray:runs];	
	
	[IRTypography enumerateLinesInFrame:_frame withBlock: ^ (CTLineRef aLine, CGPoint lineOrigin, BOOL *stopLineEnum) {
	
		CGFloat lineAscent, lineDescent, lineLeading;
		CTLineGetTypographicBounds(aLine, &lineAscent, &lineDescent, &lineLeading);
		
		lineOrigin = (CGPoint){ lineOrigin.x, lineOrigin.y * -1 + OUITextLayoutUnlimitedSize + lineAscent + lineDescent };

		__block CGFloat usedWidth = 0;
		__block UIBezierPath *pathsInLine = [UIBezierPath bezierPath];
				
		[IRTypography enumerateRunsInLine:aLine withBlock: ^ (CTRunRef aRun, double runWidth, BOOL *stopRunEnum) {
		
			if ([queriedRuns containsObject:(id)aRun]) {
			
				CGFloat runAscent, runDescent, runLeading;
				CTRunGetTypographicBounds(aRun, (CFRange){0, 0}, &runAscent, &runDescent, &runLeading);
				
				CGRect appendedRect = UIEdgeInsetsInsetRect((CGRect) {
				
					lineOrigin.x + usedWidth,
					lineOrigin.y + (shiftsAppendedRectsToCompensateLeading ? (runLeading * -0.5) : 0) - runAscent,
					runWidth,
					runAscent + runDescent + runLeading
				
				}, edgeInsets);
				
				if (appendsIntegralRects)
				appendedRect = CGRectIntegral(appendedRect);
				
				if ((radius == 0) || averageMetrics) {
				
					[pathsInLine appendPath:[UIBezierPath bezierPathWithRect:appendedRect]];
				
				} else {
				
					[pathsInLine appendPath:[UIBezierPath bezierPathWithRoundedRect:appendedRect cornerRadius:radius]];					
				
				}
			
			}
			
			usedWidth += runWidth;		
					
		}];
		
		if (!pathsInLine || pathsInLine.empty)
		return;

		[returnedPath appendPath:(averageMetrics ? (
		
			(radius == 0) ? [UIBezierPath bezierPathWithRect:[pathsInLine bounds]] : [UIBezierPath bezierPathWithRoundedRect:[pathsInLine bounds] cornerRadius:radius]
			
		) : (
		
			pathsInLine
			
		))];
	
	}];
	
	return returnedPath;

}

@end
