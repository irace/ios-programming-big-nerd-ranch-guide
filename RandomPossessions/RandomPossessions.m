#import <Foundation/Foundation.h>
#import "Possession.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	NSMutableArray *items = [[NSMutableArray alloc] init];

	for (int i = 0; i < 10; i++) {
		[items addObject:[Possession randomPossession]];
		
	}
	
	for (Possession *item in items) {
		NSLog(@"%@", item);
	}
	
	[items release];
	items = nil;
	
    [pool drain];
    return 0;
}
