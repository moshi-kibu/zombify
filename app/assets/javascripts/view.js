function View(){
	this.dataId = $('#feed').data('user-id')
	this.dataInfectedState = $('#feed').data('user-infected')
	this.urlLocation= document.location.href
	this.loginButton = $('#log_in')
	this.signupButton = $('#sign_up')
}

View.prototype = {
	appendFeed: function(html){
		$('#feed').empty()
		$('#feed').prepend(html)
	},
	appendForm: function(response){
		$('#login_signup').remove()
    $('p').remove()
    $('#center').append(response)
	},
	updateOpponentCount: function (opponents){
		$("#opponents_remaining").empty()
		$("#opponents_remaining").text(opponents)
	},
	
	updatePoints: function(points){
		$('#your_points').empty()
		$('#your_points').text(points)
	},
	updateHandle: function(handle){
		$('#handle').empty()
		$('#handle').text(handle)
	},

	hideFooter: function(){
		$('#footer').css('visibility', 'hidden')
	},

	updateStatsAndHandle: function(posts,opponentCount,points,handle) {
		this.appendFeed(posts);
		this.updateOpponentCount(opponentCount);
		this.updatePoints(points);
		this.updateHandle(handle);
	},

	renderZombie: function(){
		//console.log("I am a zombie")
		$("#checkin").css('display', 'none')
		$("#checkin_mobile").css('display', 'none')
		$("#confront").css('display', 'block')
		$("#confront_mobile").css('display', 'block')
	},

	renderHumanHarvest: function(){
		//console.log("I am a human who can harvest")
		$("#confront").css('display', 'none')
		$("#checkin").css('display', 'block')
		$("#confront_mobile").css('display', 'none')
		$("#checkin_mobile").css('display', 'block')
	},

	renderHumanCure: function(){
		//console.log("I am a human who can cure")
		$("#confront").css('display', 'block')
		$("#confront").text("Cure")
		$("#checkin").css('display', 'none')
		$("#confront_mobile").css('display', 'block')
		$("#confront_mobile").text("Cure")
		$("#checkin_mobile").css('display', 'none')
	},

	renderHumanWaiting: function(){
		//console.log("I am a human who is waiting to harvest")
		$("#confront").css('display', 'none')
		$("#checkin").css('display', 'none')
		$("#confront_mobile").css('display', 'none')
		$("#checkin_mobile").css('display', 'none')
	},
}