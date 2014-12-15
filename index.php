<?php
	$ip = "192.168.1.28";
	$base = "http://$ip";
	$urls = array(
		'TV GUI' => "${base}:8081",
		'Movie GUI' => "${base}:5050",
		'Music GUI' => "${base}:8181",
		'Torrent GUI' => "${base}:9091",
		'Remote Control' => "${base}:8080",
		'Program Status' => "${base}:2812",
		'Start Downloads' => "?run=start",
		'Alternative Download Speed' => "?run=alt",
		'Stop Downloads' => "?run=stop"
	);

	$cmd_output = "";
	$cmd_dir = "/home/blondebeard/Binaries";
	if($_GET['run']) {
		$run = $_GET['run'];
		if($run == 'start') {
			$cmd_output = shell_exec("$cmd_dir/start_download.sh 2>&1");
		} else if($run == 'alt') {
			$cmd_output = shell_exec("$cmd_dir/alternative_download_speed.sh 2>&1");
		} else if($run == 'stop') {
			$cmd_output = shell_exec("$cmd_dir/stop_download.sh 2>&1");
		}
	}
?>
<html>
<head>
	<title>BlondeBeard</title>
</head>
<body>
<h1>BlondeBeard Links</h1>
<?php
if($cmd_output) {
	$cmd_output = nl2br($cmd_output);	
	echo "<p>$cmd_output</p>";
}
?>
<ul>
<?php 
foreach ($urls as $name => $url) {
	echo "<li><a href=\"$url\">$name</a></li>";
} 
?>
</ul>
</body>
</html>
