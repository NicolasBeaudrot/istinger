//
//  CommandRobotController.m
//  iStingerProject
//
//  Created by Meddle-Flocon on 27/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CommandRobotController.h"
#include <stdio.h>

@implementation CommandRobotController

static CommandRobotController *sharedCommandRobot = nil; //pour stocker l’unique instanciation de l'objet CommandRobot.

-(id) init{
	[super init];
	drivingPtr = nil;
	return self;
}

/*
timer = [NSTimer scheduledTimerWithTimeInterval:3.0
										 target:self
									   selector: @selector(updateInterface)
									   userInfo:nil
										repeats: YES];
*/

/*Faire avancer le robot*/
- (NSString*) goStraight {	
	[[ConnexionManager sharedConnexion] send:@"vel<CR>"];
	return [NSString stringWithFormat:@"vel<CR>"];
}

/*Faire tourner à droite le robot*/
-(NSString *) goRight{
	[[ConnexionManager sharedConnexion] send:@"sensor 5<CR>"];
	return [NSString stringWithFormat:@"sensor 5<CR>"];
	//[[ConnexionManager sharedConnexion] send:@"mogo 1:65 2:25<CR>"];
	//return [NSString stringWithFormat:@"mogo 1:65 2:25<CR>"];
}

/*Faire tourner à gauche le robot*/
-(NSString *) goLeft{
	[[ConnexionManager sharedConnexion] send:@"mogo 1:25 2:65<CR>"];
	return [NSString stringWithFormat:@"mogo 1:25 2:65<CR>"];
}

-(NSString *) moveBack{
	[[ConnexionManager sharedConnexion] send:@"mogo 1:-45 2:-45<CR>"];
	return [NSString stringWithFormat:@"mogo 1:-45 2:-45<CR>"];
}

-(NSString *) turnBack{
	[[ConnexionManager sharedConnexion] send:@"mogo 1:55 2:-55<CR>"];
	return [NSString stringWithFormat:@"mogo 1:55 2:-55<CR>"];
}

-(NSString *) stop{
	[[ConnexionManager sharedConnexion] send:@"stop<CR>"];
	return [NSString stringWithFormat:@"stop<CR>"];
}


//TO DO : CALCULER LA VITESSE ET REFAIRE CETTE FONCTION
-(NSString *) changeSpeed:(int)value {
	NSString *chaine = [NSString stringWithFormat:@"pwm 1:%d 2:%d<CR>",value, value];
	[[ConnexionManager sharedConnexion] send: chaine];
	return [NSString stringWithFormat:chaine];
}


-(void) askRegulary {
	
	NSString *str_speed, *str_battery;
	str_speed =	[self askSpeed];
	str_battery = [self askBattery];
	NSLog(@"ask_speed : %s, ask_battery : %s", str_speed, str_battery);
	
}


/*Commande qui interroge le serveur sur la vitesse actuelle des 2 roues*/
-(NSString *) askSpeed {
	[[ConnexionManager sharedConnexion] send:@"vel<CR>"];
	return [NSString stringWithFormat:@"vel<CR>"];
}

/*Commande qui interroge le serveur sur la valeur de la batterie*/
-(NSString *) askBattery {
	[[ConnexionManager sharedConnexion] send:@"sensor 5<CR>"];
	return [NSString stringWithFormat:@"sensor 5<CR>"];
}

/*Fonction appelée lorsque le robot envoie un message*/
-(void) serverResponse:(NSString *)command:(NSString *)message {
	int roue1, roue2, moy;
	float tmp, battery;
	
	NSLog(@"COUUUUCOUUUUUUUUUUUUU");
	NSLog(@"Received : %@ - %@", command, message);
	
	//Si le serveur nous donne la vitesse "vel"
	if ([command isEqualToString:@"vel<CR>"]) { 
		NSString *msg = @"45 60";
		NSScanner *scan = [NSScanner scannerWithString:msg];

		//On récupère les valeurs des 2 roues
		[scan scanInt: &roue1];
		[scan scanString:@" " intoString:nil]; 
		[scan scanInt: &roue2];
		NSLog(@"roue 1 = %d \n",roue1);
		NSLog(@"roue 2 = %d \n",roue2);

		//calcul de la moyenne des 2 roues
		moy = (roue1 + roue2)/2;
		NSLog(@"moyenne = %d", moy);
		
		//on envoie à DrivingView la valeur de la vitesse, pour qu'il l'affiche sur le compteur
		[drivingPtr updateSpeed:moy];
	} 
	else if ([command isEqualToString:@"sensor"]) {
		
		NSString *msg2 = @"446";
		NSScanner *scan2 = [NSScanner scannerWithString:msg2];

		//On récupère la valeur retournée par le serveur
		[scan2 scanFloat : &tmp];
	
		//On calcule la valeur exacte de la battery
		battery = tmp * (15.0/1028.0);
		
		[drivingPtr updatePower:battery]; // on met à jour l'image de la pile
		NSLog(@"batterie = %f V", battery);
	
		}
	
		 else {
			NSLog(@"command not found");
	}
}

-(void) setDrivingView:(DrivingViewController*)view {
	drivingPtr = view;
}

/*Pour instancier la classe comme un singleton*/
+ (CommandRobotController *) sharedCommand {
    if (sharedCommandRobot == nil) {
        sharedCommandRobot = [[super allocWithZone:NULL] init];
    }
    return sharedCommandRobot;
}

@end
