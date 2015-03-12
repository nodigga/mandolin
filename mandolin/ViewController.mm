//
//  ViewController.m
//  mandolin
//
//  Created by Nicholas Cardinal on 3/3/15.
//  Copyright (c) 2015 nodigga. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "AEAudioController.h"
#import "AEBlockChannel.h"
#import "Mandolin.h"
#import "Moog.h"


@interface ViewController ()

@end

@implementation ViewController{

    AEBlockChannel *myMandolinChannel;
    stk::Mandolin *myMandolin;
    
    AEBlockChannel *myMoogChannel;
    stk::Moog *myMoog;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSError *errorAudioSetup = NULL;
    BOOL result = [[appDelegate audioController] start:&errorAudioSetup];
    if ( !result ) {
        NSLog(@"Error starting audio engine: %@", errorAudioSetup.localizedDescription);
    }
    stk::Stk::setRawwavePath([[[NSBundle mainBundle] pathForResource:@"rawwaves" ofType:@"bundle"] UTF8String]);
    
    
    myMandolin = new stk::Mandolin(400);
    myMandolin->setFrequency(400);
    
    myMandolinChannel = [AEBlockChannel channelWithBlock:^(const AudioTimeStamp  *time,
                                                           UInt32 frames,
                                                           AudioBufferList *audio) {
        for ( int i=0; i<frames; i++ ) {
            
            ((float*)audio->mBuffers[0].mData)[i] =
            ((float*)audio->mBuffers[1].mData)[i] = myMandolin->tick();
            
        }
    }];
    
    [[appDelegate audioController] addChannels:@[myMandolinChannel]];
    
    myMoog = new stk::Moog();
    myMoog->setFrequency(400);
    
    myMoogChannel = [AEBlockChannel channelWithBlock:^(const AudioTimeStamp  *time,
                                                           UInt32 frames,
                                                           AudioBufferList *audio) {
        for ( int i=0; i<frames; i++ ) {
            
            ((float*)audio->mBuffers[0].mData)[i] =
            ((float*)audio->mBuffers[1].mData)[i] = myMoog->tick();
            
        }
    }];
    
    [[appDelegate audioController] addChannels:@[myMoogChannel]];

    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)pluckMyMandolin {
    self->myMandolin->pluck(1);
}

-(IBAction)changeFrequency:(UISlider *)sender {
    self->myMandolin->setFrequency(sender.value);
}


-(IBAction)setFrequency:(UISlider *)sender {
    self->myMoog->setFrequency(sender.value);
    
    
}

int noteOn;

- (IBAction)sliderValueChanged:(UISlider *)sender {
    noteOn = sender.value;
    
}


-(IBAction)noteOnMyMoog {
    self->myMoog->noteOn(noteOn,0.8);
}

-(IBAction)noteOffMyMoog {
    self->myMoog->noteOff(1);
}




@end
