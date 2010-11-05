#!/usr/bin/php -q
<?php
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Socket Server
// CLI PHP application that passes messages to/from all connected clients.
// Version 1.0, released May 2008
// Written by Richard Shields
// www.rshields.com
// September 2007
//
// This program is free for any commercial or non-commercial use.  I would really appreciate
// keeping my name and website link somewhere near the top of the comments of the server,
// but I'm not going to require that because anyone competent in PHP probably could have
// written something similar to this in about 4 or 5 hours.  I'm also not requiring any
// visual credits in the clients connecting to this server, but if you have an appropriate
// place in your applications for such a thing, I think it would be cool if you did give a
// little credit...
//
// I'm also not requiring any kinds of donations or fees for use, but they won't be turned
// away if offered.
//
// I would love to see what kinds of cool things people do with this server.  Please email
// installation photos, applications, overviews, etc. to me, richard@rshields.com, and in
// your emails please let me know if it is ok to post your demonstrated use on my site.
// It's not required for you to say you don't want me to post anything, but it IS required
// that you tell me you DO want me to, otherwise I can't legally post your content because
// YOU own it, not me.
//
// usage: ./socketserver.sh
//
// parameters: 	-v : turns verbose mode on; default is not verbose, messages will not show
//				example: './socketserver.sh -v' starts socketserver in verbose mode
//				[ip] : sets ip address to use (if valid)
//				example: './socketserver.sh 192.168.0.5' starts socketserver at address 192.168.0.5
//				-l : sets ip to use as 127.0.0.1 (localhost)
//				example: './socketserver.sh -l' starts socketserver at address 127.0.0.1
//				-r : sets ip address to use to an assigned or static external ip
//				example: './socketserver.sh -r' queries the OS for its ip address and uses that ip
//				[port] : sets port to use
//				example: './socketserver.sh 5783' starts socketserver on port 5783
//				-m [#] : sets maximum number of clients that can talk to the server
//				example: './socketserver.sh -m 22' allows 22 clients to connect
//				-e [# .. #]: sets eol character(s) for all messages
//				example: './socketserver.sh -e 0 14' ends messages with chr(0).chr(14)
//				-c : enables client mode (requires php version 4 and a *nix OS (linux, Darwin)
//				example: './socketserver.sh -c' allows keyboard input and broadcasts what is typed to all clients
//
// The way it works: socketserver.sh finds the local IP address, then binds to either that
// address or a parameter-defined address on the port passed as a parameter (or default of 6780).
// Clients can then connect to that ip and port, which will put them in an array of clients
// ($clients).  If messages are received from any of the clients, the message is passed on 
// to all connected clients.  Only accepts clients while length of the $clients array is
// less than the maximum (passed as a parameter, or default 20).
//
// Order of precedence for parameters, from lowest to highest:
//	- defaults (defined below)
//	- socketserver.conf file contents
//	- manually entered values passed as parameters when starting server from the command line
//
// Written for and tested on Linux (XUbuntu) and Mac OS X (10.4 and 10.5)

// DEFAULTS:
// verbose mode
$verbose = false;
// local ip address
$address = '127.0.0.1';
// port to listen to.
$port=6780;
// maximum number of clients
$max_clients = 20;
// characters to send at the end of a line
$eolstring="\n".chr(0);
// client mode off
$clientModeRequest = false;
// default is no ip defined, no port defined
$definedIP = false;
$definedPort = false;

if (file_exists("socketserver.conf")) {
	print "Config file found; loading server.conf\n";
	$address = "";
	$port = 0;
	// load in the external file containing port and range of ports
	include("socketserver.conf");
	if (strlen($address) > 0) {
		$definedIP = true;
		$desiredIP = $address;
	} else {
		$definedIP = false;
		$address = '127.0.0.1';
	}
	if ($port > 0) {
		$definedPort = true;
		$desiredPort = $port;
	} else {
		$definedPort = false;
		$port = 6780;
	}
} else print "No config file found (looked for server.conf)\n";

// Set time limit to indefinite execution
set_time_limit (0);

// Function to get usec of current time as float
function microtime_float() {
	list($usec, $sec) = explode(" ", microtime());
	return ((float)$usec + (float)$sec);
}

function getServerAddress() { // returns active ip for mac os x
	global $verbose, $OS;
	if ($verbose) print "checking for Operating System...\n";
	$OS = "";
	switch(PHP_OS) {
	case "Darwin":	if ($verbose) print "Mac OS X found\n";
					$OS = "mac";
					$ifconfig = shell_exec('ifconfig | grep netmask | grep broadcast');
					$matches = explode(" ", $ifconfig);
					//print_r($matches);
					return $matches[1];
					//break;
	case "Linux":	if ($verbose) print "Linux found\n";
					$OS = "linux";
					$ifconfig = shell_exec('ifconfig | grep Bcast');
					$matches = explode(" ", $ifconfig);
					//print_r($matches);
					return substr($matches[11],5);
					//break;
	case "WinNT":	if ($verbose) print "Windows found\n";
					$OS = "win";
					$ifconfig = shell_exec('ipconfig');
					$matches = explode(" ", $ifconfig);
					print_r($matches);
					die("Socket server for windows is not written yet");
	default:		if ($verbose) die("Could not determine Operating System!");
	}
}

