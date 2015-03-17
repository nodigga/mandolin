//
//  ViewController.h
//  mandolin
//
//  Created by Nicholas Cardinal on 3/3/15.
//  Copyright (c) 2015 nodigga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{


    CGPoint position;
    IBOutlet UIImageView *image;
    NSTimer *timer;
    NSTimeInterval bpm;

}
-(IBAction)Start;
-(IBAction)Stop;

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISlider *slider;


@property (weak, nonatomic) IBOutlet UIButton *myButton1;
@property (weak, nonatomic) IBOutlet UIButton *myButton2;
@property (weak, nonatomic) IBOutlet UIButton *myButton3;
@property (weak, nonatomic) IBOutlet UIButton *myButton4;


@end
