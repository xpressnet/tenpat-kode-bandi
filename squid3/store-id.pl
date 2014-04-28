#!/usr/bin/perl
# ISI DARI STOREURL DIBAWAH INI GADO GADO.
# ADA YG DARI CHUDY DAN ADA YG DARI SHUDY
# SHUDYLAH BERBAGI ILMU :3
# ucok_karnadi(at)yahoo.com or https://twitter.com/syaifuddin_jw
$|=1;
while (<>) {
    @X = split;
       $x = $X[0] . " ";
       $_ = $X[1];
       $u = $X[1];

#==============================================================================================
#facebook
#==============================================================================================
if (m/^http(|s):\/\/photos-[a-z](\.ak\.fbcdn\.net)(\/.*\/)(.*\.(png|gif|jpg|mp4|js|css))/) {
		print $X[0] . " OK store-id=storeurl://photos" . $1 . "/" . $2 . $3  . "\n";

} elsif (m/^http(|s)\:\/\/fbstatic[a-zA-Z0-9]\-\.net\/rsrc\.php\/(.*)/) {
        print $X[0] . " OK store-id=storeurl://fbcdn.SQUIDINTERNAL/" . $1  . "\n";

} elsif (m/^http(|s):\/\/[a-z][0-9]\.sphotos\.ak\.fbcdn\.net\/(.*)\/(.*)/) {
		print $X[0] . " OK store-id=storeurl://photos.ak.fbcdn.net/" . $1  ."/". $2 . "\n";

} elsif (m/^http(|s):\/\/video\.(.*)\.fbcdn*\.net\/(.*?)\/([0-9_]+\.(mp4|flv|avi|mkv|m4v|mov|wmv|3gp|mpg|mpeg)?)(.*)/) {
		print $X[0] . " OK store-id=storeurl://video.ak.fbcdn.net.SQUIDINTERNAL/" . $3  . "";

} elsif (m/^http(|s)\:\/\/fbcdn\.net(\/(profile|photos|sphotos)-ak-)*[0-9]?(.*)/) {
        print $X[0] . " OK store-id=storeurl://facebook.SQUIDINTERNAL" . $2  . "fb" .  $5  . "\n";

} elsif (m/^http(|s)\:\/\/fbcdn[a-zA-Z0-9\-\_\.\%]*net\/safe\_image\.php\?(.*)/) {
        print $X[0] . " OK store-id=storeurl://fbcdn.SQUIDINTERNAL/" . $1  . "\n";

} elsif (m/^http(|s)\:\/\/fbcdn[a-zA-Z0-9\-\_\.\%]*net\/rsrc\.php\/(.*)/) {
        print $X[0] . " OK store-id=storeurl://fbcdn.SQUIDINTERNAL/" . $1  . "\n";

} elsif (m/^http(|s)\:\/\/fbcdn[a-zA-Z0-9\-\_\.\%]*net\/[a-zA-Z0-9\-\_\.\%]*\/(.*)/) {
        print $X[0] . " OK store-id=storeurl://fbcdn.SQUIDINTERNAL/" . $1  . "\n";

} elsif (m/^http(|s)\:\/\/fbcdn\.net(\/(profile|photos|sphotos)-ak-)*[0-9]?(.*)/) {
        print $X[0] . " OK store-id=storeurl://facebook.SQUIDINTERNAL" . $2  . "fb" .  $5  . "\n";

#==============================================================================================
# Fix Youtube With Referer LOG
#==============================================================================================
} elsif ($X[1] =~ m/^http\:\/\/.*(youtube|google).*videoplayback.*/){
		@itag = m/[&?](itag=[0-9]*)/;
		@CPN = m/[&?]cpn\=([a-zA-Z0-9\-\_]*)/;
		@IDS = m/[&?]id\=([a-zA-Z0-9\-\_]*)/;
		$id = &GetID($CPN[0], $IDS[0]);
		@range = m/[&?](range=[^\&\s]*)/;
		print $X[0] . " OK store-id=http://fathayu.SQUIDINTERNAL/" . $id . "&@itag@range\n";
		
} elsif ($X[1] =~ m/(youtube|google).*videoplayback\?/ ){
		@itag = m/[&?](itag=[0-9]*)/;
		@id = m/[&?](id=[^\&]*)/;
		@redirect = m/[&?](redirect_counter=[^\&]*)/;
		print $X[0] . " OK store-id=http://fathayu.SQUIDINTERNAL/";

		#Speedtest
} elsif (m/^http:\/\/(.*)\/speedtest\/(.*\.(jpg|txt|gif|php|png))\?(.*)/) {
		print $X[0] . " OK store-id=http://www.speedtest.net.SQUIDINTERNAL/speedtest/" . $1 . "";

        #reverbnation
} elsif (m/^http:\/\/[a-z0-9]{4}\.reverbnation\.com\/.*\/([0-9]*).*/) {
        print $X[0] . " OK store-id=http://reverbnation.com.SQUIDINTERNAL/" . $1 . "\n";

        #BLOGSPOT
} elsif (m/^http:\/\/[1-4].bp.(blogspot.com.*)/) {
        print $X[0] . " OK store-id=http://blog-cdn." . $1  . "\n";

        #ytimg
} elsif (m/^http:\/\/i[1-4]\.ytimg\.com(.*)/) {
        print $X[0] . " OK store-id=http://cdn.ytimg.com" . $1  . "\n";

        #AVAST
} elsif (m/^http:\/\/download[0-9]{3}.(avast.com.*)/) {
        print $X[0] . " OK store-id=http://avast-cdn." . $1  .  "\n";

        #AVAST
} elsif (m/^http:\/\/[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\/(iavs.*)/) {
        print $X[0] . " OK store-id=http://avast-cdn.avast.com/" . $1  .  "\n";

        #KAV
} elsif (m/^http:\/\/dnl-[0-9]{2}.(geo.kaspersky.com.*)/) {
        print $X[0] . " OK store-id=http://kav-cdn." . $1  .  "\n";

        #AVG
} elsif (m/^http:\/\/update.avg.com/) {
        print $X[0] . " OK store-id=http://avg-cdn." . $1  .  "\n";

        #maps.google.com
} elsif (m/^http:\/\/(cbk|mt|khm|mlt|tbn)[0-9]?(.google\.co(m|\.uk|\.id).*)/) {
        print $X[0] . " OK store-id=http://" . $1  . $2 . "\n";

        #gstatic and/or wikimapia
} elsif (m/^http:\/\/([a-z])[0-9]?(\.gstatic\.com.*|\.wikimapia\.org.*)/) {
        print $X[0] . " OK store-id=http://" . $1  . $2 . "\n";

        #maps.google.com
} elsif (m/^http:\/\/(khm|mt)[0-9]?(.google.com.*)/) {
        print $X[0] . " OK store-id=http://" . $1  . $2 . "\n";
		
} elsif (m/^http:\/\/([0-9.]{4}|.*\.youtube\.com|.*\.googlevideo\.com|.*\.video\.google\.com).*?(videoplayback\?id=.*?|video_id=.*?)\&(.*?)/) {
   $z = $2; $z =~ s/video_id=/get_video?video_id=/;
   print $X[0] . " OK store-id=http://video-srv.youtube.com.SQUIDINTERNAL/" . $z . "\n";

        #Google
} elsif (m/^http:\/\/www\.google-analytics\.com\/__utm\.gif\?.*/) {
        print $X[0] . " OK store-id=http://www.google-analytics.com/__utm.gif\n";

        #Cache High Latency Ads
} elsif (m/^http:\/\/([a-z0-9.]*)(\.doubleclick\.net|\.quantserve\.com|\.googlesyndication\.com|yieldmanager|cpxinteractive)(.*)/) {
        $y = $3;$z = $2;
        for ($y) {
        s/pixel;.*/pixel/;
        s/activity;.*/activity/;
        s/(imgad[^&]*).*/\1/;
        s/;ord=[?0-9]*//;
        s/;&timestamp=[0-9]*//;
        s/[&?]correlator=[0-9]*//;
        s/&cookie=[^&]*//;
        s/&ga_hid=[^&]*//;
        s/&ga_vid=[^&]*//;
        s/&ga_sid=[^&]*//;
        # s/&prev_slotnames=[^&]*//
        # s/&u_his=[^&]*//;
        s/&dt=[^&]*//;
        s/&dtd=[^&]*//;
        s/&lmt=[^&]*//;
        s/(&alternate_ad_url=http%3A%2F%2F[^(%2F)]*)[^&]*/\1/;
        s/(&url=http%3A%2F%2F[^(%2F)]*)[^&]*/\1/;
        s/(&ref=http%3A%2F%2F[^(%2F)]*)[^&]*/\1/;
        s/(&cookie=http%3A%2F%2F[^(%2F)]*)[^&]*/\1/;
        s/[;&?]ord=[?0-9]*//;
        s/[;&]mpvid=[^&;]*//;
        s/&xpc=[^&]*//;
        # yieldmanager
        s/\?clickTag=[^&]*//;
        s/&u=[^&]*//;
        s/&slotname=[^&]*//;
        s/&page_slots=[^&]*//;
        }
        print $X[0] . " OK store-id=http://" . $1 . $2 . $y . "\n";

                        #cache high latency ads
} elsif (m/^http:\/\/(.*?)\/(ads)\?(.*?)/) {
        print $X[0] . " OK store-id=http://" . $1 . "/" . $2  . "\n";

} elsif (m/^http:\/\/(www\.ziddu\.com.*\.[^\/]{3,4})\/(.*?)/) {
        print $X[0] . " OK store-id=http://" . $1 . "\n";

                        #cdn, varialble 1st path
} elsif (($X[1] =~ /filehippo/) && (m/^http:\/\/(.*?)\.(.*?)\/(.*?)\/(.*)\.([a-z0-9]{3,4})(\?.*)?/)) {
        @y = ($1,$2,$4,$5);
        $y[0] =~ s/[a-z0-9]{2,5}/cdn./;
        print $X[0] . " OK store-id=http://" . $y[0] . $y[1] . "/" . $y[2] . "." . $y[3] . "\n";

                        #rapidshare
} elsif (($X[1] =~ /rapidshare/) && (m/^http:\/\/(([A-Za-z]+[0-9-.]+)*?)([a-z]*\.[^\/]{3}\/[a-z]*\/[0-9]*)\/(.*?)\/([^\/\?\&]{4,})$/)) {
        print $X[0] . " OK store-id=http://cdn." . $3 . "/SQUIDINTERNAL/" . $5 . "\n";

} elsif (($X[1] =~ /maxporn/) && (m/^http:\/\/([^\/]*?)\/(.*?)\/([^\/]*?)(\?.*)?$/)) {
        print $X[0] . " OK store-id=http://" . $1 . "/SQUIDINTERNAL/" . $3 . "\n";
       
                        #domain/path/.*/path/filename
} elsif (($X[1] =~ /fucktube/) && (m/^http:\/\/(.*?)(\.[^\.\-]*?[^\/]*\/[^\/]*)\/(.*)\/([^\/]*)\/([^\/\?\&]*)\.([^\/\?\&]{3,4})(\?.*?)$/)) {
        @y = ($1,$2,$4,$5,$6);
        $y[0] =~ s/(([a-zA-A]+[0-9]+(-[a-zA-Z])?$)|([^\.]*cdn[^\.]*)|([^\.]*cache[^\.]*))/cdn/;
        print $X[0] . " OK store-id=http://" . $y[0] . $y[1] . "/" . $y[2] . "/" . $y[3] . "." . $y[4] . "\n";

                        #like porn hub variables url and center part of the path, filename etention 3 or 4 with or without ? at the end
} elsif (($X[1] =~ /tube8|pornhub|xvideos/) && (m/^http:\/\/(([A-Za-z]+[0-9-.]+)*?(\.[a-z]*)?)\.([a-z]*[0-9]?\.[^\/]{3}\/[a-z]*)(.*?)((\/[a-z]*)?(\/[^\/]*){4}\.[^\/\?]{3,4})(\?.*)?$/)) {
        print $X[0] . " OK store-id=http://cdn." . $4 . $6 . "\n";

                        #for yimg.com video
} elsif (m/^http:\/\/(.*yimg.com)\/\/(.*)\/([^\/\?\&]*\/[^\/\?\&]*\.[^\/\?\&]{3,4})(\?.*)?$/) {
        print $X[0] . " OK store-id=http://cdn.yimg.com/" . $3 . "\n";
       
                        #for yimg.com doubled
} elsif (m/^http:\/\/(.*?)\.yimg\.com\/(.*?)\.yimg\.com\/(.*?)\?(.*)/) {
        print $X[0] . " OK store-id=http://cdn.yimg.com/"  . $3 . "\n";

                        #for yimg.com with &sig=
} elsif (m/^http:\/\/([^\.]*)\.yimg\.com\/(.*)/) {
        @y = ($1,$2);
        $y[0] =~ s/[a-z]+([0-9]+)?/cdn/;
        $y[1] =~ s/&sig=.*//;
        print $X[0] . " OK store-id=http://" . $y[0] . ".yimg.com/"  . $y[1] . "\n";
                       
                        #youjizz. We use only domain and filename
} elsif (($X[1] =~ /media[0-9]{1,5}\.youjizz/) && (m/^http:\/\/(.*?)(\.[^\.\-]*?\.[^\/]*)\/(.*)\/([^\/\?\&]*)\.([^\/\?\&]{3,4})(\?.*?)$/)) {
        @y = ($1,$2,$4,$5);
        $y[0] =~ s/(([a-zA-A]+[0-9]+(-[a-zA-Z])?$)|([^\.]*cdn[^\.]*)|([^\.]*cache[^\.]*))/cdn/;
        print $X[0] . " OK store-id=http://" . $y[0] . $y[1] . "/" . $y[2] . "." . $y[3] . "\n";

                        #general purpose for cdn servers. add above your specific servers.
} elsif (m/^http:\/\/([0-9.]*?)\/\/(.*?)\.(.*)\?(.*?)/) {
        print $X[0] . " OK store-id=http://squid-cdn-url/" . $2  . "." . $3 . "\n";

                        # spicific extention
} elsif (m/^http:\/\/(.*?)\.(jp(e?g|e|2)|gif|png|tiff?|bmp|ico|flv|wmv|3gp|mp(4|3)|exe|msi|zip|on2|mar|swf|pak|iop|nzp|kom).*?/) {
        @y = ($1,$2);
        $y[0] =~ s/((cache|cdn)[-\d]*)|([a-zA-A]+-?[0-9]+(-[a-zA-Z]*)?)/cdn/;
        print $X[0] . " OK store-id=http://" . $y[0] . "." . $y[1] . "\n";

                        #generic http://variable.domain.com/path/filename."ex", "ext" or "exte"
                        #http://cdn1-28.projectplaylist.com
                        #http://s1sdlod041.bcst.cdn.s1s.yimg.com
} elsif (m/^http:\/\/(.*?)(\.[^\.\-]*?\..*?)\/([^\?\&\=]*)\.([\w\d]{2,4})\??.*$/) {
        @y = ($1,$2,$3,$4);
        $y[0] =~ s/([a-z][0-9][a-z]dlod[\d]{3})|((cache|cdn)[-\d]*)|([a-zA-A]+-?[0-9]+(-[a-zA-Z]*)?)/cdn/;
        print $X[0] . " OK store-id=storeurl://" . $y[0] . $y[1] . "/" . $y[2] . "." . $y[3] . "\n";

		# all that ends with ;
} elsif (m/^http:\/\/(.*?)\/(.*?)\;(.*)/) {
        print $X[0] . " OK store-id=http://" . $1 . "/" . $2  . "\n";

} else {
        print $X[0] . $_ . $X[1] . "OK store-id=sucks\n";
	}
}

sub GetID
{
$id = "";
use File::ReadBackwards;
my $lim = 200 ;
my $ref_log = File::ReadBackwards->new('/var/log/squid3/referer.log');
while (defined($line = $ref_log->readline))
{
if ($line =~ m/.*youtube.*\/watch\?.*v=([a-zA-Z0-9\-\_]*).*\s.*id=$IDS[0].*/){
$id = $1;
last;
}
if ($line =~ m/.*youtube.*\/.*cpn=$CPN[0].*[&](video_id|docid|v)=([a-zA-Z0-9\-\_]*).*/){
$id = $2;
last;
}
if ($line =~ m/.*youtube.*\/.*[&?](video_id|docid|v)=([a-zA-Z0-9\-\_]*).*cpn=$CPN[0].*/){
$id = $2;
last;
}
last if --$lim <= 0;
}
if ($id eq ""){
$id = $IDS[0];
}
$ref_log->close();
return $id;
}
