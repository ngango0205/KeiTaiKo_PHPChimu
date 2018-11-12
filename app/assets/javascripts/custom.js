$(window).on('load', function () {
	var showPopupBought = function() {
	    $('#popup-alert').addClass('show');
	    setTimeout(function() {
	      $('#popup-alert').removeClass('show');
	    },5000)
	}

	$('.close-poup').on('click', function(){
		$('#popup-alert').removeClass('show');
	});

	$('#btn-full-page-search').on('click', function(){
		$('#full-page-search').addClass('open');
	});

	$('#full-page-search .close').on('click', function(){
		$('#full-page-search').removeClass('open');
	});

	showPopupBought();
});

function myFunction() {
    document.getElementById("myDropdown").classList.toggle("show");
}

// Close the dropdown if the user clicks outside of it
window.onclick = function(event) {
  if (!event.target.matches('.dropbtn')) {

    var dropdowns = document.getElementsByClassName("dropdown-content");
    var i;
    for (i = 0; i < dropdowns.length; i++) {
      var openDropdown = dropdowns[i];
      if (openDropdown.classList.contains('show')) {
        openDropdown.classList.remove('show');
      }
    }
  }
}
