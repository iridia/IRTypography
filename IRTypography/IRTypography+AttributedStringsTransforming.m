//
//  IRTypography+AttributedStringsTransforming.m
//  Milk
//
//  Created by Evadne Wu on 2/11/11.
//  Copyright 2011 Iridia Productions. All rights reserved.
//

#import "IRTypography.h"


NSString * const kIRTypographyBaseAttributedStringAttributes = @"kIRTypographyBaseAttributedStringAttributes";
NSString * const kIRTypographyPersistableAttributedStringTransformers = @"kIRTypographyPersistableAttributedStringTransformers";
NSString * const kIRTypographyPresentableAttributedStringTransformers = @"kIRTypographyPresentableAttributedStringTransformers";

@interface IRTypography (AttributedStringsTransforming_Private)

- (NSMutableDictionary *) baseAttributedStringAttributes;
- (NSMutableDictionary *) persistableAttributedStringTransformers;
- (NSMutableDictionary *) presentableAttributedStringTransformers;

@end

@implementation IRTypography (AttributedStringsTransforming_Private)

- (NSMutableDictionary *) baseAttributedStringAttributes {

	NSMutableDictionary *returnedDictionary = objc_getAssociatedObject(self, kIRTypographyBaseAttributedStringAttributes);
	
	if (!returnedDictionary) {
	
		returnedDictionary = [NSMutableDictionary dictionary];
		
		objc_setAssociatedObject(self, kIRTypographyBaseAttributedStringAttributes, returnedDictionary, OBJC_ASSOCIATION_RETAIN);
	
	}
	
	return returnedDictionary;

}

- (NSMutableDictionary *) persistableAttributedStringTransformers {

	NSMutableDictionary *returnedDictionary = objc_getAssociatedObject(self, kIRTypographyPersistableAttributedStringTransformers);
	
	if (!returnedDictionary) {
	
		returnedDictionary = [NSMutableDictionary dictionary];
		
		objc_setAssociatedObject(self, kIRTypographyPersistableAttributedStringTransformers, returnedDictionary, OBJC_ASSOCIATION_RETAIN);
	
	}
	
	return returnedDictionary;

}

- (NSMutableDictionary *) presentableAttributedStringTransformers {

	NSMutableDictionary *returnedDictionary = objc_getAssociatedObject(self, kIRTypographyPresentableAttributedStringTransformers);
	
	if (!returnedDictionary) {
	
		returnedDictionary = [NSMutableDictionary dictionary];
		
		objc_setAssociatedObject(self, kIRTypographyPresentableAttributedStringTransformers, returnedDictionary, OBJC_ASSOCIATION_RETAIN);
	
	}
	
	return returnedDictionary;

}

@end










@implementation IRTypography (AttributedStringsTransforming)

- (NSDictionary *) baseAttributesForDomainNamed:(NSString *)aDomainName {
	
	return [[self baseAttributedStringAttributes] objectForKey:aDomainName];

}

- (void) setBaseAttributes:(NSDictionary *)attributes forDomainNamed:(NSString *)aDomainName {

	[[self baseAttributedStringAttributes] setObject:attributes forKey:aDomainName];

}

- (IRAttributedStringTransformer) persistableAttributedStringTramsformerForDomainNamed:(NSString *)aDomainName {

	return [[self persistableAttributedStringTransformers] objectForKey:aDomainName];

}

- (void) setPersistableAttributedStringTransformer:(IRAttributedStringTransformer)aGenerator forDomainNamed:(NSString *)aDomainName {

	[[self persistableAttributedStringTransformers] setObject:[[aGenerator copy] autorelease] forKey:aDomainName];

}

- (IRAttributedStringTransformer) presentableAttributedStringTramsformerForDomainNamed:(NSString *)aDomainName {

	return [[self presentableAttributedStringTransformers] objectForKey:aDomainName];

}

- (void) setPresentableAttributedStringTransformer:(IRAttributedStringTransformer)aGenerator forDomainNamed:(NSString *)aDomainName {

	[[self presentableAttributedStringTransformers] setObject:[[aGenerator copy] autorelease] forKey:aDomainName];

}

@end
