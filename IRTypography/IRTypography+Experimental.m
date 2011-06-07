//
//  IRTypography+Experimental.m
//  Milk
//
//  Created by Evadne Wu on 2/11/11.
//  Copyright 2011 Iridia Productions. All rights reserved.
//

#import "IRTypography.h"


@implementation IRTypography (Experimental)

+ (NSAttributedString *) sharedLineHeightMaintenanceStringForAscent:(CGFloat)inAscent descent:(CGFloat)inDescent prefix:(NSAttributedString *)prefixOrNil suffix:(NSAttributedString *)suffixOrNil {

	NSAssert(NO, @"%s is not ready yet, do not call.", __PRETTY_FUNCTION__);

	OATextAttachment *textAttachment = [[[OATextAttachment alloc] initWithFileWrapper:nil] autorelease];
	
	IRTextAttachmentLineHeightHackingCell *attachmentCell = [[[IRTextAttachmentLineHeightHackingCell alloc] init] autorelease];
	attachmentCell.ascent = inAscent;
	attachmentCell.descent = inDescent;
	
	textAttachment.attachmentCell = attachmentCell;
	
	NSString *attachmentCharacter = [NSString stringWithFormat:@"%C", (unichar)OAAttachmentCharacter];
	
	NSAttributedString *attachmentString = [OUICreateTransformedAttributedString(
	
		[[[NSAttributedString alloc] initWithString:attachmentCharacter attributes:[NSDictionary dictionaryWithObjectsAndKeys:
	
			textAttachment, 
			OAAttachmentAttributeName,
	
		nil]] autorelease], 
	
	nil) autorelease];
	
	NSMutableAttributedString *returnedString = [[NSMutableAttributedString alloc] initWithString:@""];
	
	if (prefixOrNil)
	[returnedString appendAttributedString:prefixOrNil];
	
	[returnedString appendAttributedString:attachmentString];
	
	if (suffixOrNil)
	[returnedString appendAttributedString:suffixOrNil];
	
	return returnedString;

}

+ (NSAttributedString *) sharedLineHeightMaintenanceStringForAscent:(CGFloat)inAscent descent:(CGFloat)inDescent {

	return [self sharedLineHeightMaintenanceStringForAscent:inAscent descent:inDescent prefix:nil suffix:nil];

}

@end
