    //
//  TableController.m
//  Nayberz
//
//  Created by Bryan Irace on 1/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableController.h"
#import <netinet/in.h>
#import <arpa/inet.h>

@implementation TableController

#pragma mark -
#pragma mark Defined in NSObject

- (id)init {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        netServices = [[NSMutableArray alloc] init];
        
        serviceBrowser = [[NSNetServiceBrowser alloc] init];
        
        // As the delegate, you will be told when services are found
        [serviceBrowser setDelegate:self];
        
        // Start it up
        [serviceBrowser searchForServicesOfType:@"_nayberz._tcp." 
                                       inDomain:@""];
    }

    return self;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark Defined in NSNetServiceDelegate

- (void)netServiceDidResolveAddress:(NSNetService *)sender {
    // What row just resolved?
    int row = [netServices indexOfObject:sender];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:row 
                                         inSection:0];
    
    [[self tableView] reloadRowsAtIndexPaths:[NSArray arrayWithObject:ip] 
                            withRowAnimation:UITableViewRowAnimationRight];
    
    // Get all addresses for this server
    NSArray *addrs = [sender addresses];
    
    if ([addrs count] > 0) {
        // Just grab the first address that it advertises
        NSData *firstAddress = [addrs objectAtIndex:0];
        
        // Point a socketaddr_in structure at the data wrapped by firstAddress
        const struct sockaddr_in *addy = [firstAddress bytes];
        
        // Get a string that shows the IP address in x.x.x.x format
        // from the socketaddr_in structure
        char *str = inet_ntoa(addy->sin_addr);
        
        // Print that IP address as well as the port
        NSLog(@"%s:%d", str, ntohs(addy->sin_port));
    }
}

#pragma mark -
#pragma mark Defined in NSNetServiceBrowserDelegate

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser 
           didFindService:(NSNetService *)aNetService 
               moreComing:(BOOL)moreComing {
    NSLog(@"Adding %@", aNetService);
    
    [netServices addObject:aNetService];
    
    // Update the interface
    NSIndexPath *ip = [NSIndexPath indexPathForRow:[netServices count] - 1 
                                         inSection:0];
    
    [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] 
                            withRowAnimation:UITableViewRowAnimationRight];
    
    // Start resolution to get TXT record
    [aNetService setDelegate:self];
    [aNetService resolveWithTimeout:30];
}

-(void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser 
        didRemoveService:(NSNetService *)aNetService 
              moreComing:(BOOL)moreComing {
    NSLog(@"Removing %@", aNetService);
    
    NSUInteger row = [netServices indexOfObject:aNetService];
    
    if (row == NSNotFound) {
        NSLog(@"Unable to find the service in %@", netServices);
        return;
    }
    
    [netServices removeObjectAtIndex:row];
    
    // Update the interface
    NSIndexPath *ip = [NSIndexPath indexPathForRow:row 
                                         inSection:0];
    
    [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:ip]
                            withRowAnimation:UITableViewRowAnimationRight];
}

#pragma mark -
#pragma mark Defined in UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return [netServices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNetService *service = [netServices objectAtIndex:[indexPath row]];
    
    NSString *message = nil;
    
    // Try to get the TXT record
    NSData *data = [service TXTRecordData];
    
    // Is there TXT data? (no TXT data in unresolved services)
    if (data) {
        NSDictionary *txtDict = [NSNetService dictionaryFromTXTRecordData:data];
        
        // Get the data that the publisher put in under the message key
        NSData *mData = [txtDict objectForKey:@"message"];
        
        // Is there data?
        if (mData) {
            message = [[NSString alloc] initWithData:mData 
                                            encoding:NSUTF8StringEncoding];
            
            [message autorelease];
        }
    }
    
    if (!message) {
        // Use a default message
        message = @"<No message>";
    }
    
    UITableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 
                                       reuseIdentifier:@"UITableViewCell"] 
                autorelease];
        
    }
    
    [[cell textLabel] setText:[service name]];
    [[cell detailTextLabel] setText:message];

    return cell;
}

#pragma mark -
#pragma mark Defined in UITableViewController 

- (id)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

@end
