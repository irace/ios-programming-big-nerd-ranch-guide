//
//  TableController.h
//  Nayberz
//
//  Created by Bryan Irace on 1/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableController : UITableViewController <NSNetServiceBrowserDelegate,
        NSNetServiceDelegate> {
    NSMutableArray *netServices;
    NSNetServiceBrowser *serviceBrowser;
}

@end
