#!/usr/bin/perl
# ISI DARI STORE-ID DIBAWAH INI DARI SHUDY
# SHUDYLAH BERBAGI ILMU :3
# ucok_karnadi(at)yahoo.com or https://twitter.com/syaifuddin_jw

$|=1;
while (<>) {
@X = split;

if ( $X[0] =~ m/^http\:\/\/.*/) {
$x = $X[0];
$_ = $X[0];
$u = $X[0];
} else {
$x = $X[1];
$_ = $X[1];
$u = $X[1];
}

if ($x =~ m/^http\:\/\/.*(youtube|google).*(videoplayback|liveplay).*/){
        @itag = m/[&?](itag=[0-9]*)/;
        @id = m/[&?](id=[^\&]*)/;
        @range = m/[&?](range=[^\&\s]*)/;
        @begin = m/[&?](begin=[^\&\s]*)/;
        @redirect = m/[&?](redirect_counter=[^\&]*)/;
        $out="http://video-srv.youtube.com.squid.internal/@id&@itag&@range@begin@redirect";

} elsif ($x =~ m/^http\:\/\/.*(profile|photo|creative).*\.ak\.fbcdn\.net\/((h|)(profile|photos)-ak-)(snc|ash|prn)[0-9]?(.*)/) {
        $out="http://fbcdn.net.squid.internal/" . $2  . "fb" .  $6  ;

} elsif ($x =~ m/^http:\/\/i[1-4]\.ytimg\.com\/(.*)/) {
        $out="http://ytimg.com.squid.internal/" . $1 ;

} elsif ($x =~ m/^http:\/\/.*\.dl\.sourceforge\.net\/(.*)/) {
          $out="http://dl.sourceforge.net.squid.internal/" . $1 ;

                #Speedtest
} elsif ($x =~ m/^http\:\/\/.*\/speedtest\/(.*\.(jpg|txt)).*/) {
        $out="http://speedtest.squid.internal/" . $1 ;
       
                #BLOGSPOT
} elsif ($x =~ m/^http:\/\/[1-4]\.bp\.(blogspot\.com.*)/) {
        $out="http://blog-cdn." . $1  ;

                #AVAST
} elsif ($x =~ m/^http:\/\/download[0-9]{3}.(avast.com.*)/) {
          $out="http://avast-cdn." . $1  ;

              #AVAST
} elsif ($x =~ m/^http:\/\/[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\/(iavs.*)/) {
        $out="http://avast-cdn.avast.com/" . $1  ;

        #KAV
} elsif ($x =~ m/^http:\/\/dnl-[0-9]{2}.(geo.kaspersky.com.*)/) {
          $out="http://kav-cdn." . $1  ;

                #AVG
} elsif ($x =~ m/^http:\/\/update.avg.com/) {
          $out="http://avg-cdn." . $1  ;

                #maps.google.com
} elsif ($x =~ m/^http:\/\/(cbk|mt|khm|mlt|tbn)[0-9]?(.google\.co(m|\.uk|\.id).*)/) {
        $out="http://" . $1  . $2 ;

                #gstatic and/or wikimapia
} elsif ($x =~ m/^http:\/\/([a-z])[0-9]?(\.gstatic\.com.*|\.wikimapia\.org.*)/) {
        $out="http://" . $1  . $2 ;

                #maps.google.com
} elsif ($x =~ m/^http:\/\/(khm|mt)[0-9]?(.google.com.*)/) {
        $out="http://" . $1  . $2 ;
       
                #Google
} elsif ($x =~ m/^http:\/\/www\.google-analytics\.com\/__utm\.gif\?.*/) {
        $out="http://www.google-analytics.com/__utm.gif\n";

} elsif ($x =~ m/^http:\/\/(www\.ziddu\.com.*\.[^\/]{3,4})\/(.*?)/) {
        $out="http://" . $1 ;

                #cdn, varialble 1st path
} elsif (($x =~ /filehippo/) && (m/^http:\/\/(.*?)\.(.*?)\/(.*?)\/(.*)\.([a-z0-9]{3,4})(\?.*)?/)) {
        @y = ($1,$2,$4,$5);
        $y[0] =~ s/[a-z0-9]{2,5}/cdn./;
        $out="http://" . $y[0] . $y[1] . "/" . $y[2] . "." . $y[3] ;

                #rapidshare
} elsif (($x =~ /rapidshare/) && (m/^http:\/\/(([A-Za-z]+[0-9-.]+)*?)([a-z]*\.[^\/]{3}\/[a-z]*\/[0-9]*)\/(.*?)\/([^\/\?\&]{4,})$/)) {
        $out="http://cdn." . $3 . "/squid.internal/" . $5 ;

                #for yimg.com video
} elsif ($x =~ m/^http:\/\/(.*yimg.com)\/\/(.*)\/([^\/\?\&]*\/[^\/\?\&]*\.[^\/\?\&]{3,4})(\?.*)?$/) {
        $out="http://cdn.yimg.com/" . $3 ;
       
                #for yimg.com doubled
} elsif ($x =~ m/^http:\/\/(.*?)\.yimg\.com\/(.*?)\.yimg\.com\/(.*?)\?(.*)/) {
        $out="http://cdn.yimg.com/"  . $3 ;

                #for yimg.com with &sig=
} elsif ($x =~ m/^http:\/\/([^\.]*)\.yimg\.com\/(.*)/) {
        @y = ($1,$2);
        $y[0] =~ s/[a-z]+([0-9]+)?/cdn/;
        $y[1] =~ s/&sig=.*//;
        $out="http://" . $y[0] . ".yimg.com/"  . $y[1] ;
                       
} else {
        $out=$x;

}
if ( $X[0] =~ m/^http\:\/\/.*/) {
 print "OK store-id=$out\n" ;
} else {
 print $X[0] . " OK store-id=$out\n" ;
}
}