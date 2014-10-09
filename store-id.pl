#!/usr/bin/perl
# $Rev$
#  
###########################################################################################
use IO::File;
$|=1;
STDOUT->autoflush(1);
$debug=0;																     ## recommended:0
$bypassallrules=0;														## recommended:0
$sucks="";																    ## unused
$sucks="sucks" if ($debug>=1);
$timenow="";
$printtimenow=1;  														## print timenow: 0|1
my $logfile = '/tmp/storeid.log';

open my $logfh, '>>', $logfile
    or die "Couldn't open $logfile for appending: $!\n" if $debug;
$logfh->autoflush(1) if $debug;

while (<>) {
$timenow=time()." " if ($printtimenow);
print $logfh "$timenow"."in : $_" if ($debug>=1);
chop; 
my $myURL = $_;
@X = split(" ",$myURL);
$a = $X[0]; 				## channel id
$b = $X[1]; 				## url
$c = $X[2]; 				## ip address
$u = $b; 					 ## url

if ($bypassallrules){
 $out="$u"; 				## map 1:1

# ============================================================= #
# redirector
# ============================================================= #
} elsif ($u=~ m/^https?\:\/\/redirector.c.googlesyndication.com\/videoplayback\/id\/(.*)\/file\/(.*)\/(.*\.flv)/){
    $out="OK store-id=http://video.google.com.squid.internal/redirector/" . $1 . "/" . $3 ;

} elsif ($u=~ m/^https?\:\/\/video.google.com\/ThumbnailServer.*/) {
    @id = m/[&?](contentid=[\w\d\-\.\%]*)/;
    @itag = m/[&?](itag=[\w\d\-\.\%]*)/;
    @set = m/[&?](offsetms=[^\&\s]*)/;
    $out="OK store-id=storeurl://Thumbnail.squid.internal/@id&@itag&@set";

# ============================================================= #
# Facebook
# ============================================================= #
} elsif ($u=~ m/http.*\.(fbcdn|akamaihd)\.net\/h(profile|photos).*[\d\w].*\/([\w]\d+x\d+\/.*\.[\d\w]{3}).*/) {
	  $out="OK store-id=http://fbcdn.net.squid.internal/" . $2 . "/" . $3 ;

} elsif ($u=~ m/^http(.*)static(.*)(akamaihd|fbcdn).net\/rsrc.php\/(.*\/.*\/(.*).(js|css|png|gif))(\?(.*)|$)/) {
	  $out="OK store-id=http://fbcdn.net.squid.internal/static/" . $5 . "." . $6 ;

} elsif ($u=~ m/^https?:\/\/[a-zA-Z0-9\-\_\.\%]*(fbcdn|akamaihd)[a-zA-Z0-9\-\_\.\%]*net\/rsrc\.php\/(.*)/) { 
	  $out="OK store-id=http://cdn.fbcdn/" . $2 ;

} elsif ($u=~ m/^https?\:\/\/.*(profile|photo|creative).*\.ak\.fbcdn\.net\/((h|)(profile|photos)-ak-)(snc|ash|prn)[0-9]?(.*)/) {
    $out="OK store-id=http://fbcdn.net.squid.internal/" . $2  . "fb" .  $6 ;

} elsif ($u=~ m/^https?:\/\/.*(profile|photo|creative)*.akamaihd\.net\/((h|)(profile|photos|ads)-ak-)(snc|ash|prn|frc[0-9])[0-9]?(.*)/) {
    $out="OK store-id=http://fbcdn.net.squid.internal/" . $2  . $5 .  $6 ;

} elsif ($u=~ m/^https?\:\/\/video\.(.*)\.fbcdn\.net\/(.*?)\/([0-9_]+\.(mp4|flv|avi|mkv|m4v|mov|wmv|3gp|mpg|mpeg)?)(.*)/) {
	  $out="OK store-id=http://video.ak.fbcdn.net/" . $1 ;

# ============================================================= #
# Ytimg
# ============================================================= #
} elsif ($u=~ m/^https?\:\/\/i[1-4]\.ytimg\.com\/(.*)/) {
    $out="OK store-id=http://ytimg.com.squid.internal/" . $1 ;

} elsif ($u=~ m/^https?\:\/\/lh[0-9]?.ggpht.com\/(.*?)\/(.*?)\/(.*?)\/(.*)\/(.*)?$/) {
	  $out="OK store-id=http://ggpht.squid.internal/"  . $1 . "/" .  $2 . "/" . $4 .  "/" .  $5 ;
		
# ============================================================= #
# Google Analytics
# ============================================================= #
} elsif ($u=~ m/^https?\:\/\/.*utm.gif.*/) {
	  $out="OK store-id=http://google-analytics.squid.internal/__utm.gif";

# ============================================================= #
# Speedtest
# ============================================================= #
} elsif ($u=~ m/^https?\:\/\/.*\/speedtest\/(.*\.(jpg|txt)).*/) {
	  $out="OK store-id=http://speedtest.squid.internal/" . $1;

# ============================================================= #
# Video MP4,3GP,FLV
# ============================================================= #
} elsif ($u=~ m/^https?\:\/\/.*\/(.*\..*(mp4|3gp|flv))\?.*/) {
	  $out="OK store-id=http://video-file.squid.internal/" . $1;

# ============================================================= #
# Radiobutton
# ============================================================= #
} elsif ($u=~ m/^https?\:\/\/c2lo\.reverbnation\.com\/audio_player\/ec_stream_song\/(.*)\?.*/) {
	  $out="OK store-id=http://reverbnation.squid.internal/" . $1;

# ============================================================= #
# Fileserve
# ============================================================= #
} elsif ($u=~ m/^http:\/\/fs\w*\.fileserve\.com\/file\/(\w*)\/[\w-]*\.\/(.*)/) {
    $out="OK store-id=http://www.fileserve.com.squid.internal/" . $1 . "./" . $2 ;

# ============================================================= #
# youku
# ============================================================= #
} elsif ($u=~ m/^http\:\/\/.*\/youku\/(.*)\/(.*\.flv)/){
   $out="OK store-id=http://video.youku.com.squid.internal/youku/" . $2 ;

# ============================================================= #
# daily motion
# ============================================================= #
} elsif ($u=~ m/^http\:\/\/vid2.ak.dmcdn.net\/(.*)\/(.*)\/video\/(.*)\/(.*\.flv)/){
    $out="OK store-id=http://video.dailymotin.com.squid.internal/dailymotion/" . $2 . "/" . $4 ; 
        
# ============================================================= #
# Sourcefrog
# ============================================================= #
} elsif ($u=~ m/^http:\/\/.*\.dl\.sourceforge\.net\/(.*)/) {
    $out="OK store-id=http://dl.sourceforge.net.squid.internal/" . $1 ;

# ========================================== #
# Mediafire
# ========================================== #
} elsif ($u=~ m/^https?\:\/\/199\.91\.15\d\.\d*\/\w{12}\/(\w*)\/(.*)/) {#
     $out="OK store-id=http://www.mediafire.com.squid.internal/" . $1 ."/" . $2 ;

# ========================================== #
# Filesonic
# ========================================== #
} elsif ($u=~ m/^http\:\/\/s[0-9]*\.filesonic\.com\/download\/([0-9]*)\/(.*)/) {
    $out="OK store-id=http://www.filesonic.com.squid.internal/" . $1 ;
        
# ========================================== #
# 4shared
# ========================================== #
} elsif ($u=~ m/^http\:\/\/[a-zA-Z]{2}\d*\.4shared\.com(:8080|)\/download\/(.*)\/(.*\..*)\?.*/) {
	  $out="OK store-id=http://www.4shared.com.squid.internal/download/$2\/$3";

} elsif ($u=~ m/^http\:\/\/[a-zA-Z]{2}\d*\.4shared\.com(:8080|)\/img\/(\d*)\/\w*\/dlink__2Fdownload_2F(\w*)_3Ftsid_3D[\w-]*\/preview\.mp3\?sId=\w*/) {
	  $out="OK store-id=http://www.4shared.com.squid.internal/$2";

} elsif (($u =~ /4shared/) && (m/^http:\/\/(.*?)\.(.*?)\/(.*?)\/(dlink__2Fdownload_2F([^\/-]+))([a-zA-Z0-9-]+)\/([^\/\?\&]*\.[^\/\?\&]{2,3})(\?.*)?$/)) {
	  @y = ($1,$2,$3,$4,$7);
	  $y[0] =~ s/[a-z]+([0-9]+)?/cdn./;
	  $out="OK store-id=http://" . $y[0] . $y[1] . "/" . $y[2] . "/" . $y[3] . "/" . $y[4] ;

# ============================================================= #
# Maps.Google.com
# ============================================================= #
} elsif ($u=~ m/^https?\:\/\/(cbk|mt|khm|mlt|tbn)[0-9]?(.google\.co(m|\.uk|\.id).*)/) {
    $out="OK store-id=http://" . $1  . $2 ;

# ============================================================= #
# gstatic and/or wikimapia
# ============================================================= #
} elsif ($u=~ m/^http:\/\/([a-z])[0-9]?(\.gstatic\.com.*|\.wikimapia\.org.*)/) {
    $out="OK store-id=http://" . $1  . $2 ;
		
# ============================================================= #
# Google Play Store
# ============================================================= #
} elsif ($u=~ m/^https?\:\/\/.*\.c\.android\.clients\.google\.com\/market\/GetBinary\/GetBinary\/(.*\/.*)\?.*/) {
	  $out="OK store-id=http://playstore-android.squid.internal/" . $1;

# ============================================================= #
# Youtube Video
# ============================================================= #
} elsif ($u=~ m/^https?\:\/\/.*youtube.*ptracking.*/){
	@video_id = m/[&?]video_id\=([^\&\s]*)/;
	@cpn = m/[&?]cpn\=([^\&\s]*)/;
	unless (-e "/tmp/@cpn"){
	open FILE, ">/tmp/@cpn";
	print FILE "@video_id";
	close FILE;
	}
	$out="ERR";
 
} elsif ($u=~ m/^https?\:\/\/.*youtube.*stream_204.*/){
	@docid = m/[&?]docid\=([^\&\s]*)/;
	@cpn = m/[&?]cpn\=([^\&\s]*)/;
	unless (-e "/tmp/@cpn"){
	open FILE, ">/tmp/@cpn";
	print FILE "@docid";
	close FILE;
	}
	$out="ERR";
 
} elsif ($u=~ m/^https?\:\/\/.*youtube.*player_204.*/){
	@v = m/[&?]v\=([^\&\s]*)/;
	@cpn = m/[&?]cpn\=([^\&\s]*)/;
	unless (-e "/tmp/@cpn"){
	open FILE, ">/tmp/@cpn";
	print FILE "@v";
	close FILE;
	}
	$out="ERR";
	
} elsif ($u=~ m/^https?\:\/\/.*youtube.*watchtime.*/){
	@v = m/[&?]v\=([^\&\s]*)/;
	@cpn = m/[&?]cpn\=([^\&\s]*)/;
	unless (-e "/tmp/@cpn"){
	open FILE, ">/tmp/@cpn";
	print FILE "@v";
	close FILE;
	}
	$out="ERR";

} elsif ($u=~ m/^https?\:\/\/.*youtube.*set_awesome.*/){
	@v = m/[&?]v\=([^\&\s]*)/;
	@cpn = m/[&?]cpn\=([^\&\s]*)/;
	unless (-e "/tmp/@cpn"){
	open FILE, ">/tmp/@cpn";
	print FILE "@v";
	close FILE;
	}
	$out="ERR";

} elsif ($u=~ m/^https?\:\/\/.*(youtube|googlevideo).*videoplayback.*/){
	@itag = m/[&?](itag\=[0-9]*)/;
	@range = m/[&?](range\=[^\&\s]*)/;
	@cpn = m/[&?]cpn\=([^\&\s]*)/;
	@mime = m/[&?](mime\=[^\&\s]*)/;
	@id = m/[&?]id\=([^\&\s]*)/;
 
	if (defined(@cpn[0])){
		if (-e "/tmp/@cpn"){
		open FILE, "/tmp/@cpn";
		@id = <FILE>;
		close FILE;}
	}
	$out="OK store-id=http://video-srv.squid.internal/id=@id@mime@range";

# ============================================================= #
# Cache High Latency Ads
# ============================================================= #
} elsif ($u=~ m/^https?\:\/\/([a-z0-9.]*)(\.doubleclick\.net|\.quantserve\.com|\.googlesyndication\.com|yieldmanager|cpxinteractive)(.*)/) {
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
    s/\?clickTag=[^&]*//;
    s/&u=[^&]*//;
    s/&slotname=[^&]*//;
    s/&page_slots=[^&]*//;
    }
    $out="OK store-id=http://" . $1 . $2 . $y ;

# ============================================================= #
# Ziddu
# ============================================================= #
} elsif ($u=~ m/^http:\/\/(www\.ziddu\.com.*\.[^\/]{3,4})\/(.*?)/) {
    $out="OK store-id=http://" . $1 ;

# ============================================================= #
# cdn, varialble 1st path
# ============================================================= #
} elsif ((/filehippo/) && (m/^http:\/\/(.*?)\.(.*?)\/(.*?)\/(.*)\.([a-z0-9]{3,4})(\?.*)?/)) {
    @y = ($1,$2,$4,$5);
    $y[0] =~ s/[a-z0-9]{2,5}/cdn./;
    $out="OK store-id=http://" . $y[0] . $y[1] . "/" . $y[2] . "." . $y[3] ;

# ============================================================= #
# Rapidshare
# ============================================================= #
} elsif ((/rapidshare/) && (m/^http:\/\/(([A-Za-z]+[0-9-.]+)*?)([a-z]*\.[^\/]{3}\/[a-z]*\/[0-9]*)\/(.*?)\/([^\/\?\&]{4,})$/)) {
    $out="OK store-id=http://cdn." . $3 . "/squid.internal/" . $5 ;

# ============================================================= #
# for yimg.com video
# ============================================================= #
} elsif ($u=~ m/^https?\:\/\/(.*yimg.com)\/\/(.*)\/([^\/\?\&]*\/[^\/\?\&]*\.[^\/\?\&]{3,4})(\?.*)?$/) {
    $out="OK store-id=http://cdn.yimg.com/" . $3 ;

# ============================================================= #
# for yimg.com doubled
# ============================================================= #
} elsif ($u=~ m/^https?\:\/\/(.*?)\.yimg\.com\/(.*?)\.yimg\.com\/(.*?)\?(.*)/) {
    $out="OK store-id=http://cdn.yimg.com/"  . $3 ;

# ============================================================= #
# for yimg.com with &sig=
# ============================================================= #
} elsif ($u=~ m/^https?\:\/\/([^\.]*)\.yimg\.com\/(.*)/) {
    @y = ($1,$2);
    $y[0] =~ s/[a-z]+([0-9]+)?/cdn/;
    $y[1] =~ s/&sig=.*//;
    $out="OK store-id=http://" . $y[0] . ".yimg.com/"  . $y[1] ;

# ============================================================= #
# indowebster
# ============================================================= #
} elsif ($u=~ m/^https?\:\/\/(.*?)(\.jkt\.3d\.x\.indowebster.com)\/(.*?)\/([^\/\?\&]*)\.([^\/\?\&]{2,4})(\?.*?)$/) {
	@y = ($1,$2,$4,$5);
	$y[0] =~ s/([a-z][0-9][a-z]dlod[\d]{3})|((cache|cdn)[-\d]*)|([a-zA-Z]+-?[0-9]+(-[a-zA-Z]*)?)/cdn/;
	$out="OK store-id=http://" . $y[0] . $y[1] . "/" . $y[2] . "." . $y[3] ;

# ============================================================= #
# general purpose for cdn servers. add above your specific servers.
# ============================================================= #
} elsif ($u=~ m/^https?\:\/\/([0-9.]*?)\/\/(.*?)\.(.*)\?(.*?)/) {
    $out="OK store-id=http://squid-cdn-url/" . $2  . "." . $3 ;

} else { 
	$out="ERR";
}
	print $logfh "$timenow"."out: $a $out\n" if ($debug>=1);
	print "$a $out\n";
}
close $logfh if ($debug);
