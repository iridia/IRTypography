//
//  MLTextAttachmentLineHeightHackingCell.h
//  Milk
//
//  Created by Evadne Wu on 2/7/11.
//  Copyright 2011 Iridia Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <OmniAppKit/OATextAttributes.h>
#import <OmniAppKit/OATextStorage.h>
#import <OmniAppKit/OATextAttachment.h>
#import <OmniAppKit/OATextAttachmentCell.h>

#import <QuartzCore/QuartzCore.h>

@interface IRTextAttachmentLineHeightHackingCell : OATextAttachmentCell

@property (nonatomic, readwrite, assign) CGFloat ascent;
@property (nonatomic, readwrite, assign) CGFloat descent;

@end
