//
//  IRManagedObjectTypographyPresentationPrecalculating.h
//  Milk
//
//  Created by Evadne Wu on 2/12/11.
//  Copyright 2011 Iridia Productions. All rights reserved.
//

#import "IRTypography.h"

#import "IRTextLayout.h"

@protocol IRManagedObjectTypographyPresentationPrecalculating

- (IRTextLayout *) presentableAttributedTextLayout;
- (IRTextLayout *) recomputePresentableAttributedTextLayout;

@end
