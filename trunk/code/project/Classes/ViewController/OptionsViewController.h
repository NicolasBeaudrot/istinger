//
//  OptionsViewController.h
//  iStingerProject
//
//  Created by UTBM on 14/10/10.
//  Copyright 2010 Nicolas Beaudrot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnexionManager.h"
#import "CommandRobotController.h"

@interface OptionsViewController : UIViewController {
	
	IBOutlet UITextField  *ipTextEdit;
	IBOutlet UILabel  *serverStatusLabel;
	IBOutlet UISlider *speedSlider;
	NSTimer *timer;
	
}

//Methods
- (void) updateInterface;

//Actions
-(IBAction) changeServer:(id)sender;
-(IBAction) changeSpeed:(id)sender;

@end
