!/usr/bin/perl
# This script is NOT written or modified by me, I only copy pasted it from the internet.
# It was First originally Written by chudy_fernandez@yahoo.com
# &amp; Have been modified by various persons over the net to fix/add various functions.
# Like For Example modified by member of comstuff.net to satisfy common and dynamic content.
# th30nly @comstuff.net a.k.a invisible_theater , and possibly other people too.
# For more info, http://wiki.squid-cache.org/ConfigExamples/DynamicContent/YouTube
# Syed Jahanzaib / aacable@hotmail.com
# http://aacable.wordpress.com/2012/01/19/youtube-caching-with-squid-2-7-using-storeurl-pl/
#####################
#### REFERENCES #####  http://www2.fh-lausitz.de/launic/comp/misc/squid/projekt_youtube/
#####################
#####################
 
#!/usr/bin/perl
## storeurl.pl-130411-0.05
## s. 130411.howto.squid.youtube.html
## CHANGES
## 130411 hl+mf
## - fix youtube loop redir
## - rel. 0.05
## 130409 hl
## - add usleep
## 120726 hl
## - add printtimenow
## 120725 hl
## - remove html-tags
## - add debug
## - disable unused rules
## - rel. 0.04
## 120130 aacable
## - fix match variable.domain.com
##   http://aacable.wordpress.com/2012/01/30/youtube-caching-problem-an-error-occured-please-try-again-later-solved/
## 120111 aacable
##   http://aacable.wordpress.com/2012/01/11/howto-cache-youtube-with-squid-lusca-and-bypass-cached-videos-from-mikrotik-queue/
#
#### notes
## - config (s. 130411.howto.squid.youtube.html)
##   squid.conf:storeurl_rewrite_program /etc/squid/storeurl.pl
## - test
##   $ cat squid.diag.youtube.url | awk '{print "0",$7,"10.0.0.1/- - GET - myip=10.0.0.2 myport=3128"}' | ./storeurl.pl
 
#### var
use IO::File;
$|=1;
STDOUT->autoflush(1);
$debug=1;        ## recommended:0
$bypassallrules=0;    ## recommended:0
$sucks="";        ## unused
$sucks="sucks" if ($debug>=1);
$timenow="";
$printtimenow=1;      ## print timenow: 0|1
my $logfile = '/tmp/storeurl.log';
 
open my $logfh, '>>', $logfile
or die "Couldn't open $logfile for appending: $!\n" if $debug;
$logfh->autoflush(1) if $debug;
 
