// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require bootstrap
//= require toastr_rails
//= require_tree .


$(document).ready(function() {
  if ($('.pagination').length) {
    $(window).scroll(function() {
      var url = $('.pagination .next_page').attr('href');
      console.log("out",url && $(window).scrollTop() > $(document).height() - $(window).height() - 50)
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
        console.log("in",url && $(window).scrollTop() > $(document).height() - $(window).height() - 50)
        $('.loader').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />')
        return $.getScript(url);
      }
    });
    return $(window).scroll();
  }
});
