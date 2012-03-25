//
//  NayshunzAppDelegate.h
//  Nayshunz
//
//  Created by Bryan Irace on 1/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface NayshunzAppDelegate : NSObject <UIApplicationDelegate, 
        UISearchBarDelegate, UITableViewDataSource> {
    UIWindow *window;
    UITableView *countryTable;
    UISearchBar *searchBar;
            
    NSMutableArray *continents;
            
    sqlite3 *database;
    sqlite3_stmt *statement;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITableView *countryTable;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

@end

