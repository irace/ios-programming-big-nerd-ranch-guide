//
//  MediaPlayerAppDelegate.h
//  MediaPlayer
//
//  Created by Bryan Irace on 11/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MediaPlayerAppDelegate : NSObject <UIApplicationDelegate, 
        AVAudioPlayerDelegate> {
    UIWindow *window;
    IBOutlet UIButton *audioButton;
    SystemSoundID shortSound;
    AVAudioPlayer *audioPlayer;
    MPMoviePlayerController *moviePlayer;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (IBAction)playAudioFile:(id)sender;
- (IBAction)playVideoFile:(id)sender;
- (IBAction)playShortSound:(id)sender;

@end

