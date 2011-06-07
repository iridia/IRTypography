//
//  MilkTypography.m
//  Milk
//
//  Created by Evadne Wu on 2/3/11.
//  Copyright 2011 Iridia Productions. All rights reserved.
//

#import "IRTypography.h"


@implementation IRTypography

+ (IRTypography *) sharedTypography {

	static IRTypography *sharedInstance = nil;
	
	if (!sharedInstance) {
	
		sharedInstance = [[self alloc] init];
	
	}
	
	return sharedInstance;

}

@end
