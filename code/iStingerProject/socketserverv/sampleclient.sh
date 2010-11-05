#!/usr/bin/php -q

<?php
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Socket Server Client Example
// just sends messages out to all the other clients
// Connects to a server running on 127.0.0.1, port 6780
// Written by Richard Shields
// www.rshields.com
// April 2008

print "\nStarting sample client...  run socketserver in verbose mode (./socketserver.sh -v) to see the output of this program.\n\nHit ctrl-c to stop this script.\n";

// Function to get usec of current time as float
function microtime_float() {
	list($usec, $sec) = explode(" ", microtime());
	return ((float)$usec + (float)$sec);
}

// timer for ensuring no excessive load on the machine running the script
$timer = microtime_float();

function makeconnection() {
	global $socket;
	global $timer;
	$myX = 0;
	$myY = 0;
	$xChange = 10;
	$yChange = 10;
	$fp = true;
	while ($fp) {
		$difference = microtime_float() - $timer;
		$delay = 90000 - (1000000*$difference);
		// be kind to processors... usleep pauses execution of this client
		usleep($delay);
		// and then get the current time for the next loop
		$timer = microtime_float();
		// generate some new values to broadcast
		// the example here sends an array of values separated by commas
		// the values are changing x and y positions for a 1024 by 768 screen
		$myX+=$xChange;
		$myY+=$yChange;
		if ($myX>1024) $xChange = -5 - (rand()%5);
		if ($myX<0) $xChange = 5 + (rand()%5);
		if ($myY>768) $yChange = -5 - (rand()%5);
		if ($myY<0) $yChange = 5 + (rand()%5);
		// make the message...
		$temp = "$myX,$myY";
		// and send the message out
		fputs($socket, $temp);
	}
}

$socket = fsockopen("127.0.0.1", 6780, $errno, $errstr);
stream_set_blocking($socket, false);
if (!$socket) {
	echo "$errstr ($errno)\r\n";
}
while (true) {
	makeconnection();
	sleep (10);
}
?>
