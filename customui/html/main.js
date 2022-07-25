var rgbStart = [139,195,74]
var rgbEnd = [183,28,28]

$(function(){
	window.addEventListener('message', function(event) {
		if (event.data.action == "setValue")
		{
			if (event.data.key == "job"){
				setJobIcon(event.data.icon)
			}

			if (event.data.key == "water"){
				setStatus(event.data.key, event.data.value)
			} else if (event.data.key == "hunger"){
				setStatus(event.data.key, event.data.value)
			}
			setValue(event.data.key, event.data.value)

		}
		else if (event.data.action == "id")
		{
			setValue(event.data.key, event.data.value)
		}
		else if (event.data.action == "money")
		{
			setValue(event.data.key, event.data.value)
		}
		else if (event.data.action == "toggle")
		{
			if (event.data.show){
				$('#ui').show();
			} else{
				$('#ui').hide();
			}
		}
	});

});

function setValue(key, value){
	$('#'+key+' span').html(value)
}

function setStatus(status, value){
	document.getElementById(status).value = value;
}

function setJobIcon(value){
	$('#job img').attr('src', 'img/jobs/'+value+'.png')
}

function silentErrorHandler() {return true;}
window.onerror=silentErrorHandler;

$(document).ready(function() {
    window.addEventListener('message', function(event) {
        var data = event.data;
        if (event.data.action == "updateStatus") {
            updateStatus(event.data.status);
        }
    })
})

//API Shit
function colourGradient(p, rgb_beginning, rgb_end)
{
    var w = p * 2 - 1;

    var w1 = (w + 1) / 2.0;
    var w2 = 1 - w1;

    var rgb = [parseInt(rgb_beginning[0] * w1 + rgb_end[0] * w2),
        parseInt(rgb_beginning[1] * w1 + rgb_end[1] * w2),
            parseInt(rgb_beginning[2] * w1 + rgb_end[2] * w2)];
    return rgb;
};
