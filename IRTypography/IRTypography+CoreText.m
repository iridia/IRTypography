//
//  IRTypography+CoreText.m
//  Milk
//
//  Created by Evadne Wu on 2/24/11.
//  Copyright 2011 Iridia Productions. All rights reserved.
//

#import "IRTypography.h"



@implementation IRTypography (CoreText)

+ (void) enumerateLinesInFrame:(CTFrameRef)aFrame withBlock:(void(^)(CTLineRef aLine, CGPoint lineOrigin, BOOL *stop))aBlock {

	if (!aFrame) return;
	
	CFArrayRef lines = CTFrameGetLines(aFrame);
	if (!lines) return;
	
	CFIndex lineCount = CFArrayGetCount(lines);
	
	CGPoint *lineOrigins = malloc(sizeof(*lineOrigins) * lineCount);
	CTFrameGetLineOrigins(aFrame, (CFRange) { 0, lineCount }, lineOrigins);
	
	[((NSArray *)lines) enumerateObjectsUsingBlock: ^ (id aLine, NSUInteger idx, BOOL *stop) {
	
		aBlock((CTLineRef)aLine, lineOrigins[idx], stop);
	
	}];
	
	free(lineOrigins);

}

+ (void) enumerateRunsInLine:(CTLineRef)aLine withBlock:(void(^)(CTRunRef aRun, double runWidth, BOOL *stop))aBlock {

	if (!aLine) return;

	CFArrayRef runs = CTLineGetGlyphRuns(aLine);
	if (!runs) return;
	
	[(NSArray *)runs enumerateObjectsUsingBlock: ^ (id aRun, NSUInteger idx, BOOL *stop) {
	
		aBlock((CTRunRef)aRun, CTRunGetTypographicBounds((CTRunRef)aRun, (CFRange){0, 0}, NULL, NULL, NULL), stop);
	
	}];

}

@end
