//
//  MediaPlayerAppDelegate.m
//  MediaPlayer
//
//  Created by Bryan Irace on 11/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MediaPlayerAppDelegate.h"

@implementation MediaPlayerAppDelegate

@synthesize window;

#pragma mark -
#pragma mark Defined in header

- (IBAction)playAudioFile:(id)sender {
    if ([audioPlayer isPlaying]) {
        // Stop playing audio and change text of button
        [audioPlayer stop];
        [sender setTitle:@"Play Audio File" forState:UIControlStateNormal];
    } else {
        // Start playing audio and change text of button so user can tap to stop
        // playback
        [audioPlayer play];
        [sender setTitle:@"Stop Audio File" forState:UIControlStateNormal];
    }
}

- (IBAction)playVideoFile:(id)sender {
    [moviePlayer play];  
}

- (IBAction)playShortSound:(id)sender {
    AudioServicesPlaySystemSound(shortSound);  
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

#pragma mark -
#pragma mark Defined in AVAudioPlayer

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player 
                       successfully:(BOOL)flag {
    [audioButton setTitle:@"Play Audio File" forState:UIControlStateNormal];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
    [player play];
}

#pragma mark -
#pragma mark Defined in UIApplicationDelegate

- (BOOL)application:(UIApplication *)application 
        didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Get the full path of Sound12.aif
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"Sound12" 
                                                          ofType:@"aif"];
    
    // If this sound is actually in the bundle...
    if (soundPath) {
        // Create a file URL with this path
        NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
        
        // Register sound file located at that URL as a system sound
        OSStatus err = AudioServicesCreateSystemSoundID((CFURLRef)soundURL, 
                                                        &shortSound);
        
        if (err != kAudioServicesNoError) {
            NSLog(@"Could not load %@, error code: %d", soundURL, err);
        }
    }
    
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"Music" 
                                                          ofType:@"mp3"];
    
    if (musicPath) {
        NSURL *musicURL = [NSURL fileURLWithPath:musicPath];
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL 
                                                             error:nil];
        [audioPlayer setDelegate:self];
    }
    
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"Layers" 
                                                          ofType:@"m4v"];
    
    if (moviePath) {
        NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
        moviePlayer = [[MPMoviePlayerController alloc] 
                       initWithContentURL:movieURL];
    }
    
    [window makeKeyAndVisible];
    return YES;
}

#pragma mark -
#pragma mark Defined in NSObject

- (void)dealloc {
    [window release];
    [super dealloc];
}

@end
