//
//  Possession.h
//  RandomPossessions
//
//  Created by Bryan Irace on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Possession : NSObject <NSCoding> {
	NSString *possessionName;
	NSString *serialNumber;
	int valueInDollars;
	NSDate *dateCreated;
    NSString *imageKey;
    UIImage *thumbnail;
    NSData *thumbnailData;
    NSString *inheritorName;
    NSString *inheritorNumber;
}

@property (nonatomic, copy) NSString *possessionName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly) NSDate *dateCreated;
@property (nonatomic, copy) NSString *imageKey;
@property (readonly) UIImage *thumbnail;
@property (nonatomic, copy) NSString *inheritorName;
@property (nonatomic, copy) NSString *inheritorNumber;

- (void)setThumbnailFromImage:(UIImage *)image;

- (id)initWithPossessionName:(NSString *)pName 
			  valueInDollars:(int)value 
				serialNumber:(NSString *)sNumber;

- (id)initWithPossessionName:(NSString *)pName;

+ (id)randomPossession;

@end
