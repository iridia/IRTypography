//
//  IRTypography+DataDetection.m
//  Milk
//
//  Created by Evadne Wu on 2/11/11.
//  Copyright 2011 Iridia Productions. All rights reserved.
//

#import "IRTypography.h"


@implementation IRTypography (DataDetection)

+ (NSDataDetector *) sharedLinkDetector {

	static NSDataDetector *sharedDetector = nil;
	
	if (!sharedDetector) {
	
		NSError *error = nil;
		sharedDetector = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:&error];
		
		if (!sharedDetector)
		NSLog(@"%s Error: %@", __PRETTY_FUNCTION__, error);
	
	}
	
	return sharedDetector;

}

@end
