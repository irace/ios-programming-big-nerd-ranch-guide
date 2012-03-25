//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by Bryan Irace on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HomepwnerItemCell.h"
#import "Possession.h"

@implementation HomepwnerItemCell

#pragma mark -
#pragma mark Defined in UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Create a subview - don't need to specify its position/size
        valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        // Put it on the content view of the cell
        [[self contentView] addSubview:valueLabel];
        
        // It is being retained by its superview
        [valueLabel release];
        
        // Same things with the name
        nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [[self contentView] addSubview:nameLabel];
        [nameLabel release];
        
        // Same thing with the image view
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [[self contentView] addSubview:imageView];
        
        // Tell the image view to resize its image to fit inside its frame
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView release];
    }
    
    return self;
}

#pragma mark -
#pragma mark Defined in UIView

- (void)layoutSubviews {
    // We always call this - the table view cell needs to do its own work first
    [super layoutSubviews];
    
    float inset = 5.0;
    CGRect bounds = [[self contentView] bounds];
    float h = bounds.size.height;
    float w = bounds.size.width;
    float valueWidth = 40.0;
    
    // Make a rectangle that is inset and roughly square (using the height of
    // the content view as the width and height of the image view)
    CGRect innerFrame = CGRectMake(inset, inset, h, h - inset * 2.0);
    [imageView setFrame:innerFrame];
    
    // Move that rectangle over and resize the width for the name label
    innerFrame.origin.x += innerFrame.size.width + inset;
    innerFrame.size.width = w - (h + valueWidth + inset * 4);
    [nameLabel setFrame:innerFrame];
    
    // Move that rectangle over again and resize the width for valueLabel
    innerFrame.origin.x += innerFrame.size.width + inset;
    innerFrame.size.width = valueWidth;
    [valueLabel setFrame:innerFrame];
}

#pragma mark -
#pragma mark Defined in header

- (void)setPossession:(Possession *)possession {
    NSString *currencySymbol = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
    
    // Using a Possession instance, we can set the values of the subviews
    [valueLabel setText:[NSString stringWithFormat:@"%@%d",
                         currencySymbol,
                         [possession valueInDollars]]];
    
    [nameLabel setText:[possession possessionName]];
    [imageView setImage:[possession thumbnail]];
}

@end
