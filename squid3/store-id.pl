#!/usr/bin/perl
# $Rev$
# ISI DARI STORE-ID DIBAWAH INI DARI SHUDY
# SHUDYLAH BERBAGI ILMU :3
# ucok_karnadi(at)yahoo.com or https://twitter.com/syaifuddin_jw
# send link from youtube contain >> (ptracking|stream_204|player_204|gen_204) to storeurl
############################################################################################
$|=1;
while (<>) {
@X = split;

if ( $X[0] =~ m/^https?\:\/\/.*/) {
$x = $X[0];
$_ = $X[0];
$u = $X[0];
} else {
$x = $X[1];
$_ = $X[1];
$u = $X[1];
}

#if (m/^https?\:\/\/video.google.com\/ThumbnailServer.*/) {
#        @id = m/[&?](contentid=[\w\d\-\.\%]*)/;
#        @itag = m/[&?](itag=[\w\d\-\.\%]*)/;
#        @set = m/[&?](offsetms=[^\&\s]*)/;
#        print "OK store-id=storeurl://Thumbnail.squid.internal/@id&@itag&@set";
		
# ============================================================= #
# redirector
# ============================================================= #
#} elsif (m/^https?\:\/\/redirector.c.googlesyndication.com\/videoplayback\/id\/(.*)\/file\/(.*)\/(.*\.flv)/){
#        print "OK store-id=http://video.google.com.squid.internal/redirector/" . $1 . "/" . $3 . "\n";

# ============================================================= #
# Youtube Video
# ============================================================= #
if (m/^https?\:\/\/(www|c|s)\.youtube\.com\/(ptracking|stream_204|player_204|gen_204).*(video_id|docid|v)\=([^\&\s]*).*/){
        $vid = $4 ;
        @cpn = m/[&?]cpn\=([^\&\s]*)/;
                $fn = "/tmp/@cpn";
                unless (-e $fn) {
                        open FH,">".$fn ;
                        print FH "$vid\n";
                        close FH;
                }
        print "ERR\n";

} elsif (m/^https?\:\/\/.*(youtube|googlevideo)\.com.*videoplayback.*/){
        @itag = m/[&?](itag=[0-9]*)/;
        @ids = m/[&?]id\=([^\&\s]*)/;
        @mime = m/[&?](mime\=[^\&\s]*)/;
        @cpn = m/[&?]cpn\=([^\&\s]*)/;
        if (defined($cpn[0])) {
            $fn = "/tmp/@cpn";
            if (-e $fn) {
                open FH,"<".$fn ;
                $id  = <FH>;
                chomp $id ;
                close FH ;
                  } else {
                $id = $ids[0] ;
            }
        } else {
          $id = $ids[0] ;
        }
        @range = m/[&?](range=[^\&\s]*)/;
        print "OK store-id=http://video-srv.youtube.com.squid.internal/id=" . $id . "&@itag@range@mime\n";

} elsif (m/(youtube|googlevideo).*videoplayback.*/){
        @itag = m/[&?](itag=[0-9]*)/;
        @id = m/[&?](id=[^\&]*)/;
        @range = m/[&?](range=[^\&\s]*)/;
        print "OK store-id=http://video-srv.youtube.com.squid.internal/@id&@itag@range\n";

} elsif (m/^https?\:\/\/.*(youtube|googlevideo).*(videoplayback|liveplay).*/){
        @itag = m/[&?](itag=[0-9]*)/;
        @id = m/[&?](id=[^\&]*)/;
        @range = m/[&?](range=[^\&\s]*)/;
        @begin = m/[&?](begin=[^\&\s]*)/;
        @redirect = m/[&?](redirect_counter=[^\&]*)/;
        print "OK store-id=http://video-srv.youtube.com.squid.internal/@id&@itag&@range@begin@redirect\n";

# ============================================================= #
# Facebook
# ============================================================= #
} elsif (m/^https?\:\/\/.*(profile|photo|creative).*\.ak\.fbcdn\.net\/((h|)(profile|photos)-ak-)(snc|ash|prn)[0-9]?(.*)/) {
        print "OK store-id=http://fbcdn.net.squid.internal/" . $2  . "fb" .  $6 . "\n";

} elsif (m/^https?:\/\/.*(profile|photo|creative)*.akamaihd\.net\/((h|)(profile|photos|ads)-ak-)(snc|ash|prn|frc[0-9])[0-9]?(.*)/) {
        print "OK store-id=http://akamaihd.net.squid.internal/" . $2  . $5 .  $6 . "\n";

} elsif (m/^https?\:\/\/video\.(.*)\.fbcdn\.net\/(.*?)\/([0-9_]+\.(mp4|flv|avi|mkv|m4v|mov|wmv|3gp|mpg|mpeg)?)(.*)/) {
	print "OK store-id=http://video.ak.fbcdn.net/" . $1 . "\n";

} elsif (m/^https?\:\/\/lh[0-9]?.ggpht.com\/(.*?)\/(.*?)\/(.*?)\/(.*)\/(.*)?$/) {
	print "OK store-id=http://ggpht.squid.internal/"  . $1 . "/" .  $2 . "/" . $4 .  "/" .  $5 . "\n";

# ============================================================= #
# Ytimg
# ============================================================= #
} elsif (m/^https?:\/\/i[1-4]\.ytimg\.com\/(.*)/) {
        print "OK store-id=http://ytimg.com.squid.internal/" . $1 . "\n";

# ============================================================= #
# Fileserve
# ============================================================= #
#} elsif ($X[0]=~ m/^http:\/\/fs\w*\.fileserve\.com\/file\/(\w*)\/[\w-]*\.\/(.*)/) {
#	print "OK store-id=http://www.fileserve.com.squid.internal/" . $1 . "./" . $2 . "\n";

# ============================================================= #
# youku
# ============================================================= #
#} elsif ($x=~ m/^http\:\/\/.*\/youku\/(.*)\/(.*\.flv)/){
#        print "OK store-id=http://video.youku.com.squid.internal/youku/" . $2 . "\n";

# ============================================================= #
# daily motion
# ============================================================= #
#} elsif ($x=~ m/^http\:\/\/vid2.ak.dmcdn.net\/(.*)\/(.*)\/video\/(.*)\/(.*\.flv)/){
#        print "OK store-id=http://video.dailymotin.com.squid.internal/dailymotion/" . $2 . "/" . $4 . "\n"; 

# ============================================================= #
# Sourcefrog
# ============================================================= #
#} elsif ($X[0]=~ m/^http:\/\/.*\.dl\.sourceforge\.net\/(.*)/) {
#        print "OK store-id=http://dl.sourceforge.net.squid.internal/" . $1 . "\n";

# ============================================================= #
# zynga
# ============================================================= #
#} elsif ($X[0]=~ m/^https?:\/\/zynga[1-9]?-a.(akamaihd.net.*)/) {
#        print "OK store-id=http://zynga-akamaihd.net.squid.internal/" . $1 . "\n";

# ============================================================= #
# Speedtest
# ============================================================= #
} elsif ($X[0]=~ m/^http\:\/\/.*\/speedtest\/(.*\.(jpg|txt)).*/) {
        print "OK store-id=http://speedtest.net.squid.internal/" . $1 . "\n";
       
# ============================================================= #
# Blogspot
# ============================================================= #
#} elsif ($X[0]=~ m/^http:\/\/[1-4]\.bp\.blogspot\.com.*\.(jpg|gif|png|jpeg)/) {
#        print "OK store-id=http://blog-cdn.squid.internal/" . $1  . "\n";

# ========================================== #
# Mediafire
# ========================================== #
#} elsif ($X[0]=~ m/^https?\:\/\/199\.91\.15\d\.\d*\/\w{12}\/(\w*)\/(.*)/) {#
	print "OK store-id=http://www.mediafire.com.squid.internal/" . $1 ."/" . $2 . "\n";

# ========================================== #
# Filesonic
# ========================================== #
#} elsif ($X[0]=~ m/^http\:\/\/s[0-9]*\.filesonic\.com\/download\/([0-9]*)\/(.*)/) {
#	print "OK store-id=http://www.filesonic.com.squid.internal/" . $1 . "\n";

# ========================================== #
# 4shared
# ========================================== #
} elsif (m/^http\:\/\/[a-zA-Z]{2}\d*\.4shared\.com(:8080|)\/download\/(.*)\/(.*\..*)\?.*/) {
	print "OK store-id=http://www.4shared.com.squid.internal/download/$2\/$3\n";

} elsif (m/^http\:\/\/[a-zA-Z]{2}\d*\.4shared\.com(:8080|)\/img\/(\d*)\/\w*\/dlink__2Fdownload_2F(\w*)_3Ftsid_3D[\w-]*\/preview\.mp3\?sId=\w*/) {
	print "OK store-id=http://www.4shared.com.squid.internal/$2\n";

} elsif (($u =~ /4shared/) && (m/^http:\/\/(.*?)\.(.*?)\/(.*?)\/(dlink__2Fdownload_2F([^\/-]+))([a-zA-Z0-9-]+)\/([^\/\?\&]*\.[^\/\?\&]{2,3})(\?.*)?$/)) {
	@y = ($1,$2,$3,$4,$7);
	$y[0] =~ s/[a-z]+([0-9]+)?/cdn./;
	print "OK store-id=http://" . $y[0] . $y[1] . "/" . $y[2] . "/" . $y[3] . "/" . $y[4] . "\n";

# ============================================================= #
# Maps.Google.com
# ============================================================= #
} elsif (m/^https\:\/\/(cbk|mt|khm|mlt|tbn)[0-9]?(.google\.co(m|\.uk|\.id).*)/) {
        print "OK store-id=http://" . $1  . $2 . "\n";

# ============================================================= #
# gstatic and/or wikimapia
# ============================================================= #
} elsif (m/^http:\/\/([a-z])[0-9]?(\.gstatic\.com.*|\.wikimapia\.org.*)/) {
        print "OK store-id=http://" . $1  . $2 . "\n";

# ============================================================= #
# maps.google.com
# ============================================================= #
} elsif (m/^https?\:\/\/(khm|mt)[0-9]?(.google.com.*)/) {
        print "OK store-id=http://" . $1  . $2 . "\n";

# ============================================================= #      
# Google
# ============================================================= #
} elsif ($X[0]=~ m/^https?\:\/\/www\.google-analytics\.com\/__utm\.gif\?.*/) {
        print "OK store-id=http://www.google-analytics.com/__utm.gif\n";

# ============================================================= #
# Cache High Latency Ads
# ============================================================= #
} elsif (m/^https?\:\/\/([a-z0-9.]*)(\.doubleclick\.net|\.quantserve\.com|\.googlesyndication\.com|yieldmanager|cpxinteractive)(.*)/) {
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
        print "OK store-id=http://" . $1 . $2 . $y . "\n";

# ============================================================= #
# Ziddu
# ============================================================= #
#} elsif (m/^http:\/\/(www\.ziddu\.com.*\.[^\/]{3,4})\/(.*?)/) {
#        print "OK store-id=http://" . $1 . "\n";

# ============================================================= #
# cdn, varialble 1st path
# ============================================================= #
#} elsif (($X[0]=~ /filehippo/) && (m/^http:\/\/(.*?)\.(.*?)\/(.*?)\/(.*)\.([a-z0-9]{3,4})(\?.*)?/)) {
#        @y = ($1,$2,$4,$5);
#        $y[0] =~ s/[a-z0-9]{2,5}/cdn./;
#        print "OK store-id=http://" . $y[0] . $y[1] . "/" . $y[2] . "." . $y[3] . "\n";

# ============================================================= #
# Rapidshare
# ============================================================= #
#} elsif (($X[0]=~ /rapidshare/) && (m/^http:\/\/(([A-Za-z]+[0-9-.]+)*?)([a-z]*\.[^\/]{3}\/[a-z]*\/[0-9]*)\/(.*?)\/([^\/\?\&]{4,})$/)) {
#        print "OK store-id=http://cdn." . $3 . "/squid.internal/" . $5 . "\n";

# ============================================================= #
# for yimg.com video
# ============================================================= #
} elsif ($X[0]=~ m/^http:\/\/(.*yimg.com)\/\/(.*)\/([^\/\?\&]*\/[^\/\?\&]*\.[^\/\?\&]{3,4})(\?.*)?$/) {
        print "OK store-id=http://cdn.yimg.com/" . $3 . "\n";

# ============================================================= #
# for yimg.com doubled
# ============================================================= #
} elsif ($X[0]=~ m/^http:\/\/(.*?)\.yimg\.com\/(.*?)\.yimg\.com\/(.*?)\?(.*)/) {
        print "OK store-id=http://cdn.yimg.com/"  . $3 . \"n";

# ============================================================= #
# for yimg.com with &sig=
# ============================================================= #
} elsif ($X[0]=~ m/^http:\/\/([^\.]*)\.yimg\.com\/(.*)/) {
        @y = ($1,$2);
        $y[0] =~ s/[a-z]+([0-9]+)?/cdn/;
        $y[1] =~ s/&sig=.*//;
        print "OK store-id=http://" . $y[0] . ".yimg.com/"  . $y[1] . "\n";

# ============================================================= #
# indowebster
# ============================================================= #
} elsif (m/^http:\/\/(.*?)(\.jkt\.3d\.x\.indowebster.com)\/(.*?)\/([^\/\?\&]*)\.([^\/\?\&]{2,4})(\?.*?)$/) {
	@y = ($1,$2,$4,$5);
	$y[0] =~ s/([a-z][0-9][a-z]dlod[\d]{3})|((cache|cdn)[-\d]*)|([a-zA-Z]+-?[0-9]+(-[a-zA-Z]*)?)/cdn/;
		print "OK store-id=http://" . $y[0] . $y[1] . "/" . $y[2] . "." . $y[3] . "\n";

# ============================================================= #
# general purpose for cdn servers. add above your specific servers.
# ============================================================= #
#} elsif ($X[0]=~ m/^http:\/\/([0-9.]*?)\/\/(.*?)\.(.*)\?(.*?)/) {
#        print "OK store-id=http://squid-cdn-url/" . $2  . "." . $3 . "\n";

# spicific extention that ends with ?
#} elsif ($X[0]=~ m/^http\:\/\/(.*?)\/(.*?)\.(jp(e?g|e|2)|gif|png|tiff?|bmp|ico|flv|on2)(.*)/) {
#		print "OK store-id=http://" . $1 . "/" . $2  . "." . $3 . "\n";

# ============================================================= #
# spicific extention
# ============================================================= #
} elsif (m/^https?:\/\/(.*?)\.(iop|pak|nzp|kom|mdb|3gp|mp(3|4)|flv|(m|f)4v|on2|fid|avi|mov|wm(a|v)|(mp(e?g|a|e|1|2))|mk(a|v)|jp(e?g|e|2)|gif|png|tiff?|bmp|tga|svg|ico|swf|exe|ms(i|u|p)|cab|psf|mar|bin|z(ip|[0-9]{2})|r(ar|[0-9]{2})|7z)\?/) {
        print "OK store-id=http://" . $1 . "/" . $2  . "." . $3 . "\n";

#} elsif ($X[0]=~ m/^http:\/\/(.*?)\.(iop|pak|nzp|kom|mdb|3gp|mp(3|4)|flv|(m|f)4v|on2|fid|avi|mov|wm(a|v)|(mp(e?g|a|e|1|2))|mk(a|v)|jp(e?g|e|2)|gif|png|tiff?|bmp|tga|svg|ico|swf|exe|ms(i|u|p)|cab|psf|mar|bin|z(ip|[0-9]{2})|r(ar|[0-9]{2})|7z)$/) {
#        print "OK store-id=http://" . $1 . "/" . $2  . "." . $3 . "\n";

# ============================================================= #
#generic http://variable.domain.com/path/filename."ex", "ext" or "exte"
#http://cdn1-28.projectplaylist.com
#http://s1sdlod041.bcst.cdn.s1s.yimg.com
# ============================================================= #
#} elsif ($X[0]=~ m/^http:\/\/(.*?)(\.[^\.\-]*?\..*?)\/([^\?\&\=]*)\.([\w\d]{2,4})\??.*$/) {
#        @y = ($1,$2,$3,$4);
#        $y[0] =~ s/([a-z][0-9][a-z]dlod[\d]{3})|((cache|cdn)[-\d]*)|([a-zA-A]+-?[0-9]+(-[a-zA-Z]*)?)/cdn/;
#        print "OK store-id=http://" . $y[0] . $y[1] . "/" . $y[2] . "." . $y[3] . "\n";

# ============================================================= #
# all that ends with ;
# ============================================================= #
} elsif (m/^https?\:\/\/(.*?)\/(.*?)\;(.*)/) {
        print "OK store-id=http://" . $1 . "/" . $2 . "\n";

} else {
        print "ERR\n";

    }
}
