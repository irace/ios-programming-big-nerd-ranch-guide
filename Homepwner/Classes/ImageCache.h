//
//  ImageCache.h
//  Homepwner
//
//  Created by Bryan Irace on 11/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject {
	NSMutableDictionary *dictionary;
}

+ (ImageCache *)sharedImageCache;
- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;

@end
