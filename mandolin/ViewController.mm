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

UIImage *btnImage = [UIImage imageNamed:@"Pad_2.png"];


-(IBAction)Start {
    timer = [NSTimer scheduledTimerWithTimeInterval:(0.1)
                                             target: self
                                           selector:@selector(onTimer)
                                           userInfo: nil repeats: YES];
}

-(IBAction)Stop {
    if (timer != nil)
    {
        [timer invalidate];
        timer = nil;
    }
}

-(void)onTimer {
    NSLog(@ "works!");
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
    
   

    [self.myButton1 setBackgroundImage:btnImage forState:UIControlStateHighlighted];
}



-(IBAction)changeFrequency:(UISlider *)sender {
    self->myMandolin->setFrequency(sender.value);
}


-(IBAction)setFrequency:(UISlider *)sender {
    self->myMoog->setFrequency(sender.value);
    
    
}

int noteOn = 440;

- (IBAction)sliderValueChanged:(UISlider *)sender {
    noteOn = sender.value;
    
}


-(IBAction)noteOnMyMoog {
    self->myMoog->noteOn(noteOn,0.8);
    
    [self.myButton2 setBackgroundImage:btnImage forState:UIControlStateHighlighted];
    
    
}

-(IBAction)noteOffMyMoog {
    self->myMoog->noteOff(1);
}

-(IBAction)sliderBpmValueChanged:(UISlider *)sender {
    float bpm = [sender value];
    
    NSLog(@"bpm is %f ", bpm);

}

@end
