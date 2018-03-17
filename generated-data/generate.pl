use POSIX 'strftime';

$minlat = 51.51043;
$maxlat = 51.59860;

$minlng = 0.0652986;
$maxlng = 0.1923890;

$minweather = 1;
$maxweather = 5;

$minepochsecs = 1521305427 - 60*60*24*61;
$maxepochsecs = 1521305427;

$maxitr = 2000;
$msg = "{\n";
	
for ($i = 0; $i < $maxitr; $i++)
{
	$lat = $minlat + rand() * ($maxlat - $minlat);
	$lng = $minlng + rand() * ($maxlng - $minlng);
	$weather = 1 + int (1000 * rand()) % 5;

	$epoch = int ($minepochsecs + rand() * ($maxepochsecs - $minepochsecs));
	$epochms = 100*$epoch + int(1000*rand());
	my $date = strftime '%a %b %d %Y %H:%M:%S GMT+0000 (GMT)', localtime $epoch;



	$msg .= "\t\"import" . $i . "\": {\n";
	$msg .= "\t\t\"comment\": \"demo" . $i . "\",\n"; 
	$msg .= "\t\t\"date\": \"" . $date . "\",\n";
	$msg .= "\t\t\"epoch\": " . $epochms . ",\n";
	$msg .= "\t\t\"lat\": " . $lat . ",\n";
	$msg .= "\t\t\"lng\": " . $lng . ",\n";
	$msg .= "\t\t\"weather\": \"". $weather . "\"\n";
	
	if ($i == $maxitr - 1)
	{
		$msg .= "\t}\n";
	}
	else
	{
		$msg .= "\t},\n";
	}
}
$msg .= "}\n";

print $msg;
