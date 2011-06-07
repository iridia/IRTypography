//
//  MLTextLayout.h
//  Milk
//
//  Created by Evadne Wu on 12/21/10.
//  Copyright 2010 Iridia Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <OmniUI/OUITextLayout.h>
#import <CoreText/CoreText.h>

#import "CGGeometry+IRAdditions.h"

#ifndef __IRTextLayout__
#define __IRTextLayout__

typedef BOOL (^IRCTAttributeValidator)(id anAttribute, id aValue);

#endif

@class IRTypography;
@interface IRTextLayout : OUITextLayout

+ (IRTextLayout *) layoutForContentText:(NSString *)inContentText font:(UIFont *)inFont lineHeight:(CGFloat)inLineHeight width:(CGFloat)inWidthConstraint;

- (BOOL) irRun:(CTRunRef)aRun passesAttributeTests:(NSDictionary *)attributeKeysToValuesOrNSNull;

//	This is a helper method, that grabs the attributes of the given run and checks if it passes every test.  Pass nil attribute tests, to always PASS the test.  Of course, that is not a useful case…


- (BOOL) irFindRunForPoint:(CGPoint)aPoint usingRun:(CTRunRef *)runRefOrNull attributes:(CFDictionaryRef *)attributesOrNull;
- (BOOL) irFindRunForPoint:(CGPoint)aPoint usingRun:(CTRunRef *)runRefOrNull attributes:(CFDictionaryRef *)attributesOrNull withTolerance:(CGFloat)tolerance attributes:(NSDictionary *)attributeKeysToValuesOrNSNull;

//	If returned YES, runRefOrNull and attributesOrNull will be populated, provided that they are not pointers to NULL.
//	The latter is called by the former with a tolerance of 0.  Tolerance is used only when there is no run that contains the point, in that case we enumerate every single run with the attribute
//	If attributeKeysToValuesOrNSNull is not nil, the runs are checked against them, and ONLY those carrying eligible attributes will get considered


- (NSMutableArray *) irFindRunsAdjacentToRun:(CTRunRef)referencedRun withAttributes:(NSDictionary *)attributeKeysToValuesOrNSNull;

//	Provide an existing CTRunRef, that exists within the frame on a particular line.
//	Returns an NSArray containing NSValues, which holds CTRunRefs.
//	Consecutive CTRuns having the keys will be considered.
//	
//	attributeKeysToValidatorsOrNSNull is used that if you pass [NSNull null] to a key, it means “any run that has this attribute”.
//	Otherwise, pass an IRCTAttributeValidator block (remember to copy and autorelease it).
//	
//		BOOL (^IRCTAttributeValidator)(id anAttribute, id aValue)
//	
//	If the block answers YES, the adjacent run is considered valid and will be used to find the next adjacent run in the correct direction.
//	Otherwise, search in that direction stops.


- (UIBezierPath *) irGetWrappingPathForRuns:(NSArray *)runs flushingEdges:(BOOL)averageMetrics;
- (UIBezierPath *) irGetWrappingPathForRuns:(NSArray *)runs flushingEdges:(BOOL)averageMetrics withEdgeInsets:(UIEdgeInsets)edgeInsets makingIntegral:(BOOL)appendsIntegralRects compensatingLeading:(BOOL)shiftsAppendedRectsToCompensateLeading usingCornerRadius:(CGFloat)radius;

//	Pass in an array full of NSValue wrappers around CTRun objects, and get a UIBezierPath.  If the runns spans over one line, their ascenders and descenders are flushed using the min/max metrics, per line, so the edges do not look jagged.  There will be no support to use metrics from a line, because they can be way, way off when mixing languages.

//	Convenience:
//	
//	return [self irGetWrappingPathForRuns:runs flushingEdges:averageMetrics withEdgeInsets:(UIEdgeInsets){ -2, -2, 0, -2 } makingIntegral:YES compensatingLeading:NO usingCornerRadius:0.0];

@end
