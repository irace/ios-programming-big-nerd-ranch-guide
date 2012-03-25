//
//  Possession.m
//  RandomPossessions
//
//  Created by Bryan Irace on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Possession.h"

@implementation Possession

@synthesize possessionName, serialNumber, valueInDollars, dateCreated;

- (id)init {
	return [self initWithPossessionName:@"Possession" 
						valueInDollars:0 
						   serialNumber:@""];
}

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
	[dateCreate release];
	[super dealloc];
}

@end
