#!/usr/bin/php
<?php

# statusboard.php by Allister Jenks is licensed under a Creative Commons
# Attribution 3.0 Unported License. For details see
# http://creativecommons.org/licenses/by/3.0/deed.en_US
#
# THIS SOFTWARE IS PROVIDED BY ALLISTER JENKS T/A MACTHOUGHTS.NET 'AS IS' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL ALLISTER JENKS T/A MACTHOUGHTS.NET OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.


# The graph title
$title = "Traffic";

# The number of days history to retrieve
$days = 30;

# List of sites to process, including site title, stats ID and temporary file name to use
$sites = array(
         "michaelgalloy.com" => array(
              "blogid"   => "1075177",
              "file"     => "/Users/mgalloy/data/michaelgalloy.csv",
              "color"    => "Orange"
              )
         );

# Control whether color is specified
$usecolor = true;

# Control whether totals are displayed
$usetotals = true;

# WordPress.com API key
$apikey = "2d23bddda208";

# Final stats file for StatusBoard to read
$finalfile = "/Users/mgalloy/data/sitestats.csv";

# -------------------------------------------------

date_default_timezone_set('America/Denver');
  
# Build the results array with zero values (because zero values are not returned in the CSV files)
$date = time() - $days * 24 * 60 * 60;
for ($i = 1; $i <= $days; $i++) {
  foreach ($sites as $site => $siteparms) {
    $datestring = date("Y-m-d", $date);
    $results[$datestring][$site] = 0;
  }
  $date += 24 * 60 * 60;
 }

  # Cycle through each of the required sites
  foreach ($sites as $site => $siteparms) {

    # Create or open the site's temporary file
    $outfile = fopen($siteparms["file"], "w");

    # Set up the URL request to retrieve the stats
    $adjdays = $days+1; // Needed to actually get the right number of days from the stats.
    $blogurl = "http://stats.wordpress.com/csv.php?api_key=".$apikey."&blog_id=".$siteparms["blogid"]."&table=views&days=".$adjdays."&limit=-1&format=csv";
    $stats = curl_init($blogurl);

    # Fetch the stats to the file and close it
    curl_setopt($stats, CURLOPT_FILE, $outfile);
    curl_exec($stats);
    curl_close($stats);
    fclose($outfile);

    # Reopen the file for read only
    $outfile = fopen($siteparms["file"], "r");

    # Parse the data into the results array
    $current_line = fgets($outfile);
    while (!feof($outfile)) {
    # Pull out and clean up the values
    $current_line=trim($current_line);
    $values = explode(",",$current_line);
    $values[0]=trim($values[0],"\" ");
    $values[1]=trim($values[1],"\" ");
    if ($values[0] != "date") {
      if (array_key_exists($values[0],$results)) {
        $results[$values[0]][$site]=$values[1];
      }
    }
    $current_line = fgets($outfile);
  }
  fclose($outfile);
}

# Open the final file for output
$outfile = fopen($finalfile, "w");

# Build and write the headings
$current_line = "\"".$title."\"";
foreach ($sites as $site => $siteparms) {
  $current_line.=",\"".$site."\"";
}
$current_line.="\n";
fwrite($outfile,$current_line);

# Build and write a line for each date
foreach ($results as $result => $sitevalues) {
  $current_line="\"".$result."\"";
  foreach ($sites as $site => $siteparms) {
    $current_line.=",".$sitevalues[$site];
  }
  $current_line.="\n";
  fwrite($outfile,$current_line);
}

# Build and write the colors if required
if ($usecolor) {
  $current_line = "\"Colors\"";
  foreach ($sites as $site => $siteparms) {
    $current_line.=",\"".$siteparms["color"]."\"";
  }
  $current_line.="\n";
  fwrite($outfile, $current_line);
}

# Build and write the totals line if required
if ($usetotals) {
  $current_line = "\"Totals\"";
  $current_line.="\n";
  fwrite($outfile,$current_line);
}

# Close off the file. We're done!
fclose($outfile);

?>
