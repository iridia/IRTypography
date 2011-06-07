//
//  IRManagedObjectTypographyPresenting.h
//  Milk
//
//  Created by Evadne Wu on 2/11/11.
//  Copyright 2011 Iridia Productions. All rights reserved.
//

#import "IRTypography.h"


@protocol IRManagedObjectTypographyPresenting

//	The presentable attributed text is NOT persisted for various reasons, the major being that core foundation objects are not conforming to NSCoding; the minor one being that CTFonts are made from CTFontDescriptors, and often that varies from time to time whether a certain descriptor maps to a certain typeface.

//	It is recommended that, if you use Core Data, store the presentable attributed text as a transient property.

//	Assumptions: call -recomputePresentableAttributedText in your setText:, or after your -recomputeAttributedText finished.
//	You should call -recomputePresentableAttributedText in -awakeFromFetch too.

//	-recomputePresentableAttributedText will also return the re-read attribute value, if there is any.
//	If it returns nil, that means it just can’t do it and you shall give up recomputing.

- (NSAttributedString *) presentableAttributedText;
- (NSAttributedString *) recomputePresentableAttributedText;


//	If you use variable height table view cells, it will greatly help to cache the layout size of the attributed text, so you do not have to do expensive computing while the table view is scrolling, etc.

//	It is recommended that, if you use Core Data, store the rect in a transient NSValue.

//	Assumptions: call -recomputePresentableAttributedTextLayoutSize after your -recomputePresentableAttributedText finished.

- (CGSize) presentableAttributedTextLayoutSize;
- (CGSize) recomputePresentableAttributedTextLayoutSize;

@end
