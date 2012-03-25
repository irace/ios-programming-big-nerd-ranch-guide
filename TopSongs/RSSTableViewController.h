//
//  RSSTableViewController.h
//  TopSongs
//
//  Created by Bryan Irace on 11/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSTableViewController : UITableViewController 
        <NSXMLParserDelegate> {
    @private BOOL waitingForEntryTitle;
    @private NSMutableString *titleString;
    @private NSMutableArray *songs;
    @private NSMutableData *xmlData;
    @private NSURLConnection *connectionInProgress;
}

- (void)loadSongs;

@end
