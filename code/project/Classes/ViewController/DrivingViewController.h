//
//  DrivingViewController.h
//  iStingerProject
//
//  Created by UTBM on 14/10/10.
//  Copyright 2010 Nicolas Beaudrot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandRobotController.h"

@interface DrivingViewController : UIViewController <UIAccelerometerDelegate> {
	IBOutlet UILabel *speedLabel;
	IBOutlet UILabel *distanceLabel;
	IBOutlet UIView *drivingView;
	IBOutlet UIButton *btnUp;
	IBOutlet UIButton *btnDown;
	IBOutlet UIButton *btnRight;
	IBOutlet UIButton *btnLeft;
	IBOutlet UIButton *btnStop;
	IBOutlet UIImageView *imgPower;
	NSTimer *timer;
	int prevMode;
	int prevDirection;
}
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
- (void) updatePower:(int)power;

@end
