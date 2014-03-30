#!/usr/bin/perl

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
#	NOTE: when using StoreID refresh_pattern will apply to the StoreID
#	      returned from the helper and not the URL.
# untuk refresh pattern di squid-3.head gunakan refresh pattern berikut untuk seluruh yg ada di sini
# refresh_pattern -i storeurl://.*SQUIDINTERNAL 1440 99% 14400 override-expire override-lastmod ignore-no-cache ignore-private reload-into-ims ignore-must-revalidate ignore-reload store-stale
# dan untuk storeid maka replace '$x . "' dengan '$X[0] . " OK store-id=' tanpa tanda petik tunggal (') tentunya

$|=1;
while (<>) {
    @X = split;
       $x = $X[0] . " ";
       $_ = $X[1];
       $u = $X[1];

	# Poto Pesbuk
	
# acl dontrewrite url_regex -i s\-platform\.ak\.fbcdn\.net
# acl store_rewrite_list url_regex -i fbcdn.*net
# refresh_pattern -i fbcdn.*net 1440 99% 14400 override-expire override-lastmod ignore-no-cache ignore-private reload-into-ims ignore-must-revalidate ignore-reload store-stale

	# http://external.ak.fbcdn.net/safe_image.php?d=AQDfyygmJfvPVGen&w=154&h=154&url=http%3A%2F%2Fassets.kompas.com%2Fdata%2Fphoto%2F2013%2F04%2F10%2F1054532-jantungserangan-780x390.jpg&cfs=1
	# http://static.ak.fbcdn.net/rsrc.php/v2/yb/r/GsNJNwuI-UM.gif
	# http://static.ak.fbcdn.net/rsrc.php/v2/y1/r/lBvtSWSBAGQ.png
	# http://s-platform.ak.fbcdn.net/www/app_full_proxy.php?app=211923588878449&v=1&size=z&cksum=d06fe084823f168f335a831a949bf61b&src=http%3A%2F%2Fbycdn8-i.akamaihd.net%2Fantwars_id%2Fimages%2Fcontinueslogin.png
	# hasil atas http://bycdn8-i.akamaihd.net/antwars_id/images/continueslogin.png
	# http://profile.ak.fbcdn.net/hprofile-ak-ash2/274241_1187750150_2088800094_q.jpg
if ($X[1] =~ m/^http\:\/\/[a-zA-Z0-9\-\_\.\%]*fbcdn[a-zA-Z0-9\-\_\.\%]*net\/safe\_image\.php\?(.*)/) {
        print $x . "storeurl://fbcdn.SQUIDINTERNAL/" . $1  . "\n";

} elsif ($X[1] =~ m/^http\:\/\/[a-zA-Z0-9\-\_\.\%]*fbcdn[a-zA-Z0-9\-\_\.\%]*net\/rsrc\.php\/(.*)/) {
        print $x . "storeurl://fbcdn.SQUIDINTERNAL/" . $1  . "\n";

} elsif ($X[1] =~ m/^http\:\/\/[a-zA-Z0-9\-\_\.\%]*fbcdn[a-zA-Z0-9\-\_\.\%]*net\/[a-zA-Z0-9\-\_\.\%]*\/(.*)/) {
        print $x . "storeurl://fbcdn.SQUIDINTERNAL/" . $1  . "\n";

	# Survey Google Menggelitik 
# acl store_rewrite_list url_regex -i www\.google\-analytics\.com
# refresh_pattern -i google\-analytics\.com.*gif 1440 99% 14400 override-expire override-lastmod ignore-no-cache ignore-private reload-into-ims ignore-must-revalidate ignore-reload store-stale
	# http://www.google-analytics.com/__utm.gif?utmwv=5.4.3&utms=27&utmn=938635439&utmhn=handphone.tokobagus.com&utmt=event&utme=5(image*browse-photo*26201942)8(5!Detail)9(5!Handphone)&utmcs=UTF-8&utmsr=1366x768&utmvp=1350x641&utmsc=32-bit&utmul=en-us&utmje=1&utmfl=11.2%20r202&utmdt=Sony%20Ericsson%20Xperia%20Arc%20S%20-%20Tokobagus.com&utmhid=1672766072&utmr=0&utmp=%2Fsony-ericsson%2Fsony-ericsson-xperia-arc-s-26201942.html%3Frelated%3D1&utmht=1374079248247&utmac=UA-5908313-1&utmcc=__utma%3D223717764.136894205.1374078869.1374078869.1374078869.1%3B%2B__utmz%3D223717764.1374078869.1.1.utmcsr%3Dgoogle%7Cutmccn%3D(organic)%7Cutmcmd%3Dorganic%7Cutmctr%3Dtoko%2520bagus%3B&utmu=6RAAAC%7E
} elsif ($X[1] =~ m/^http:\/\/www\.google-analytics\.com\/__utm.gif\?.*/) {
		print $x . "storeurl://analytic.SQUIDINTERNAL/utm.gif\n";

	# Gambar Video
# acl store_rewrite_list url_regex -i video\.google\.com\/ThumbnailServer
# refresh_pattern -i video\.google\.com\/ThumbnailServer 1440 99% 14400 override-expire override-lastmod ignore-no-cache ignore-private reload-into-ims ignore-must-revalidate ignore-reload store-stale
	# http://video.google.com/ThumbnailServer2?app=blogger&contentid=32b710e374d15805&offsetms=5000&itag=w160&sigh=zQUsG2TTuxfG4g4nwoGvWdRMGy8
} elsif ($X[1] =~ m/^http:\/\/video.google.com\/ThumbnailServer.*/) {
        @id = m/[&?](contentid=[a-zA-Z0-9\-\_\.\%]*)/;
		@itag = m/[&?](itag=[a-zA-Z0-9\-\_\.\%]*)/;
        @set = m/[&?](offsetms=[^\&\s]*)/;
		print $x . "storeurl://Thumbnail.SQUIDINTERNAL/@id&@itag&@set\n";
		
	# Video Youtube
# acl dontrewrite url_regex redbot\.org (get_video|videoplayback\?id|videoplayback.*id).*begin\=[1-9][0-9]*
# acl store_rewrite_list url_regex -i (youtube|google).*(videoplayback|liveplay)
# refresh_pattern -i (youtube|google).*(videoplayback|liveplay) 1440 99% 14400 override-expire override-lastmod ignore-no-cache ignore-private reload-into-ims ignore-must-revalidate ignore-reload store-stale
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
        print $x . $X[1] . "\n";
 
} elsif ($X[1] =~ m/^http\:\/\/.*(youtube|google).*videoplayback.*/){
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
        print $x . "http://video-srv.youtube.com.SQUIDINTERNAL/id=" . $id . "&@itag@range@mime\n";

	# Aplikasi Android
# acl dontrewrite url_regex redirector\.c\.android\.clients\.google\.com
# acl store_rewrite_list url_regex -i c\.android\.clients\.google\.com
# refresh_pattern -i c\.android\.clients\.google\.com 1440 99% 14400 override-expire override-lastmod ignore-no-cache ignore-private reload-into-ims ignore-must-revalidate ignore-reload store-stale
	#http://android.clients.google.com/market/download/Download?packageName=com.android.vending&versionCode=80210006&ch=zen2II1nK1Sx2swLcCn16w&ssl=0&token=AOTCm0RgtgrM6lpRdy7yASnedjpL9BHCO4mYdpfWfe6XifwG17ezhCxOQYadJKIITyEzF6Z-ihOthW61UOjraurXqeyoS2VWd-GU-gWMGBs&downloadId=-6463850153931383785
	#http://r3---sn-vgpvopq-jb3e.c.android.clients.google.com/market/GetBinary/com.android.vending/80210006/chzen2II1nK1Sx2swLcCn16w?ms=au&mt=1373980310&mv=m&expire=1374153183&ipbits=0&ip=0.0.0.0&cp=Snp1a2J1Q1g6MjI4MDkyNTE4ODIyNDUwMzUzMjM&sparams=expire,ipbits,ip,q:,cp&signature=BAF0CEF16EFEB23FA2CAB930E5ACDB983270B60D.5EBE4632F00487F6F5E9D7370762434C5AB9782D&key=am2
} elsif ($X[1] =~ m/^http:\/\/.*\.c\.android\.clients\.google\.com\/market\/GetBinary\/([a-zA-Z0-9\-\_\.\%]*)\/([0-9]*)\/.*/){
		print $x . "storeurl://android-apps.SQUIDINTERNAL/$1/$2\n";
} elsif ($X[1] =~ m/^http:\/\/.*\.c\.android\.clients\.google\.com\/market\/GetBinary\/([a-zA-Z0-9\-\_\.\%]*)\/([0-9]*)\?.*/){
		print $x . "storeurl://android-apps.SQUIDINTERNAL/$1/$2\n";

	# APPS APPLE
	# http://a1720.phobos.apple.com/us/r1000/085/Purple2/v4/6b/b9/f1/6bb9f130-d560-0b75-f5e5-16e4fdc1a3c0/mzps5959496558908157977.D2.dpkg.ipa
# refresh_pattern -i phobos\.apple\.com.*ipa 1440 99% 14400 override-expire override-lastmod ignore-no-cache ignore-private reload-into-ims ignore-must-revalidate ignore-reload store-stale
} elsif ($X[1] =~ m/^http:\/\/[a-zA-Z0-9\-\_\.\%]*phobos\.apple\.com\/.*\/([a-zA-Z0-9\-\_\.\%]*\.ipa)/) {
		print $x . "storeurl://apple-apps.SQUIDINTERNAL/$1\n";

        #Speedtest
# acl store_rewrite_list url_regex -i \/speedtest\/.*(jpg|txt|png|swf)
# refresh_pattern -i \/speedtest\/.*(jpg|txt|png|swf)) 1440 99% 14400 override-expire override-lastmod ignore-no-cache ignore-private reload-into-ims ignore-must-revalidate ignore-reload store-stale
} elsif ($X[1] =~ m/^http\:\/\/.*\/speedtest\/([a-zA-Z0-9\-\_\.\%]*\.(jpg|txt|png|swf))\?.*/) {
        print $x . "storeurl://testspeed.SQUIDINTERNAL/" . $1 . "\n";

	##################################################################################
	
	## PORN Movies 
	#http://porn.im.d4628d22.1534715.x.xvideos.com/videos/oldmobile/8/2/b/xvideos.com_82b853581318116942fd41e0e8e4e805.3gp?e=1364299432&ri=1024&rs=85&h=64c9096e902f6a28fbaa18942a4034d4
# acl store_rewrite_list url_regex -i \.xvideos\.com\/.*(3gp|mpg|flv|mp4)
# refresh_pattern -i \.xvideos\.com\/.*(3gp|mpg|flv|mp4) 1440 99% 14400 override-expire override-lastmod ignore-no-cache ignore-private reload-into-ims ignore-must-revalidate ignore-reload store-stale
} elsif ($X[1] =~ m/^http:\/\/.*\.xvideos\.com\/.*\/([a-zA-Z0-9\-\_\.\%]*\.(3gp|mpg|flv|mp4))\?.*/){
		print $x . "storeurl://xvideos.SQUIDINTERNAL/$1\n";

		#http://154.46.32.87/key=5e2qYlZXbj6,end=1364305769/data=18446744072977812770/reftag=5412162/buffer=450K/speed=83200/1/xh/6/1815672_mom_gives_awesome_handjob.flv
# refresh_pattern -i \/xh.*(3gp|mpg|flv|mp4) 1440 99% 14400 override-expire override-lastmod ignore-no-cache ignore-private reload-into-ims ignore-must-revalidate ignore-reload store-stale
} elsif ($X[1] =~ m/^http:\/\/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\/.*\/xh.*\/([a-zA-Z0-9\-\_\.\%]*\.flv)/){
		print $x . "storeurl://Xhamster.SQUIDINTERNAL/$1\n";

	#http://213.174.156.23/key=kDRhok4XZMk,end=1364295197/reftag=5412166/buffer=1M/speed=170987/2/sp/6/repack117226.flv?start=0
} elsif ($X[1] =~ m/^http:\/\/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+.*\/([a-zA-Z0-9\-\_\.\%]*\.flv)\?start=0/){
		print $x . "storeurl://Xhamster2.SQUIDINTERNAL/$1\n";
	
	#http://cdn2b.youjizz.com/videos/4/e/7/e/2/4e7e2b0ce3036.mp4?2792b87c889e01ca3b1a331e03d5a0718c4b4e7d777eff211b92848d3a84590620e5
} elsif ($X[1] =~ m/^http:\/\/.*\.youjizz\.com.*\/([a-zA-Z0-9\-\_\.\%]*\.(mp4|flv|3gp))\?.*/){
		print $x . "storeurl://YouJizz.SQUIDINTERNAL/$1\n";

	#http://cdn1.public.keezmovies.phncdn.com/200810/30/327964/240P_383K_327964.mp4?sr=6000&int=6000000b&nvb=20130327103508&nva=20130327123508&hash=085da11d99756faa95822
} elsif ($X[1] =~ m/^http:\/\/[a-zA-Z0-9\-\_\.\%]*\.keezmovies[a-zA-Z0-9\-\_\.\%]*\.com.*\/([a-zA-Z0-9\-\_\.\%]*\.(mp4|flv|3gp|mpg|wmv))\?.*/){
		print $x . "storeurl://KeezMovies.SQUIDINTERNAL/$1\n";

	#http://cdn1.public.tube8.com/201208/30/5436441/240P_195K_5436441.mp4?sr=3600&int=614400b&nvb=20130327104052&nva=20130327124052&hash=025102b4bdc2b07ec01fd
} elsif ($X[1] =~ m/^http:\/\/[a-zA-Z0-9\-\_\.\%]*\.tube8[a-zA-Z0-9\-\_\.\%]*\.com.*\/([a-zA-Z0-9\-\_\.\%]*\.(mp4|flv|3gp|mpg|wmv))\?.*/) {
		print $x . "storeurl://Tube8.SQUIDINTERNAL/$1\n";

	#http://cdn1b.public.youporn.phncdn.com/200612/02/2865/480p_370k_2865/YouPorn%20-%20very%20good%202Girls%201guy%20hard.mp4?s=1364341242&e=1364427642&ri=600&rs=750&h=fe3d1bfda00e560af0e7fa8cfb60d7b2
} elsif ($X[1] =~ m/^http:\/\/[a-zA-Z0-9\-\_\.\%]*\.youporn[a-zA-Z0-9\-\_\.\%]*\.com.*\/([a-zA-Z0-9\-\_\.\%]*\.(mp4|flv|3gp|mpg|wmv))\?.*/){
		print $x . "storeurl://YouPorn.SQUIDINTERNAL/$1\n";

	#http://cdn1.public.spankwire.phncdn.com/201302/02/709578/240P_300K_709578.mp4?nvb=20130327105920&nva=20130327125920&hash=0c73938b11cee1e872048
} elsif ($X[1] =~ m/^http:\/\/[a-zA-Z0-9\-\_\.\%]*\.spankwire[a-zA-Z0-9\-\_\.\%]*\.com.*\/([a-zA-Z0-9\-\_\.\%]*\.(mp4|flv|3gp|mpg|wmv))\?.*/) {
		print $x . "storeurl://SpankWire.SQUIDINTERNAL/$1\n";

	#http://cdn1b.embed.pornhub.phncdn.com/videos/201102/17/159492/480P_357K_159492.mp4?rs=150&ri=1000&ip=85.112.95.26&s=1364387220&e=1364389020&h=305f8b4ba7973e62a340a2e61dc10868
} elsif ($X[1] =~ m/^http:\/\/[a-zA-Z0-9\-\_\.\%]*\.pornhub[a-zA-Z0-9\-\_\.\%]*\.com.*\/([[a-zA-Z0-9\-\_\.\%]*\.(mp4|flv|3gp|mpg|wmv))\?.*/){
		print $x . "storeurl://PornHub.SQUIDINTERNAL/$1\n";

	#http://v3-xh.clients.cdn13.com/data/1817003.flv?cdn_hash=22591a4c2c98690574bea214ac95618b&cdn_creation_time=1364375095&cdn_ttl=14400
} elsif ($X[1] =~ m/^http:\/\/[a-zA-Z0-9\-\_\.\%\/]*.*\/([a-zA-Z0-9\-\_\.]+\.(flv|mp3|mp4|3gp|wmv))\?.*cdn\_hash.*/){
		print $x . "storeurl://media.SQUIDINTERNAL/$1\n";

	###################################################################################

	## FileHippo
	#http://fs40.filehippo.com/7642/72359c8e25864e74b56e0e922850e803/OriginSetup.exe
	#http://fs41.filehippo.com/7662/0c4cfb998b66473ba1292d6ed807c818/Firefox%20Setup%2020.0b6.exe
} elsif ($X[1] =~ m/^http:\/\/.*filehippo\.com\/.*\/([0-9a-zA-Z\%\.\_\-]+\.(exe|zip|cab|msi|mru|mri|bz2|gzip|tgz|rar|pdf))/){
		$y=$1;
		for ($y) {
			s/%20//g;
		}
		print $x . "storeurl://FileHippo.SQUIDINTERNAL/$y\n";

		#BLOGSPOT
} elsif ($X[1] =~ m/^http:\/\/[1-4]\.bp\.blogspot\.com\/(.*)/) {
        print $x . "storeurl://blogspot.SQUIDINTERNAL/" . $1  . "\n";

		#ytimg
} elsif ($X[1] =~ m/^http:\/\/i[1-4]\.ytimg\.com(.*)/) {
		print $x . "storeurl://ytimg.SQUIDINTERNAL" . $1  . "\n";

		#AVAST
} elsif ($X[1] =~ m/^http:\/\/download[0-9]{3}\.avast\.com\/(.*)/) {
		print $x . "storeurl://avast.SQUIDINTERNAL/" . $1  .  "\n";

		#KAV
} elsif ($X[1] =~ m/^http:\/\/dnl-[0-9]{2}\.geo\.kaspersky\.com\/(.*)/) {
		print $x . "storeurl://kaspersky.SQUIDINTERNAL/" . $1  .  "\n";

		#maps.google.com
} elsif ($X[1] =~ m/^http:\/\/(cbk|mt|khm|mlt|tbn|mw)[0-9]?\.google\.co(m|\.uk|\.id)\/(.*)/) {
        print $x . "storeurl://google.SQUIDINTERNAL/" . $3 . "\n";

		#gstatic and/or wikimapia
} elsif ($X[1] =~ m/^http:\/\/([a-z])[0-9]?(\.gstatic\.com.*|\.wikimapia\.org)\/(.*)/) {
        print $x . "storeurl://wikimapia.SQUIDINTERNAL/" . $3 . "\n";


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
        print $x . "storeurl://" . $1 . $2 . $y . "\n";

		#cache high latency ads
} elsif ($X[1] =~ m/^http:\/\/(.*?)\/(ads)\?(.*?)/) {
        print $x . "storeurl://" . $1 . "/" . $2  . "\n";

} elsif ($X[1] =~ m/^http:\/\/(www\.ziddu\.com.*\.[^\/]{3,4})\/(.*?)/) {
        print $x . "storeurl://" . $1 . "\n";

		#cdn, varialble 1st path
} elsif (($X[1] =~ /filehippo/) && ($X[1] =~ m/^http:\/\/(.*?)\.(.*?)\/(.*?)\/(.*)\.([a-z0-9]{3,4})(\?.*)?/)) {
        @y = ($1,$2,$4,$5);
        $y[0] =~ s/[a-z0-9]{2,5}/cdn./;
        print $x . "storeurl://" . $y[0] . $y[1] . "/" . $y[2] . "." . $y[3] . "\n";

		#rapidshare
} elsif (($X[1] =~ /rapidshare/) && ($X[1] =~ m/^http:\/\/(([A-Za-z]+[0-9-.]+)*?)([a-z]*\.[^\/]{3}\/[a-z]*\/[0-9]*)\/(.*?)\/([^\/\?\&]{4,})$/)) {
        print $x . "storeurl://cdn." . $3 . "/SQUIDINTERNAL/" . $5 . "\n";

} elsif (($X[1] =~ /maxporn/) && ($X[1] =~ m/^http:\/\/([^\/]*?)\/(.*?)\/([^\/]*?)(\?.*)?$/)) {
        print $x . "storeurl://" . $1 . "/SQUIDINTERNAL/" . $3 . "\n";
        
		#domain/path/.*/path/filename
} elsif (($X[1] =~ /fucktube/) && ($X[1] =~ m/^http:\/\/(.*?)(\.[^\.\-]*?[^\/]*\/[^\/]*)\/(.*)\/([^\/]*)\/([^\/\?\&]*)\.([^\/\?\&]{3,4})(\?.*?)$/)) {
        @y = ($1,$2,$4,$5,$6);
        $y[0] =~ s/(([a-zA-A]+[0-9]+(-[a-zA-Z])?$)|([^\.]*cdn[^\.]*)|([^\.]*cache[^\.]*))/cdn/;
        print $x . "storeurl://" . $y[0] . $y[1] . "/" . $y[2] . "/" . $y[3] . "." . $y[4] . "\n";

		#like porn hub variables url and center part of the path, filename etention 3 or 4 with or without ? at the end
} elsif (($X[1] =~ /tube8|pornhub|xvideos/) && ($X[1] =~ m/^http:\/\/(([A-Za-z]+[0-9-.]+)*?(\.[a-z]*)?)\.([a-z]*[0-9]?\.[^\/]{3}\/[a-z]*)(.*?)((\/[a-z]*)?(\/[^\/]*){4}\.[^\/\?]{3,4})(\?.*)?$/)) {
        print $x . "storeurl://cdn." . $4 . $6 . "\n";

		#general purpose for cdn servers. add above your specific servers.
} elsif ($X[1] =~ m/^http:\/\/([0-9.]*?)\/\/(.*?)\.(.*)\?(.*?)/) {
        print $x . "storeurl://squid-cdn-url/" . $2  . "." . $3 . "\n";

} elsif ($X[1] =~ m/^http:\/\/(.*?)(\.[^\.\-]*?\..*?)\/([^\?\&\=]*)\.([\w\d]{2,4})\??.*$/) {
        @y = ($1,$2,$3,$4);
        $y[0] =~ s/([a-z][0-9][a-z]dlod[\d]{3})|((cache|cdn)[-\d]*)|([a-zA-A]+-?[0-9]+(-[a-zA-Z]*)?)/cdn/;
        print $x . "storeurl://" . $y[0] . $y[1] . "/" . $y[2] . "." . $y[3] . "\n";

                        # all that ends with ;
} elsif ($X[1] =~ m/^http:\/\/(.*?)\/(.*?)\;(.*)/) {
        print $x . "storeurl://" . $1 . "/" . $2  . "\n";
		
} else {
		print $x . $X[1] . "\n";
}
# end
}
