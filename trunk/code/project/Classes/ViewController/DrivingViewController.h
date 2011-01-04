//
//  DrivingViewController.h
//  iStingerProject
//
//  Created by UTBM on 14/10/10.
//  Copyright 2010 Nicolas Beaudrot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandRobotController.h"
#import <QuartzCore/CALayer.h>
#define degreesToRadians(x) (M_PI * x / 180.0)

@interface DrivingViewController : UIViewController <UIAccelerometerDelegate> {
	IBOutlet UILabel *speedLabel;
	IBOutlet UILabel *distanceLabel;
	IBOutlet UIView  *drivingView;
	IBOutlet UIButton *btnUp;
	IBOutlet UIButton *btnDown;
	IBOutlet UIButton *btnRight;
	IBOutlet UIButton *btnLeft;
	IBOutlet UIButton *btnStop;
	IBOutlet UIImageView *imgPower;
	UIView *cptSpeed;
	
	NSTimer *timer;
	int prevMode;
	int prevDirection;
	int currentSpeed;	//pour le compteur
	float currentBattery; // pour la pile 
	int vel2; 
	
}

//@property (nonatomic, retain) IBOutlet UIImageView *cptSpeed;
@property (nonatomic, retain) IBOutlet UIView *cptSpeed;
@property (assign) float_t currentBattery;

+ (DrivingViewController *) sharedDriving;
/*Boutons d'action*/
- (IBAction) btnClicUp:(id)sender;
- (IBAction) btnClicDown:(id)sender;
- (IBAction) btnClicLeft:(id)sender;
- (IBAction) btnClicRight:(id)sender;
- (IBAction) btnClicStop:(id)sender;

/*Method*/
- (void) turnScreen:(int)mode;
- (void) updateInterface;
- (void) updateSpeed:(int)speed;
- (void) updateDistance:(int)distance;
- (float) updatePower:(float)power;
- (int) getSpeed;
- (void) setSpeed:(int)speed;
- (float) getBattery;
- (void) setBattery:(float)power;


@end
