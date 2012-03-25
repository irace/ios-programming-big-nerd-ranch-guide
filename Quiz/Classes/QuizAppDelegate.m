//
//  QuizAppDelegate.m
//  Quiz
//
//  Created by Bryan Irace on 10/4/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "QuizAppDelegate.h"

@implementation QuizAppDelegate

@synthesize window;

- (id)init {
	// Call the init method implemented by the superclas
	[super init];
	
	// Create two arrays and make the pointers point to them
	questions = [[NSMutableArray alloc] init];
	answers = [[NSMutableArray alloc] init];
	
	// Add questions and answers to the arrays
	[questions addObject:@"What is 7+7"];
	[answers addObject:@"14"];
	
	[questions addObject:@"What is the capital of Vermont?"];
	[answers addObject:@"Montpelier"];
	
	[questions addObject:@"From what is cognac made?"];
	[answers addObject:@"Grapes"];
	 
	 // Return the address of the new object
	 return self;
}
	 
- (IBAction)showQuestion:(id)sender {
	// Step to the next question
	currentQuestionIndex++;
	
	// Am I past the last question?
	if (currentQuestionIndex == [questions count]) {
		// Go back to the first question
		currentQuestionIndex = 0;
	}
	
	// Get the string at that index in the questions array
	NSString *question = [questions objectAtIndex:currentQuestionIndex];
	
	NSLog(@"Displaying question %@", question);
	
	// Display the string in the question field
	[questionField setText:question];
	
	// Clear the answer field
	[answerField setText:@"???"];
}

- (IBAction)showAnswer:(id)sender {
	// What is the answer to the current question?
	NSString *answer = [answers objectAtIndex:currentQuestionIndex];
	
	// Display it in the answer field
	[answerField setText:answer];
}
	 
- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
