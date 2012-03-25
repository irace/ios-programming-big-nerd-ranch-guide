//
//  QuizAppDelegate.h
//  Quiz
//
//  Created by Bryan Irace on 10/4/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizAppDelegate : NSObject <UIApplicationDelegate> {
	int currentQuestionIndex;
	
	// The model objects
	NSMutableArray *questions;
	NSMutableArray *answers;
	
	// The view objects
	IBOutlet UILabel *questionField;
	IBOutlet UILabel *answerField;
	
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (IBAction)showQuestion:(id)sender;
- (IBAction)showAnswer:(id)sender;

@end

