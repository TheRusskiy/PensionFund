var do_on_load = function() {
    $('#login-link').fancybox();
}
$(document).ready(do_on_load)
$(window).bind('page:change', do_on_load)