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

  $('.hihi').on('click', function(){
    var drop = $(this).parent().find('.dropdown-content');
    if (drop.is(":hidden")) {
    $('.dropdown-content').hide();
      drop.show();
    } else {
      drop.hide();
    }
  })
});
