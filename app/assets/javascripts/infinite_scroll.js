$(document).on('ready page:load', function () {
  var isLoading = false;
  if ($('#infinite-scrolling').size() > 0) {
    $(window).on('scroll', function() {
      var more_cards_url = $('.pagination a.next_page').attr('href');
      if (!isLoading && more_cards_url && $(window).scrollTop() > $(document).height() - $(window).height() - 100) {
        isLoading = true;
        $.getScript(more_cards_url).done(function (data,textStatus,jqxhr) {
          isLoading = false;
        }).fail(function() {
          isLoading = false;
        });
      }
    });
  }
});