//
//  IRTypography+Interactivity.m
//  Milk
//
//  Created by Evadne Wu on 2/23/11.
//  Copyright 2011 Iridia Productions. All rights reserved.
//

#import "IRTypography.h"


NSString * const kIRActionableTextAttributeName = @"kIRActionableTextAttributeName";
NSString * const kIRActionableTextDidInvokeLinkNotification = @"kIRActionableTextDidInvokeLinkNotification";
NSString * const kIRActionableTextDidRequestLinkInspectionNotification = @"kIRActionableTextDidRequestLinkInspectionNotification";

@implementation IRTypography (Interactivity)

+ (BOOL) hasValidActionForAttribute:(id)anAttribute {

	BOOL (^isBlock)() = ^ (id anObject) {

		for (NSString *aClassName in [NSArray arrayWithObjects:

			@"_NSConcreteStackBlock", 
			@"_NSConcreteGlobalBlock",
			@"NSStackBlock",
			@"NSGlobalBlock",
			@"NSMallocBlock",
			@"NSBlock",
		
		nil]) {
		
			if ([anObject isKindOfClass:[NSClassFromString(aClassName) class]])
			return YES;
		
		}
		
		return NO;

	};
	
	
	if (isBlock(anAttribute) || ([anAttribute isKindOfClass:[NSURL class]]))
	return YES;

	return NO;

}

+ (BOOL) invokeActionForAttribute:(id)anAttribute {

	NSLog(@"Invoking");

	return NO;

}

@end
