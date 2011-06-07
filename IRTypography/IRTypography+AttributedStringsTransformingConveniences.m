//
//  IRTypography+AttributedStringsTransformingConveniences.m
//  Milk
//
//  Created by Evadne Wu on 2/11/11.
//  Copyright 2011 Iridia Productions. All rights reserved.
//

#import "IRTypography.h"


@implementation IRTypography (AttributedStringsTransformingConveniences)

- (NSAttributedString *) presentableAttributedStringForPersistedAttributedString:(NSAttributedString *)inPersistedAttributedString inDomain:(NSString *)aDomainName {

	NSMutableAttributedString *returnedString = [[inPersistedAttributedString mutableCopy] autorelease];

	IRAttributedStringTransformer aTransformerOrNil = [self presentableAttributedStringTramsformerForDomainNamed:aDomainName];
	
	NSDictionary *baseAttributes = [self baseAttributesForDomainNamed:aDomainName];
	
	if (baseAttributes)
	[returnedString addAttributes:baseAttributes range:NSMakeRange(0, [[returnedString string] length])];
	
	if (aTransformerOrNil)
	return aTransformerOrNil(returnedString);
	
	return returnedString;

}

- (NSAttributedString *) persistableAttributedStringForBaseString:(NSString *)aBaseString inDomain:(NSString *)aDomainName {

	IRAttributedStringTransformer aTransformerOrNil = [self persistableAttributedStringTramsformerForDomainNamed:aDomainName];
	
	if (!aBaseString)
	aBaseString = @" ";
	
	NSAttributedString *returnedString = [[[NSAttributedString alloc] initWithString:aBaseString] autorelease];
	
	if (aTransformerOrNil)
	return aTransformerOrNil(returnedString);
	
	return returnedString;

}

@end
