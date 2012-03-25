//
//  Possession.m
//  RandomPossessions
//
//  Created by Bryan Irace on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Possession.h"

@implementation Possession

@synthesize possessionName, serialNumber, valueInDollars, dateCreated, imageKey,
inheritorName, inheritorNumber;

#pragma mark -
#pragma mark Defined in NSObject

- (id)init {
	return [self initWithPossessionName:@"Possession" 
						valueInDollars:0 
						   serialNumber:@""];
}

- (NSString *)description {
	NSString *descriptionString = [NSString stringWithFormat:@"%@ (%@): Worth $%d, Recorded on %@",
								   possessionName,
								   serialNumber,
								   valueInDollars,
								   dateCreated];
	return descriptionString;
}

- (void)dealloc {
	[possessionName release];
	[serialNumber release];
	[dateCreated release];
    [imageKey release];
    [thumbnail release];
    [thumbnailData release];
    [inheritorName release];
    [inheritorNumber release];
    
	[super dealloc];
}

#pragma mark -
#pragma mark Defined in NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
    // For each instance variable, archive it
    [encoder encodeObject:possessionName forKey:@"possessionName"];
    [encoder encodeObject:serialNumber forKey:@"serialNumber"];
    [encoder encodeInt:valueInDollars forKey:@"valueInDollars"];
    [encoder encodeObject:dateCreated forKey:@"dateCreated"];
    [encoder encodeObject:imageKey forKey:@"imageKey"];
    [encoder encodeObject:thumbnailData forKey:@"thumbnailData"];
    [encoder encodeObject:inheritorName forKey:@"inheritorName"];
    [encoder encodeObject:inheritorNumber forKey:@"inheritorNumber"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    [super init];
    
    // For each instance variable that is archived, we decode it,
    // and pass it to our setters. (Where it is retained)
    [self setPossessionName:[decoder decodeObjectForKey:@"possessionName"]];
    [self setSerialNumber:[decoder decodeObjectForKey:@"serialNumber"]];
    [self setValueInDollars:[decoder decodeIntForKey:@"valueInDollars"]];
    [self setImageKey:[decoder decodeObjectForKey:@"imageKey"]];
    [self setInheritorName:[decoder decodeObjectForKey:@"inheritorName"]];
    [self setInheritorNumber:[decoder decodeObjectForKey:@"inheritorNumber"]];

    // dateCreated is read only, we have no setter. We explicitly retain it
    // and set our instance variable pointer to it
    dateCreated = [[decoder decodeObjectForKey:@"dateCreated"] retain];

    thumbnailData = [[decoder decodeObjectForKey:@"thumbnailData"] retain];
    
    return self;
}

#pragma mark -
#pragma mark Defined in header

- (id)initWithPossessionName:(NSString *)pName 
			   valueInDollars:(int)value 
				 serialNumber:(NSString *)sNumber {
	// Call the superclass's designated initializer
	self = [super init];
	
	if (!self) {
		return nil;
	}
	
	// Give the instance variables initial values
	[self setPossessionName:pName];
	[self setValueInDollars:value];
	[self setSerialNumber:sNumber];
	dateCreated = [[NSDate alloc]init];
	
	// Return the address of the newly initialized object
	return self;
}

- (id)initWithPossessionName:(NSString *)pName {
	return [self initWithPossessionName:pName 
						 valueInDollars:0
						   serialNumber:@""];
}

+ (id)randomPossession {
	static NSString *randomAdjectiveList[3] = {
		@"Fluffy",
		@"Rusty",
		@"Shiny"
	};
	
	static NSString *randomNounList[3] = {
		@"Bear",
		@"Spork",
		@"Mac"
	};
	
	NSString *randomName = [NSString stringWithFormat:@"%@ %@",
							randomAdjectiveList[random() % 3],
							randomNounList[random() % 3]];
	
	int randomValue = random() % 100;
	
	NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
									'0' + random() % 10,
									'A' + random() % 26,
									'0' + random() % 10,
									'A' + random() % 26,
									'0' + random() % 10];
	
	Possession *newPossession = [[self alloc] initWithPossessionName:randomName 
													  valueInDollars:randomValue 
														serialNumber:randomSerialNumber];
	
	return [newPossession autorelease];
}

- (UIImage *)thumbnail {
    // Am I imageless?
    if (!thumbnailData) {
        return nil;
    }
    
    // Is there no cached thumbnail image?
    if (!thumbnail) {
        // Create the image from the data
        thumbnail = [[UIImage imageWithData:thumbnailData] retain];
    }
    
    return thumbnail;
}

- (void)setThumbnailFromImage:(UIImage *)image {
    // Release the old thumbnail data
    [thumbnailData release];
    
    // Release the old thumbnail
    [thumbnail release];
    
    // Create an empty image of size 70 x 70
    CGRect imageRect = CGRectMake(0, 0, 70, 70);
    UIGraphicsBeginImageContext(imageRect.size);
    
    // Render the big image onto the image context
    [image drawInRect:imageRect];
    
    // Make a new one from the image context
    thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    
    // Retain the new one
    [thumbnail retain];
    
    // Clean up image context resources
    UIGraphicsEndImageContext();
    
    // Make a new data object from the image
    thumbnailData = UIImageJPEGRepresentation(thumbnail, 0.5);
    // You may get malloc warnings from the simulator on this line
    // That is a bug in the simulator
    
    // Retain it
    [thumbnailData retain];
}

@end
