#!/usr/bin/perl
#$Rev$
# Modifikasi 	: Bandi Shippuden
# Email 		: bandi.shippuden@gmail.com
# Hp	 		: +62 823 9033 5639
# =======================================================================
# Originaly by chudy_fernandez@yahoo.com
# Youtube updates at http://wiki.squid-cache.org/ConfigExamples/DynamicContent/YouTube/Discussion

# Facebook Group https://www.facebook.com/groups/Mikrotik.Squid.Indonesia
# Forum ubuntu indonesia http://ubuntu-indonesia.com/

# mohon maaf lahir batin atas kesalahan yang telah diperbuat baik sengaja ataupun tidak
# storeurl ini hasil nyontek kepunyaan chudy ( chudy_fernandez@yahoo.com )
# link asalnya adalah
# https://code.google.com/p/pfsense-cacheboy/source/browse/trunk/lusca/storeurl.pl

# ADA BAIKNYA BANDINGKAN JUGA, AGAR TAU APAKAH SAYA COPAS MENTAH MENTAH
# SAYA TIDAK ADA MAKSUD CARI NAFKAH DARI STOREURL INI, SAYA TIDAK MENERIMA JASA SETTING WARNET ATAUPUN MEMILIKI WARNET

# for ALL Youtube ( range & non range )
# acl youtube url_regex -i youtube.*(ptracking|stream_204|player_204|gen_204) .*$
# acl youtube url_regex -i (youtube|googlevideo)\.com\/(get_video|videoplayback|videoplay).*$
# storeurl_access allow youtube

