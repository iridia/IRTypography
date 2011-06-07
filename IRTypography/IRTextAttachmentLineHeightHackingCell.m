//
//  MLTextAttachmentLineHeightHackingCell.m
//  Milk
//
//  Created by Evadne Wu on 2/7/11.
//  Copyright 2011 Iridia Productions. All rights reserved.
//

#import "IRTextAttachmentLineHeightHackingCell.h"


@implementation IRTextAttachmentLineHeightHackingCell

@synthesize ascent, descent;

- (id) init {
    
	self = [super init];
	if (!self) return nil;
	
	self.ascent = 0;
	self.descent = 0;
	
	return self;

}

- (CGSize) cellSize {

	return (CGSize){0, self.ascent + self.descent};

}

- (CGPoint) cellBaselineOffset {

	return (CGPoint){0, MIN(0, self.descent * -1)};

}

- (void) drawWithFrame:(CGRect)cellFrame inView:(UIView *)controlView {

	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
	CGContextFillRect(context, CGRectMake(
	
		cellFrame.origin.x,
		cellFrame.origin.y,
		cellFrame.size.width + 1,
		cellFrame.size.height
	
	));

	return;

}

- (void) dealloc {

	[super dealloc];

}


@end
