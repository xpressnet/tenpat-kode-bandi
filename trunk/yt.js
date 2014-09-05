var tscan=null;
var player=null;
function checkPlayerReady(){
	try{
		if(document.getElementById('movie_player') != null){
			player=document.getElementById('movie_player');
		}else if(document.getElementById('player1') != null){
			player=document.getElementById('player1');
		}else if(document.getElementById('player2') != null){
			player=document.getElementById('player2');
		}
		console.log("check "+player);
		if(player.getPlayerState() !=-1){
			return true;
		}else {return false;}
	}catch(e){return false;}
}
function checkQuality(qly){
	try{
		console.log("Vid Quality "+player.getPlaybackQuality());
		if(player.getPlaybackQuality() != qly){
			return false;
		}else {return true;}
	}catch(e){return true;}
}

var tScan = setInterval(function() {	
	if(checkPlayerReady()) {
		if (!checkQuality("small")){
			console.log("i\'m running");
			player.pauseVideo();
			player.setPlaybackQuality("small");
			player.playVideo();
		}
		clearInterval(tScan);
	}	}, 100);
