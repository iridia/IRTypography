//
//  IRManagedObjectTypographyPersisting.h
//  Milk
//
//  Created by Evadne Wu on 2/11/11.
//  Copyright 2011 Iridia Productions. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol IRManagedObjectTypographyPersisting

//	This is designed to be persisted: the attributed text is read-write internally, but all external objects can only change the text itself.

//	Assumptions: call -recomputeAttributedText in your -setText:.

- (NSString *) text;
- setText:(NSString *)aValue;

- (NSAttributedString *) attributedText;
- (NSAttributedString *) recomputeAttributedText;

@end
