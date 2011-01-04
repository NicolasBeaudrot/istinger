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

@interface OptionsViewController : UIViewController <UITextFieldDelegate> {
	
	IBOutlet UITextField  *ipTextEdit;
	IBOutlet UITextField  *portTextEdit;
	IBOutlet UILabel  *serverStatusLabel;
	IBOutlet UIButton *connectButton;
	NSTimer *timer;
	
}

//Methods
- (void) updateInterface;

//Actions
-(IBAction) changeServer:(id)sender;
-(IBAction) changePort:(id)sender;
-(IBAction) connectAction:(id)sender;

@end
