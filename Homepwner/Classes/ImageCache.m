//
//  ImageCache.m
//  Homepwner
//
//  Created by Bryan Irace on 11/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImageCache.h"

static ImageCache *sharedImageCache;

@implementation ImageCache

#pragma mark -
#pragma mark Overriding from NSObject

- (id)init {
	[super init];
	dictionary = [[NSMutableDictionary alloc] init];
    
    NSNotificationCenter *notificationCenter = 
            [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self 
                           selector:@selector(clearCache:) 
                               name:
     UIApplicationDidReceiveMemoryWarningNotification 
                             object:nil];
    
	return self;
}

#pragma mark -
#pragma mark Singleton stuff

+ (ImageCache *)sharedImageCache {
	if (sharedImageCache) {
		return sharedImageCache;
	}
	
	return [[ImageCache alloc] init];
}

+ (id)allocWithZone:(NSZone *)zone {
	if (sharedImageCache) {
		return nil;
	}
	
	sharedImageCache = [super allocWithZone:zone];
	return sharedImageCache;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (void)release {
	// No-op
}

#pragma mark -
#pragma mark Defined in header

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
	[dictionary setObject:image forKey:key];
    
    // Create full path for image
    NSString *imagePath = pathInDocumentDirectory(key);
    
    // Turn image into JPEG data
    NSData *d = UIImageJPEGRepresentation(image, 0.5);
    
    // Write it to full path
    [d writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key {
	UIImage *result = [dictionary objectForKey:key];
    
    if (!result) {
        // Create UIImage object from file
        result = [UIImage imageWithContentsOfFile:pathInDocumentDirectory(key)];
        
        // If we found an image on the file system, place it into the cache
        if (result) {
            [dictionary setObject:result forKey:key];
        } else {
            NSLog(@"Error: unable to find %@", pathInDocumentDirectory(key));
        }
    }
    
    return result;
}

- (void)deleteImageForKey:(NSString *)key {
	[dictionary removeObjectForKey:key];
    
    NSString *path = pathInDocumentDirectory(key);
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

#pragma mark -
#pragma mark Private methods

- (void)clearCache:(NSNotification *)note {
    NSLog(@"Flushing %d images out of the cache", [dictionary count]);
    [dictionary removeAllObjects];
}

// No dealloc method since this is a singleton that will last the lifetime of the application

@end
