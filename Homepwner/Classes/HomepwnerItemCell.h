//
//  HomepwnerItemCell.h
//  Homepwner
//
//  Created by Bryan Irace on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Possession;

@interface HomepwnerItemCell : UITableViewCell {
    UILabel *valueLabel;
    UILabel *nameLabel;
    UIImageView *imageView;
}

- (void)setPossession:(Possession *)possession;

@end