function removeArrayElement(&$arr, $index){
// removes single array element
	if(isset($arr[$index])){
		array_splice($arr, $index, 1);
	}
}

function logThis($message) {
// records activity in a log file (server.log)
	$log = fopen("./server.log", "a");
	fwrite($log, "$message");
	fclose($log);
}

function phpversion_real() {
// determines version of php installed
	$v = phpversion();
	$version = Array();
	foreach(explode('.', $v) as $bit) {
		if(is_numeric($bit)) {
			$version[] = $bit;
		}
	}
	return(implode('.', $version));
}

function main() {
// loops continuously, broadcasting received messages to all connected clients
	global $verbose, $OS, $address, $port, $max_clients, $eolstring, $clientModeRequest, $definedIP, $definedPort, $desiredIP, $desiredPort;
	global $argc, $argv;

	// =-=-=-=-=-=-=-SETUP-=-=-=-=-=-=-=-=
	// timer for ensuring no excessive load on the machine running the script
	$timer = microtime_float();
	// copy the log file from the last time script was run to a backup
	exec("mv ./server.log ./serverold.log");
	sleep(1);

	// check version
	$versionPHP = phpversion_real();
	$versionArray = explode(".", $versionPHP);
	if ($versionArray[0] < 4) die ("PHP version 4 is required to run SocketServer.");

	$local = false;
	$remote = false;
	// parse all the $argc's
	for ($i=1; $i<$argc; $i++) {
		//print "argument: $argv[$i]\n"; // for debugging
		// see if this parameter is an ip address
		if (substr_count($argv[$i], ".") == 3) {
			//print "triggered ip checker\n";
			$checkIPArray = explode(".", $argv[$i]);
			//print_r($checkIPArray);
			$desiredIP = "";
			foreach ($checkIPArray as $piece) {
				if (intval($piece)<256) $desiredIP .= intval($piece).".";
				else if ($verbose) print "Error: Invalid IP specified\n";
			}
			$desiredIP = substr($desiredIP, 0, -1);
			if (substr_count($desiredIP, ".") == 3) $definedIP = true;
			else {
				$time = date("m.d.y H:i:s");
				$temp = "$time: Invalid IP given: $argv[$i].\n";
				logThis($temp);
			}
			//print "ending ip: $desiredIP\n";
		}
		// check for port parameter
		if (is_numeric($argv[$i])) {
			$definedPort = true;
			$desiredPort = intval($argv[$i]);
		}
		// change to verbose if parameter -v is passed
		if (($argv[$i] == "-v") || ($argv[$i] == "-V")) {
			$verbose = true;
		}
		// check for max clients parameter
		if (($argv[$i] == "-m") || ($argv[$i] == "-M")) {
			if (is_numeric($argv[$i+1])) {
				$max_clients = intval($argv[$i+1]);
				$i++;
			}
		}
		// check for eol parameter
		if (($argv[$i] == "-e") || ($argv[$i] == "-E")) {
			$eolstring="";
			while (is_numeric($argv[$i+1])) {
				$eolstring .= chr(intval($argv[$i+1]));
				$i++;
			}
		}
		// check for client mode parameter
		if (($argv[$i] == "-c") || ($argv[$i] == "-C")) {
			$clientModeRequest = true;
		}
		// check for remote ip parameter
		if (($argv[$i] == "-r") || ($argv[$i] == "-R")) {
			$local = false;
			$remote = true;
		}
		// check for local ip parameter
		if (($argv[$i] == "-l") || ($argv[$i] == "-L")) {
			$local = true;
			$remote = false;
		}
	}

	// get IP of computer running server (this computer)
	if ($remote) $remoteAddress = getServerAddress();
	elseif ($local) $remoteAddress = '127.0.0.1';
	elseif ($definedIP) $remoteAddress = $desiredIP;
	if ($definedPort) $port = $desiredPort;
	if ($verbose) print ("Running in PHP version ".$versionPHP." environment\n");

	// determine if we can also run the client... default is false
	$clientMode = false;
	if ($clientModeRequest && (intval($versionArray[0]) > 4) && (intval($versionArray[1]) > 1)) {
		if (((intval($versionArray[2]) > 4)||(intval($versionArray[1]) > 2))&&($OS != "win")) {
			if ($verbose) print "Client mode enabled\n";
			$clientMode = true;
			$broadcastMessage = "";
		}
	}

	// Array that will hold client information
	$clients = Array();
	// Create a TCP Stream socket
	$sock = socket_create(AF_INET, SOCK_STREAM, 0);
	// Setup for client
	if ($clientMode) {
		stream_set_blocking(STDIN, FALSE);
	}

	// =-=-=-=-=-=-=-START SERVER-=-=-=-=-=-=-=-=
	// Bind the socket to an address/port
	date_default_timezone_set('Europe/Paris');
	while (true) {
		$time = date("m.d.y H:i:s");
		$success = @socket_bind($sock, $remoteAddress, $port);
		if ($success) {
			// connected!!  set up listening and break out of connect loop
			$temp = "$time: Socket Server started with address ".$remoteAddress." on port ".$port."\nMaximum clients: $max_clients\n";
			logThis($temp);
			if ($verbose) print $temp;
			// Start listening for connections
			socket_listen($sock);
			break;
		} else {
			// didn't connect...  log failure and try again later
			$temp = "$time: Socket Server could not bind to port $port at address $remoteAddress.\n";
			logThis($temp);
			if ($verbose) print $temp."Will retry in 5 seconds\n";
			sleep(5);
		}
	}

	// =-=-=-=-=-=-=-PASS MESSAGES-=-=-=-=-=-=-=-=
	// Loop continuously
	while (true) {
		//DEBUG: delay to protect the processor
		//sleep(1);
		// idle if too little time has passed
		if ((microtime_float() - $timer) < 0.050) {
			usleep(5000);
		}
		$timer = microtime_float();
		// Setup clients listen socket for reading
		$read[0] = $sock;
		for ($i = 0; $i < $max_clients; $i++) {
			if (@$clients[$i]['sock'] != null)
				$read[$i + 1] = $clients[$i]['sock'];
		}
		// Set up a nonblocking call to socket_select()
		$nothing = null;
		$ready = socket_select($read,$nothing,$nothing,0);
		$time = date("m.d.y H:i:s");
		
		// if a new connection is being made add it to the client array
		if (in_array($sock, $read)) {
			for ($i = 0; $i < $max_clients; $i++) {
				if ($clients[$i]['sock'] == null) {
					$clients[$i]['sock'] = socket_accept($sock);
					socket_getpeername($clients[$i]['sock'], $sockAddress);
					$temp = "$time: new client: $sockAddress\n";
					logThis($temp);
					if ($verbose) print $temp;
					$k = 0;
					foreach ($clients as $client) {
						$k++;
						socket_getpeername($client['sock'], $sockAddress);
						$temp = "$k: $sockAddress\n";
						logThis($temp);
					}
					break;
				}
				elseif ($i == $max_clients - 1) {
					$throwout = socket_accept($sock);
					if ($verbose) print "Too many clients\nThrowing out $throwout\n";
					$test = socket_shutdown($throwout, 2);
					socket_close($throwout);
					logThis("$time: excess client request\n");
					break;
				}
			}
		}
		if ($clientMode) {
			$broadcastMessage = fread(STDIN, 255);
			if (strlen($broadcastMessage) > 0) {
				$broadcastMessage = substr($broadcastMessage, 0, -1);
				$output = $broadcastMessage.$eolstring;
				foreach ($clients as $temp) {
					socket_write($temp['sock'],$output);
				}
				if ($verbose) print ("Message from server:".$output);
			}
		}
		//DEBUG: list the array of clients
		//print_r($clients);
		// If a client is trying to write - handle it now
		for ($i = 0; $i < $max_clients; $i++) { // for each client
			if (in_array(@$clients[$i]['sock'] , $read)) {
				$input = socket_read($clients[$i]['sock'] , 1024);
				socket_getpeername($clients[$i]['sock'], $sockAddress);
				$sockAddress = trim($sockAddress);
				$input = trim($input);
				if ($input == null) {
					$temp = "$time: client disconnect: $sockAddress\n";
					logThis($temp);
					print $temp;
					socket_close($clients[$i]['sock']);
					removeArrayElement($read, ($i+1));
					removeArrayElement($clients, $i);
				}
				
				if ($input == '!halt!') { // requested server shutdown
					foreach ($clients as $temp) {
						socket_shutdown($temp['sock'],2);
						socket_close($temp['sock']);
					}
					$test = socket_shutdown($sock, 2);
					$test = socket_close($sock);
					$temp = "$time: Shutdown from ".$sockAddress.", simplesocket closed\n";
					logThis($temp);
					die ($temp);
				} elseif ($input) {
					$output = $input.$eolstring;
					foreach ($clients as $temp) {
						socket_write($temp['sock'],$output);
					}
					if ($verbose) print ("Message from ".$sockAddress.":".$output);
				}
			}
		}
	} // end while
}

main();
?>
