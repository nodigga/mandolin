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

static NSString *btnImage1 = @"Pad_2.png";
static NSString *btnImage2 = @"Pad_1.png";

@interface ViewController (){

bool state1;
bool state2;
bool state3;
bool state4;

bool isOn1;
bool isOn2;
bool isOn3;
bool isOn4;

int current_state;
    
}

@end


@implementation ViewController{

    AEBlockChannel *myMandolinChannel;
    stk::Mandolin *myMandolin;
    
    AEBlockChannel *myMoogChannel;
    stk::Moog *myMoog;

    
    

    
}



-(IBAction)Start {
    [self Stop];
    timer = [NSTimer scheduledTimerWithTimeInterval:(bpm)
                                             target: self
                                           selector:@selector(onTimer)
                                           userInfo: nil repeats: YES];
    
    
    current_state = 0;
    
}

-(IBAction)Stop
{
    if (timer != nil)
    {
        [timer invalidate];
        timer = nil;
    }
    
    state1 = false;
    state2 = false;
    state3 = false;
    state4 = false;
    
    [self.myButton1 setSelected:NO];
    [self.myButton2 setSelected:NO];
    [self.myButton3 setSelected:NO];
    [self.myButton4 setSelected:NO];
    
}

-(void)onTimer {
   
    [self.myButton1 setSelected:NO];
    [self.myButton2 setSelected:NO];
    [self.myButton3 setSelected:NO];
    [self.myButton4 setSelected:NO];

    switch (current_state)
    {
        case 0:
        {
            [self.myButton1 setSelected:YES];
            self->myMandolin->pluck(1);
            break;
        }
        case 1:
        {
            [self.myButton2 setSelected:YES];
            self->myMandolin->pluck(1);
            break;
        }
        case 2:
        {
            [self.myButton3 setSelected:YES];
            self->myMandolin->pluck(1);
            break;
        }
        case 3:
        {
            [self.myButton4 setSelected:YES];
            self->myMandolin->pluck(1);
            break;
        }
    }
    
    current_state++;
    if(current_state == 4){
        current_state = 0;
    }
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

    bpm = 0.5;
    
    [self.myButton1 setBackgroundImage:[UIImage imageNamed:btnImage2] forState:UIControlStateNormal];
    [self.myButton2 setBackgroundImage:[UIImage imageNamed:btnImage2] forState:UIControlStateNormal];
    [self.myButton3 setBackgroundImage:[UIImage imageNamed:btnImage2] forState:UIControlStateNormal];
    [self.myButton4 setBackgroundImage:[UIImage imageNamed:btnImage2] forState:UIControlStateNormal];
    [self.myButton1 setBackgroundImage:[UIImage imageNamed:btnImage1] forState:UIControlStateSelected];
    [self.myButton2 setBackgroundImage:[UIImage imageNamed:btnImage1] forState:UIControlStateSelected];
    [self.myButton3 setBackgroundImage:[UIImage imageNamed:btnImage1] forState:UIControlStateSelected];
    [self.myButton4 setBackgroundImage:[UIImage imageNamed:btnImage1] forState:UIControlStateSelected];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(IBAction)pluckMyMandolin {
    //self->myMandolin->pluck(1);
    
    
    if(isOn1 ==false)
    {isOn1 = true;
    }
    
    else {
        isOn1 = false;
    
    }
   
    //NSLog(@"value is %d", isOn1);
    
    //[self.myButton1 setBackgroundImage:btnImage forState:UIControlStateHighlighted];
}

-(IBAction)padTwoTouch {
    //self->myMandolin->pluck(1);
    
    
    if(isOn2 ==false)
    {isOn2 = true;
    }
    
    else {
        isOn2 = false;
        
    }
    
    NSLog(@"value is %d", isOn2);
    
    //[self.myButton1 setBackgroundImage:btnImage forState:UIControlStateHighlighted];
}


-(IBAction)padThreeTouch {
    //self->myMandolin->pluck(1);
    
    
    if(isOn3 ==false)
    {isOn3 = true;
    }
    
    else {
        isOn3 = false;
        
    }
    
    //[self.myButton1 setBackgroundImage:btnImage forState:UIControlStateHighlighted];
}


-(IBAction)padFourTouch {
    //self->myMandolin->pluck(1);
    
    
    if(isOn4 == false)
    {isOn4 = true;
    }
    
    else {
        isOn4 = false;
        
    }
    
    
    
    //[self.myButton1 setBackgroundImage:btnImage forState:UIControlStateHighlighted];
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
    //self->myMoog->noteOn(noteOn,0.8);
    
   // [self.myButton2 setBackgroundImage:btnImage forState:UIControlStateHighlighted];
    
    
}

-(IBAction)noteOffMyMoog {
    self->myMoog->noteOff(1);
}

-(IBAction)sliderBpmValueChanged:(UISlider *)sender {
   
    bpm = [sender value];
    [self Stop];
    [self Start];
    
    
    
    //NSLog(@"bpm is %f ", bpm);

    
    
    //bpm = [NSNumber numberWithDouble:result];
    
    
    
    
}

@end