# dikarenakan ada keterangan di squid config dokumentasi seperti berikut
# NOTE: when using StoreID refresh_pattern will apply to the StoreID
# returned from the helper and not the URL.
# untuk refresh pattern di squid-3.head gunakan refresh pattern berikut untuk seluruh yg ada di sini
# refresh_pattern -i storeurl://.*SQUIDINTERNAL 1440 99% 14400 override-expire override-lastmod ignore-no-cache ignore-private reload-into-ims ignore-must-revalidate ignore-reload store-stale
# dan untuk storeid maka replace '$x . "' dengan '$X[0] . " OK store-id=' tanpa tanda petik tunggal (') tentunya
#
########################################################
$|=1;
while (<>) {
    @X = split;
		if ( $X[0] =~ m/^https?:\/\/.*/) {
		$x = $X[0];
		$_ = $X[0];
		$u = $X[0];
} else {
		$x = $X[1];
		$_ = $X[1];
		$u = $X[1];
}

                # Speedtest
if (m/^http:\/\/(.*)\/speedtest\/(.*\.(jpg|txt))\?(.*)/) {
    $out ="http://www.speedtest.net.SQUIDINTERNAL/speedtest/" . $2 . "\n";

		# Speedtest
#} elsif ($X[1] =~ m/^http:\/\/.*\/speedtest\/([\w\d\-\.\%]*\.(jpg|txt|png|swf))\?.*/) {
#        $out ="storeurl://testspeed.SQUIDINTERNAL/" . $1 . "\n";

        # Gambar Video
} elsif ($X[1] =~ m/^http:\/\/video.google.com\/ThumbnailServer.*/) {
        @id = m/[&?](contentid=[\w\d\-\.\%]*)/;
        @itag = m/[&?](itag=[\w\d\-\.\%]*)/;
        @set = m/[&?](offsetms=[^\&\s]*)/;
        $out ="storeurl://Thumbnail.SQUIDINTERNAL/@id&@itag&@set\n";

# ==========================================================================
# youtube with range (YOUTUBE has split its videos into segments)
# ==========================================================================
} elsif ($X[1] =~ m/^http(|s)\:\/\/.*youtube.*(ptracking|stream_204|player_204|gen_204).*(video_id|docid|v)\=([^\&\s]*).*/){
        $vid = $4 ;
        @cpn = m/[&?]cpn\=([^\&\s]*)/;
        if (defined($vid )) {
                $fn = "/var/log/squid/@cpn";
                unless (-e $fn) {
                        open FH,">".$fn ;
                        print FH "$vid\n";
                        close FH;
                }
	}
        $out =$x . "\n";
 
} elsif ($X[1] =~ m/^http(|S)\:\/\/.*(youtube|google).*videoplayback.*/){
        @itag = m/[&?](itag=[0-9]*)/;
        @ids = m/[&?]id\=([^\&\s]*)/;
        @mime = m/[&?](mime\=[^\&\s]*)/;
        @cpn = m/[&?]cpn\=([^\&\s]*)/;
        if (defined($cpn[0])) {
            $fn = "/var/log/squid/@cpn";
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
        $out ="http://video-srv.youtube.com.SQUIDINTERNAL/id=" . $id . "&@itag@range@mime\n";
		
		#redirector
} elsif ($X[1] =~ m/^http\:\/\/redirector.c.googlesyndication.com\/videoplayback\/id\/(.*)\/file\/(.*)\/(.*\.flv)/){
		$out ="storeurl://video.google.com.SQUIDINTERNAL/redirector/" . $1 . "/" . $3 . "\n";
		
# ===========================================================================
# FACEBOOK
# ===========================================================================
} elsif (m/^http(|s):\/\/photos-[a-z](\.ak\.fbcdn\.net)(\/.*\/)(.*\.jpg)/) {
 		$out ="http://photos" . $1 . "/" . $2 . $3 . "\n";

} elsif (m/^http(|s):\/\/[a-z][0-9]\.sphotos\.ak\.fbcdn\.net\/(.*)\/(.*)/) {
 		$out ="http://photos.ak.fbcdn.net/" . $1 ."/". $2 . "\n";

} elsif ($X[1] =~ m/^http(|S)\:\/\/(photos-[a-z]\.ak\.fbcdn\.net|a[1-8]\.s?photos\.ak\.fbcdn\.net)\/h?photos-ak-.{4}(\/.*)/) {
		$out ="storeurl://photos.ak.fbcdn.SQUIDINTERNAL" . $2 . "\n";

} elsif ($X[1] =~ m/^http(|S):\/\/profile\.ak\.fbcdn\.net\/h?profile-ak-.{4}(\/.*)/) {
		$out ="storeurl://profile.ak.fbcdn.SQUIDINTERNAL" . $1 . "\n";

} elsif ($X[1] =~ m/^http(|S):\/\/video\.(.*)\.fbcdn\.net\/(.*?)\/([0-9_]+\.(mp4|flv|avi|mkv|m4v|mov|wmv|3gp|mpg|mpeg)?)(.*)/) {
		$out ="storeurl://video.ak.fbcdn.net/" . $3  . "\n";

		#photos-X.ak.fbcdn.net where X a-z
} elsif ($X[1] =~ m/^http(|S):\/\/photos-[a-z](\.ak\.fbcdn\.net)(\/.*\/)(.*\.jpg)/) {
		$out ="storeurl://photos" . $1 . "/" . $2 . $3  . "\n";
 
		#YX.sphotos.ak.fbcdn.net where X 1-9, Y a-z
} elsif ($X[1] =~ m/^http(|S):\/\/[a-z][0-9]\.sphotos\.ak\.fbcdn\.net\/(.*)\/(.*)/) {
		$out ="storeurl://photos.ak.fbcdn.net/" . $1  ."/". $2 . "\n";

} elsif ($X[1] =~ m/^http(|S):\/\/[\w\d\-\.\%]*fbcdn[\w\d\-\.\%]*net\/safe\_image\.php\?(.*)/) {
        	$out ="storeurl://fbcdn.SQUIDINTERNAL/" . $1  . "\n";
 
} elsif ($X[1] =~ m/^http(|S):\/\/[\w\d\-\.\%]*fbcdn[\w\d\-\.\%]*net\/rsrc\.php\/(.*)/) {
        	$out ="storeurl://fbcdn.SQUIDINTERNAL/" . $1  . "\n";
 
} elsif ($X[1] =~ m/^http(|S):\/\/[\w\d\-\.\%]*fbcdn[\w\d\-\.\%]*net\/[\w\d\-\.\%]*\/(.*)/) {
       		$out ="storeurl://fbcdn.SQUIDINTERNAL/" . $1  . "\n";

# ===========================================================================
# BLOGSPOT
# ===========================================================================
} elsif ($X[1] =~ m/^http:\/\/[1-4].bp.(blogspot.com.*)/) {
        	$out ="storeurl://blog-cdn." . $1  . "\n";

} elsif ($X[1] =~ m/^http:\/\/[0-9]?.bp.blogspot\.com\/(.*)\/s.*?\/(.*(jpg|png|gif)?$)/) {
		$out ="storeurl://bp.blogspot.com.SQUIDINTERNAL/" . $1 . "/" . $2 . "\n";

# ===========================================================================
# Oteher Site
# ===========================================================================
} elsif ($X[1] =~ m/^http:\/\/.*?firefox\/releases\/(.*?)\/(firefox.*(mar|exe)?$)/) {
		$out ="storeurl://firefox.SQUIDINTERNAL/" . $1 . "/" . $2 . "\n";

} elsif ($X[1] =~ m/^http:\/\/lh[0-9]?.ggpht.com\/(.*?)\/(.*?)\/(.*?)\/(.*)\/(.*)?$/) {
		$out ="storeurl://ggpht.SQUIDINTERNAL/"  . $1 . "/" .  $2 . "/" . $4 .  "/" .  $5 . "\n";

} elsif ($X[1] =~ m/^http:\/\/([a-z])[0-9]?(\.gstatic\.com.*|\.wikimapia\.org.*)/) {
		$out ="storeurl://" . $1  . $2 . "\n";

} elsif ($X[1] =~ m/^http:\/\/[0-9]{2}\.media\.tumblr\.com\/(.*)/) {
		$out ="storeurl://media.tumblr.com.SQUIDINTERNAL/" . $1 . "\n";

} elsif ($X[1] =~ m/^http:\/\/(cbk|mt|khm|mlt|tbn)[0-9]?(.google\.co(m|\.uk|\.id).*)/) {
		$out ="storeurl://" . $1  . $2 . "\n";

} elsif ($X[1] =~ m/^http:\/\/dl\.garenanow.com\/hon\/patcher\/(.*\.(exe|zip))\?/) {
		$out ="storeurl://dl.garena.SQUIDINTERNAL/" . $1 . "\n";

} elsif ($X[1] =~ m/^http:\/\/(.*?)\/(archlinux\/([a-z].*)\/os)\/(.*?[a-z]{2})$/) {
		$out ="storeurl://archlinux.org.SQUIDINTERNAL/" . $2 . "/" . $4  . "\n";

} elsif ($X[1] =~ m/^http:\/\/.*\.[a-z][0-9]\.(tiles\.virtualearth\.net)\/(.*\&n=z)/) {
		$out ="storeurl://" . $1 . "/" . $2 . "\n";

        	#youku
} elsif ($X[1] =~ m/^http\:\/\/.*\/youku\/(.*)\/(.*\.flv)/){
		$out ="storeurl://video.youku.com.SQUIDINTERNAL/youku/" . $2 . "\n";
 
        	#daily motion
} elsif ($X[1] =~ m/^http\:\/\/vid2.ak.dmcdn.net\/(.*)\/(.*)\/video\/(.*)\/(.*\.flv)/){
		$out ="storeurl://video.dailymotin.com.SQUIDINTERNAL/dailymotion/" . $2 . "/" . $4 . "\n";  

		# Aplikasi Android
} elsif ($X[1] =~ m/^http:\/\/.*\.c\.android\.clients\.google\.com\/market\/GetBinary\/([a-zA-Z0-9\-\_\.\%]*)\/([0-9]*)\/.*/){
		$out ="STOREURL://android-apps.SQUIDINTERNAL/$1/$2\n";

} elsif ($X[1] =~ m/^http:\/\/.*\.c\.android\.clients\.google\.com\/market\/GetBinary\/([a-zA-Z0-9\-\_\.\%]*)\/([0-9]*)\?.*/){
		$out ="STOREURL://android-apps.SQUIDINTERNAL/$1/$2\n";

		# APPS APPLE
} elsif ($X[1] =~ m/^http:\/\/[a-zA-Z0-9\-\_\.\%]*phobos\.apple\.com\/.*\/([a-zA-Z0-9\-\_\.\%]*\.ipa)/) {
		$out ="STOREURL://apple-apps.SQUIDINTERNAL/$1\n";

} elsif ($X[1] =~ m/^http:\/\/[a-zA-Z0-9\-\.\%]*pack\.google\.com\/.*\/([a-zA-Z0-9\-\.\%]*\.exe)/) {
		$out ="storeurl://chrome.SQUIDINTERNAL/" . $2 . "\n";

		#reverbnation
} elsif ($X[1] =~ m/^http:\/\/[a-z0-9]{4}\.reverbnation\.com\/.*\/([0-9]*).*/) {
		$out ="storeurl://reverbnation.com.SQUIDINTERNAL/" . "$1" . "\n";

		#mediafire
} elsif ($X[1] =~ m/^http:\/\/199\.91\.15\d\.\d*\/\w{12}\/(\w*)\/(.*)/) {
		$out ="storeurl://www.mediafire.com.SQUIDINTERNAL/" . $1 ."/" . $2 . "\n";
 
		#fileserve
} elsif ($X[1] =~ m/^http:\/\/fs\w*\.fileserve\.com\/file\/(\w*)\/[\w-]*\.\/(.*)/) {
		$out ="storeurl://www.fileserve.com.SQUIDINTERNAL/" . $1 . "./" . $2 . "\n";
 
		#filesonic
} elsif ($X[1] =~ m/^http:\/\/s[0-9]*\.filesonic\.com\/download\/([0-9]*)\/(.*)/) {
		$out ="storeurl://www.filesonic.com.SQUIDINTERNAL/" . $1 . "\n";
 
		#4shared
} elsif ($X[1] =~ m/^http:\/\/[a-zA-Z]{2}\d*\.4shared\.com(:8080|)\/download\/(.*)\/(.*\..*)\?.*/) {
		$out ="storeurl://www.4shared.com.SQUIDINTERNAL/download/$2\/$3\n";
 
		#4shared preview
} elsif ($X[1] =~ m/^http:\/\/[a-zA-Z]{2}\d*\.4shared\.com(:8080|)\/img\/(\d*)\/\w*\/dlink__2Fdownload_2F(\w*)_3Ftsid_3D[\w-]*\/preview\.mp3\?sId=\w*/) {
		$out ="storeurl://www.4shared.com.SQUIDINTERNAL/$2\n";

} elsif (($X[1] =~ /filehippo/) && (m/^http:\/\/(.*?)\.(.*?)\/(.*?)\/(.*)\.([a-z0-9]{3,4})(\?.*)?/)) {
		@y = ($1,$2,$4,$5);
		$y[0] =~ s/[a-z0-9]{2,5}/cdn./;
		$out ="http://" . $y[0] . $y[1] . "/" . $y[2] . "." . $y[3] . "\n";

		# Steam dota 2
} elsif (m/^http:\/\/valve[\d]*\.cs\.steampowered\.com\/(.*)/) {
        	$out ="storeurl://steampowered.SQUIDINTERNAL/" . $1 . "\n";
		
} elsif (m/^http:\/\/[a-z\d]*\.hsar\.steampowered\.com\.edgesuite\.net\/(.*)/) {
        	$out ="storeurl://steampowered.SQUIDINTERNAL/" . $1 . "\n";

# ===================================================================
# Update Game Online
# ===================================================================
#} elsif (m/^http:\/\/patch\.gemscool\.com\/(dragonnest|lsaga)\/(.*)\/(.*)\.(iop|zip|exe|dat|cab|rar|pak)$/){
#		$out ="http:/gemscool.SQUIDINTERNAL/$2\n";

#} elsif (m/^http:\/\/122\.102\.49\.202\/(.*)\/(.*)\.(kom|zip|exe)/){
#		$out ="http:/grandchase.SQUIDINTERNAL/$2\n";

# =====================================================================
# compatibility for old cached get_video?video_id
# =====================================================================
} elsif (m/^http:\/\/([0-9.]{4}|.*\.youtube\.com|.*\.googlevideo\.com|.*\.video\.google\.com).*?(videoplayback\?id=.*?|video_id=.*?)\&(.*?)/) {
		$z = $2; $z =~ s/video_id=/get_video?video_id=/;
		$out ="http://video-srv.youtube.com.SQUIDINTERNAL/" . $z . "\n";
		#sleep(1);    ## delay loop

		#maps.google.com
} elsif (m/^http:\/\/(cbk|mt|khm|mlt|tbn)[0-9]?(.google\.co(m|\.uk|\.id).*)/) {
		$out ="http://" . $1  . $2 . "\n";

		#gstatic and/or wikimapia
} elsif (m/^http:\/\/([a-z])[0-9]?(\.gstatic\.com.*|\.wikimapia\.org)\/(.*)/) {
        	$out ="STOREURL://wikimapia.SQUIDINTERNAL/" . $3 . "\n";

} elsif (m/^http:\/\/www\.google-analytics\.com\/__utm\.gif\?.*/) {
		$out ="http://www.google-analytics.com/__utm.gif\n";
 
		#Cache High Latency Ads
} elsif ($X[1] =~ m/^http:\/\/([a-z0-9.]*)(\.doubleclick\.net|\.quantserve\.com|\.googlesyndication\.com|yieldmanager|cpxinteractive)(.*)/) {
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
		$out ="http://" . $1 . $2 . $y . "\n";
	 
		#cache high latency ads
} elsif ($X[1] =~ m/^http:\/\/(.*?)\/(ads)\?(.*?)/) {
		$out ="http://" . $1 . "/" . $2  . "\n";
 
		# spicific servers starts here....
} elsif ($X[1] =~ m/^http:\/\/(www\.ziddu\.com.*\.[^\/]{3,4})\/(.*?)/) {
		$out ="http://" . $1 . "\n";

} elsif (($X[1] =~ /maxporn/) && (m/^http:\/\/([^\/]*?)\/(.*?)\/([^\/]*?)(\?.*)?$/)) {
		$out ="http://" . $1 . "/SQUIDINTERNAL/" . $3 . "\n";
	
} elsif (($X[1] =~ /fucktube/) && (m/^http:\/\/(.*?)(\.[^\.\-]*?[^\/]*\/[^\/]*)\/(.*)\/([^\/]*)\/([^\/\?\&]*)\.([^\/\?\&]{3,4})(\?.*?)$/)) {
		@y = ($1,$2,$4,$5,$6);
		$y[0] =~ s/(([a-zA-A]+[0-9]+(-[a-zA-Z])?$)|([^\.]*cdn[^\.]*)|([^\.]*cache[^\.]*))/cdn/;
		$out ="http://" . $y[0] . $y[1] . "/" . $y[2] . "/" . $y[3] . "." . $y[4] . "\n";

} elsif (($X[1] =~ /tube8|bravotube|pornhub|xvideos|pornotube|redtubefiles|xvideos/) && (m/^http:\/\/(([A-Za-z]+[0-9-.]+)*?(\.[a-z]*)?)\.([a-z]*[0-9]?\.[^\/]{3}\/[a-z]*)(.*?)((\/[a-z]*)?(\/[^\/]*){4}\.[^\/\?]{3,4})(\?.*)?$/)) {
		$out ="http://cdn." . $4 . $6 . "\n";

		#cdn, varialble 1st path
} elsif (($X[1] =~ /filehippo|mediafire/) && (m/^http:\/\/(.*?)\.(.*?)\/(.*?)\/(.*)\.([a-z0-9]{3,4})(\?.*)?/)) {
		@y = ($1,$2,$4,$5);
		$y[0] =~ s/[a-z0-9]{2,5}/cdn./;
		$out ="http://" . $y[0] . $y[1] . "/" . $y[2] . "." . $y[3] . "\n";
	 
		#rapidshare
} elsif (($X[1] =~ /rapidshare/) && (m/^http:\/\/(([A-Za-z]+[0-9-.]+)*?)([a-z]*\.[^\/]{3}\/[a-z]*\/[0-9]*)\/(.*?)\/([^\/\?\&]{4,})$/)) {
		$out ="http://cdn." . $3 . "/SQUIDINTERNAL/" . $5 . "\n";
 
		#like porn hub variables url and center part of the path, filename etention 3 or 4 with or without ? at the end
} elsif (($X[1] =~ /tube8|pornhub|xvideos/) && (m/^http:\/\/(([A-Za-z]+[0-9-.]+)*?(\.[a-z]*)?)\.([a-z]*[0-9]?\.[^\/]{3}\/[a-z]*)(.*?)((\/[a-z]*)?(\/[^\/]*){4}\.[^\/\?]{3,4})(\?.*)?$/)) {
		$out ="http://cdn." . $4 . $6 . "\n";

} elsif ($X[1] =~ m/^http:\/\/.*\.xvideos\.com\/.*\/([a-zA-Z0-9\-\_\.\%]*\.(3gp|mpg|flv|mp4))\?.*/){
		$out ="storeurl://xvideos.SQUIDINTERNAL/$1\n";
		
} elsif ($X[1] =~ m/^http:\/\/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\/.*\/xh.*\/([a-zA-Z0-9\-\_\.\%]*\.flv)/){
		$out ="storeurl://Xhamster.SQUIDINTERNAL/$1\n";

} elsif ($X[1] =~ m/^http:\/\/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+.*\/([a-zA-Z0-9\-\_\.\%]*\.flv)\?start=0/){
		$out ="storeurl://Xhamster2.SQUIDINTERNAL/$1\n";
	
} elsif ($X[1] =~ m/^http:\/\/.*\.youjizz\.com.*\/([a-zA-Z0-9\-\_\.\%]*\.(mp4|flv|3gp))\?.*/){
		$out ="storeurl://YouJizz.SQUIDINTERNAL/$1\n";

} elsif ($X[1] =~ m/^http:\/\/[a-zA-Z0-9\-\_\.\%]*\.keezmovies[a-zA-Z0-9\-\_\.\%]*\.com.*\/([a-zA-Z0-9\-\_\.\%]*\.(mp4|flv|3gp|mpg|wmv))\?.*/){
		$out ="storeurl://KeezMovies.SQUIDINTERNAL/$1\n";

} elsif ($X[1] =~ m/^http:\/\/[a-zA-Z0-9\-\_\.\%]*\.tube8[a-zA-Z0-9\-\_\.\%]*\.com.*\/([a-zA-Z0-9\-\_\.\%]*\.(mp4|flv|3gp|mpg|wmv))\?.*/) {
		$out ="storeurl://Tube8.SQUIDINTERNAL/$1\n";

} elsif ($X[1] =~ m/^http:\/\/[a-zA-Z0-9\-\_\.\%]*\.youporn[a-zA-Z0-9\-\_\.\%]*\.com.*\/([a-zA-Z0-9\-\_\.\%]*\.(mp4|flv|3gp|mpg|wmv))\?.*/){
		$out ="storeurl://YouPorn.SQUIDINTERNAL/$1\n";

} elsif ($X[1] =~ m/^http:\/\/[a-zA-Z0-9\-\_\.\%]*\.spankwire[a-zA-Z0-9\-\_\.\%]*\.com.*\/([a-zA-Z0-9\-\_\.\%]*\.(mp4|flv|3gp|mpg|wmv))\?.*/) {
		$out ="storeurl://SpankWire.SQUIDINTERNAL/$1\n";

} elsif ($X[1] =~ m/^http:\/\/[a-zA-Z0-9\-\_\.\%]*\.pornhub[a-zA-Z0-9\-\_\.\%]*\.com.*\/([[a-zA-Z0-9\-\_\.\%]*\.(mp4|flv|3gp|mpg|wmv))\?.*/){
		$out ="storeurl://PornHub.SQUIDINTERNAL/$1\n";

} elsif ($X[1] =~ m/^http:\/\/[a-zA-Z0-9\-\_\.\%\/]*.*\/([a-zA-Z0-9\-\_\.]+\.(flv|mp3|mp4|3gp|wmv))\?.*cdn\_hash.*/){
		$out ="storeurl://media.SQUIDINTERNAL/$1\n";
 
		#photos-X.ak.fbcdn.net where X a-z
} elsif ($X[1] =~ m/^http:\/\/photos-[a-z].ak.fbcdn.net\/(.*)/) {
		$out ="http://photos.ak.fbcdn.net/" . $1  . "\n";
 
 		#ytimg
} elsif ($X[1] =~ m/^http:\/\/*.ytimg\.com(.*)/) {
        	$out ="http://cdn.ytimg.com" . $1  . "\n";
		
		#for yimg.com video
} elsif ($X[1] =~ m/^http:\/\/(.*yimg.com)\/\/(.*)\/([^\/\?\&]*\/[^\/\?\&]*\.[^\/\?\&]{3,4})(\?.*)?$/) {
		$out ="http://cdn.yimg.com//" . $3 . "\n";
 
		#for yimg.com doubled
} elsif ($X[1] =~ m/^http:\/\/(.*?)\.yimg\.com\/(.*?)\.yimg\.com\/(.*?)\?(.*)/) {
		$out ="http://cdn.yimg.com/"  . $3 . "\n";
 
		#for yimg.com with &sig=
} elsif ($X[1] =~ m/^http:\/\/(.*?)\.yimg\.com\/(.*)/) {
		@y = ($1,$2);
		$y[0] =~ s/[a-z]+[0-9]+/cdn/;
		$y[1] =~ s/&sig=.*//;
		$out ="http://" . $y[0] . ".yimg.com/"  . $y[1] . "\n";
	 
		#youjizz. We use only domain and filename
} elsif (($X[1] =~ /media[0-9]{2,5}\.youjizz/) && (m/^http:\/\/(.*)(\.[^\.\-]*?\..*?)\/(.*)\/([^\/\?\&]*)\.([^\/\?\&]{3,4})((\?|\%).*)?$/)) {
		@y = ($1,$2,$4,$5);
		$y[0] =~ s/(([a-zA-A]+[0-9]+(-[a-zA-Z])?$)|(.*cdn.*)|(.*cache.*))/cdn/;
		$out ="http://" . $y[0] . $y[1] . "/" . $y[2] . "." . $y[3] . "\n";
	 
		#generic http://variable.domain.com/path/filename."ex" "ext" or "exte" with or withour "? or %"
} elsif ($X[1] =~ m/^http:\/\/(.*)(\.[^\.\-]*?\..*?)\/(.*)\.([^\/\?\&]{2,4})((\?|\%).*)?$/) {
		@y = ($1,$2,$3,$4);
		$y[0] =~ s/(([a-zA-Z]+[0-9]+(-[a-zA-Z])?$)|(.*cdn.*)|(.*cache.*))/cdn/;
		$out ="http://" . $y[0] . $y[1] . "/" . $y[2] . "." . $y[3] . "\n";
 
		# generic http://variable.domain.com/...
} elsif ($X[1] =~ m/^http:\/\/(([A-Za-z]+[0-9-]+)*?|.*cdn.*|.*cache.*)\.(.*?)\.(.*?)\/(.*)$/) {
		$out ="http://cdn." . $3 . "." . $4 . "/" . $5 .  "\n";

                        # spicific extention
} elsif ($X[1] =~ m/^http:\/\/(.*?)\.(jp(e?g|e|2)|gif|png|tiff?|bmp|ico|flv|wmv|3gp|mp(4|3)|exe|msi|zip|on2|mar|swf|iop|pak|kom|nzp).*?/) {
            @y = ($1,$2);
         $y[0] =~ s/((cache|cdn)[-\d]*)|([a-zA-A]+-?[0-9]+(-[a-zA-Z]*)?)/cdn/;
       		$out ="http://" . $y[0] . "." . $y[1] . "\n";

                # spicific extention that ends with ?
} elsif ($X[1] =~ m/^http:\/\/(.*?)\/(.*[.](z(ip|[0-9]{2})|r(ar|[0-9]{2})|7z|bz2|gz|tar|rpm|deb|xz|webm|iop|ini|amf|ts1|apk|pak|kom|exe|ms(i|u|p)|cab|bin|mar|xpi|psf))\?(.*)/) {
                $out ="storeurl://" . $1 . "/" . $2  . "." . $3 . "\n";

		# spicific extention that ends whoth ?
} elsif ($X[1] =~ m/^http:\/\/(.*)\/(.*[.](z(ip|[0-9]{2})|r(ar|[0-9]{2})|7z|bz2|gz|tar|rpm|deb|xz|webm|iop|amf|ts1|apk|exe|ms(i|u|p)|cab|bin|mar|xpi|nzp|pak|kom|iop|3gp|mp(3|4)|flv|(m|f)1v|(m|f)4v|on2|fid|aac|asf|flac|mpc|nsv|og(g|m|a)|avi|mov|wm(a|v)|mp(e?g|a|e|v)|mk(a|v)))(.*)/) {
		$out ="storeurl://" . $1 . "/" . $2  . "." . $3 . "\n";
 	
                # spicific extention that ends with ?
} elsif ($X[1] =~ m/^http:\/\/(.*?)\/(.*?)\.(jp(e?g|e|2)|gif|png|tiff?|bmp|ico|flv|wmv|3gp|mp(4|3)|exe|msi|zip|on2|mar|rar|cab|amf|swf|iop|pak|nzp)(.*)/) {
                $out ="http://" . $1 . "/" . $2  . "." . $3 . "\n";

		#general purpose for cdn servers. add above your specific servers.
} elsif ($X[1] =~ m/^http:\/\/([0-9.]*?)\/\/(.*?)\.(.*)\?(.*?)/) {
		$out ="http://squid-cdn-url//" . $2  . "." . $3 . "\n";

		# all that ends with ;
} elsif ($X[1] =~ m/^http:\/\/(.*?)\/(.*?)\;(.*)/) {
		$out ="http://" . $1 . "/" . $2  . "\n";

} else {
$out=$x;

}
if ( $X[0] =~ m/^https?:\/\/.*/) {
		print "OK store-id=$out\n" ;
} else {
		print $X[0] . " OK store-id=$out\n" ;
	}
}