#### main
## in : 0 http://server/path?var 192.168.5.10/- - GET - myip=192.168.1.224 myport=3128
while (<>) {
$timenow=time()." " if ($printtimenow);
print $logfh "$timenow"."in : $_" if ($debug>=1);
chop; ## strip eol
@X = split;
$x = $X[0]; ## 0
$u = $X[1]; ## url
$_ = $u; ## url
 
if ($bypassallrules){
$out="$u";    ## map 1:1
 
#youtube with range (YOUTUBE has split its videos into segments)
}elsif (m/(youtube|google).*videoplayback\?.*range/ ){
@itag = m/[&?](itag=[0-9]*)/;
@id = m/[&?](id=[^\&]*)/;
@range = m/[&?](range=[^\&\s]*)/;
@begin = m/[&?](begin=[^\&\s]*)/;
@redirect = m/[&?](redirect_counter=[^\&]*)/;
$out="http://video-srv.youtube.com.SQUIDINTERNAL/@itag&@id&@range&@redirect";
#sleep(1);    ## delay loop
 
#youtube without range
}elsif (m/(youtube|google).*videoplayback\?/ ){
@itag = m/[&?](itag=[0-9]*)/;
@id = m/[&?](id=[^\&]*)/;
@redirect = m/[&?](redirect_counter=[^\&]*)/;
$out="http://video-srv.youtube.com.SQUIDINTERNAL/@itag&@id&@redirect";
#sleep(1);    ## delay loop
 
#speedtest
}elsif (m/^http:\/\/(.*)\/speedtest\/(.*\.(jpg|txt))\?(.*)/) {
$out="http://www.speedtest.net.SQUIDINTERNAL/speedtest/" . $2 . "";
 
#mediafire
}elsif (m/^http:\/\/199\.91\.15\d\.\d*\/\w{12}\/(\w*)\/(.*)/) {
$out="http://www.mediafire.com.SQUIDINTERNAL/" . $1 ."/" . $2 . "";
 
#fileserve
}elsif (m/^http:\/\/fs\w*\.fileserve\.com\/file\/(\w*)\/[\w-]*\.\/(.*)/) {
$out="http://www.fileserve.com.SQUIDINTERNAL/" . $1 . "./" . $2 . "";
 
#filesonic
}elsif (m/^http:\/\/s[0-9]*\.filesonic\.com\/download\/([0-9]*)\/(.*)/) {
$out="http://www.filesonic.com.SQUIDINTERNAL/" . $1 . "";
 
#4shared
}elsif (m/^http:\/\/[a-zA-Z]{2}\d*\.4shared\.com(:8080|)\/download\/(.*)\/(.*\..*)\?.*/) {
$out="http://www.4shared.com.SQUIDINTERNAL/download/$2\/$3";
 
#4shared preview
}elsif (m/^http:\/\/[a-zA-Z]{2}\d*\.4shared\.com(:8080|)\/img\/(\d*)\/\w*\/dlink__2Fdownload_2F(\w*)_3Ftsid_3D[\w-]*\/preview\.mp3\?sId=\w*/) {
$out="http://www.4shared.com.SQUIDINTERNAL/$2";
 
#photos-X.ak.fbcdn.net where X a-z
}elsif (m/^http:\/\/photos-[a-z](\.ak\.fbcdn\.net)(\/.*\/)(.*\.jpg)/) {
$out="http://photos" . $1 . "/" . $2 . $3  . "";
 
#YX.sphotos.ak.fbcdn.net where X 1-9, Y a-z
} elsif (m/^http:\/\/[a-z][0-9]\.sphotos\.ak\.fbcdn\.net\/(.*)\/(.*)/) {
$out="http://photos.ak.fbcdn.net/" . $1  ."/". $2 . "";
 
#maps.google.com
} elsif (m/^http:\/\/(cbk|mt|khm|mlt|tbn)[0-9]?(.google\.co(m|\.uk|\.id).*)/) {
$out="http://" . $1  . $2 . "";
 
# compatibility for old cached get_video?video_id
} elsif (m/^http:\/\/([0-9.]{4}|.*\.youtube\.com|.*\.googlevideo\.com|.*\.video\.google\.com).*?(videoplayback\?id=.*?|video_id=.*?)\&(.*?)/) {
$z = $2; $z =~ s/video_id=/get_video?video_id=/;
$out="http://video-srv.youtube.com.SQUIDINTERNAL/" . $z . "";
#sleep(1);    ## delay loop
 
} elsif (m/^http:\/\/www\.google-analytics\.com\/__utm\.gif\?.*/) {
$out="http://www.google-analytics.com/__utm.gif";
 
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
$out="http://" . $1 . $2 . $y . "";
 
#cache high latency ads
} elsif (m/^http:\/\/(.*?)\/(ads)\?(.*?)/) {
$out="http://" . $1 . "/" . $2  . "";
 
# spicific servers starts here....
} elsif (m/^http:\/\/(www\.ziddu\.com.*\.[^\/]{3,4})\/(.*?)/) {
$out="http://" . $1 . "";
 
#cdn, varialble 1st path
} elsif (($u =~ /filehippo/) && (m/^http:\/\/(.*?)\.(.*?)\/(.*?)\/(.*)\.([a-z0-9]{3,4})(\?.*)?/)) {
@y = ($1,$2,$4,$5);
$y[0] =~ s/[a-z0-9]{2,5}/cdn./;
$out="http://" . $y[0] . $y[1] . "/" . $y[2] . "." . $y[3] . "";
 
#rapidshare
} elsif (($u =~ /rapidshare/) && (m/^http:\/\/(([A-Za-z]+[0-9-.]+)*?)([a-z]*\.[^\/]{3}\/[a-z]*\/[0-9]*)\/(.*?)\/([^\/\?\&]{4,})$/)) {
$out="http://cdn." . $3 . "/SQUIDINTERNAL/" . $5 . "";
 
} elsif (($u =~ /maxporn/) && (m/^http:\/\/([^\/]*?)\/(.*?)\/([^\/]*?)(\?.*)?$/)) {
$out="http://" . $1 . "/SQUIDINTERNAL/" . $3 . "";
 
#like porn hub variables url and center part of the path, filename etention 3 or 4 with or without ? at the end
} elsif (($u =~ /tube8|pornhub|xvideos/) && (m/^http:\/\/(([A-Za-z]+[0-9-.]+)*?(\.[a-z]*)?)\.([a-z]*[0-9]?\.[^\/]{3}\/[a-z]*)(.*?)((\/[a-z]*)?(\/[^\/]*){4}\.[^\/\?]{3,4})(\?.*)?$/)) {
$out="http://cdn." . $4 . $6 . "";
#...spicific servers end here.
 
#photos-X.ak.fbcdn.net where X a-z
} elsif (m/^http:\/\/photos-[a-z].ak.fbcdn.net\/(.*)/) {
$out="http://photos.ak.fbcdn.net/" . $1  . "";
 
#for yimg.com video
} elsif (m/^http:\/\/(.*yimg.com)\/\/(.*)\/([^\/\?\&]*\/[^\/\?\&]*\.[^\/\?\&]{3,4})(\?.*)?$/) {
$out="http://cdn.yimg.com//" . $3 . "";
 
#for yimg.com doubled
} elsif (m/^http:\/\/(.*?)\.yimg\.com\/(.*?)\.yimg\.com\/(.*?)\?(.*)/) {
$out="http://cdn.yimg.com/"  . $3 . "";
 
#for yimg.com with &sig=
} elsif (m/^http:\/\/(.*?)\.yimg\.com\/(.*)/) {
@y = ($1,$2);
$y[0] =~ s/[a-z]+[0-9]+/cdn/;
$y[1] =~ s/&sig=.*//;
$out="http://" . $y[0] . ".yimg.com/"  . $y[1] . "";
 
#youjizz. We use only domain and filename
} elsif (($u =~ /media[0-9]{2,5}\.youjizz/) && (m/^http:\/\/(.*)(\.[^\.\-]*?\..*?)\/(.*)\/([^\/\?\&]*)\.([^\/\?\&]{3,4})((\?|\%).*)?$/)) {
@y = ($1,$2,$4,$5);
$y[0] =~ s/(([a-zA-A]+[0-9]+(-[a-zA-Z])?$)|(.*cdn.*)|(.*cache.*))/cdn/;
$out="http://" . $y[0] . $y[1] . "/" . $y[2] . "." . $y[3] . "";
 
#general purpose for cdn servers. add above your specific servers.
} elsif (m/^http:\/\/([0-9.]*?)\/\/(.*?)\.(.*)\?(.*?)/) {
$out="http://squid-cdn-url//" . $2  . "." . $3 . "";
 
#generic http://variable.domain.com/path/filename."ex" "ext" or "exte" with or withour "? or %"
} elsif (m/^http:\/\/(.*)(\.[^\.\-]*?\..*?)\/(.*)\.([^\/\?\&]{2,4})((\?|\%).*)?$/) {
@y = ($1,$2,$3,$4);
$y[0] =~ s/(([a-zA-Z]+[0-9]+(-[a-zA-Z])?$)|(.*cdn.*)|(.*cache.*))/cdn/;
$out="http://" . $y[0] . $y[1] . "/" . $y[2] . "." . $y[3] . "";
 
## generic http://variable.domain.com/...
#} elsif (m/^http:\/\/(([A-Za-z]+[0-9-]+)*?|.*cdn.*|.*cache.*)\.(.*?)\.(.*?)\/(.*)$/) {
#$out="http://cdn." . $3 . "." . $4 . "/" . $5 .  "";
 
## spicific extention that ends with ?
#} elsif (m/^http:\/\/(.*?)\/(.*?)\.(jp(e?g|e|2)|gif|png|tiff?|bmp|ico|flv|wmv|3gp|mp(4|3)|exe|msi|zip|on2|mar|rar|cab|amf|swf)(.*)/) {
#$out="http://" . $1 . "/" . $2  . "." . $3 . "";
 
## all that ends with ;
#} elsif (m/^http:\/\/(.*?)\/(.*?)\;(.*)/) {
#$out="http://" . $1 . "/" . $2  . "";
 
} else {
$out="$u"; ##$X[2]="$sucks";
}
print $logfh "$timenow"."out: $x $out $X[2] $X[3] $X[4] $X[5] $X[6] $X[7]\n" if ($debug>=1);
print "$x $out $X[2] $X[3] $X[4] $X[5] $X[6] $X[7]\n";
}
close $logfh if ($debug);