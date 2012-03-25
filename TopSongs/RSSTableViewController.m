//
//  RSSTableViewController.m
//  TopSongs
//
//  Created by Bryan Irace on 11/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RSSTableViewController.h"

@implementation RSSTableViewController

#pragma mark -
#pragma mark Defined in header

- (void)loadSongs {
    // In case the view will appear multiple times, clear the song list (in case 
    // you add this to an application that has multiple view controllers...)
    [songs removeAllObjects];
    [[self tableView] reloadData];
    
    // Construct the web service URL
    NSURL *url = [NSURL URLWithString:@"http://ax.itunes.apple.com/"
                  @"WebObjects/MZStoreServices.woa/ws/RSS/topsongs/"
                  @"limit=10/xml"];
    
    // Create a request object with the URL
    NSURLRequest *request = 
            [NSURLRequest requestWithURL:url 
                             cachePolicy:NSURLRequestReloadIgnoringCacheData 
                         timeoutInterval:30];
    
    // Clear out the existing connection if there is one
    if (connectionInProgress) {
        [connectionInProgress cancel];
        [connectionInProgress release];
    }
    
    // Instantiate the object to hold all incoming data
    [xmlData release];
    xmlData = [[NSMutableData alloc] init];
    
    // Create and initiate the connection - non-blocking
    connectionInProgress = [[NSURLConnection alloc] initWithRequest:request 
                                                           delegate:self 
                                                   startImmediately:YES];
}


#pragma mark -
#pragma mark Defined in NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqual:@"entry"]) {
        NSLog(@"Found a song entry");
        waitingForEntryTitle = YES;
    }
    
    if ([elementName isEqual:@"title"] && waitingForEntryTitle) {
        NSLog(@"Found title!");
        titleString = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [titleString appendString:string];
}

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName {
    if ([elementName isEqual:@"title"] && waitingForEntryTitle) {
        NSLog(@"Ended title: %@", titleString);
        [songs addObject:titleString];
        
        // Release and nil titleString so that the next time characters are
        // found and not within a title tag, they are ignored
        [titleString release];
        titleString = nil;
    }
    
    if ([elementName isEqual:@"entry"]) {
        NSLog(@"Ended a song entry");
        waitingForEntryTitle = NO;
    }
}

#pragma mark -
#pragma mark Defined in NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [xmlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Create the parser object with the data received from the web service
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    
    // Give it a delegate
    [parser setDelegate:self];

    // Tell it to start parsing - the document will be parsed and the delegate 
    // of NSXMLParser will get all of its delegate messages sent to it before 
    // this line finishes execution - it is blocking
    [parser parse];
    
    // The parser is done (it blocks until done), you can release it immediately
    [parser release];
    [[self tableView] reloadData];
}

- (void)connection:(NSURLConnection *)connection 
  didFailWithError:(NSError *)error {
    [connectionInProgress release];
    connectionInProgress = nil;
    
    [xmlData release];
    xmlData = nil;
    
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@", 
                             [error localizedDescription]];
    
    UIActionSheet *actionSheet = 
            [[UIActionSheet alloc] initWithTitle:errorString
                                        delegate:nil
                               cancelButtonTitle:@"OK"
                          destructiveButtonTitle:nil
                               otherButtonTitles:nil];
    
    [actionSheet showInView:[[self view] window]];
    [actionSheet autorelease];
}


#pragma mark -
#pragma mark Defined in UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadSongs];
}


#pragma mark -
#pragma mark Defined in UITableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        songs = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return [songs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = 
            [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] 
                 initWithStyle:UITableViewCellStyleDefault 
                 reuseIdentifier:@"UITableViewCell"] autorelease];
    }
    
    [[cell textLabel] setText:[songs objectAtIndex:[indexPath row]]];
    
    return cell;
}


#pragma mark -
#pragma mark Defined in NSObject

- (void)dealloc {
    [songs release];
    
    [super dealloc];
}


@end
