var UIVisible = false;

$(document).ready(function(){
    window.addEventListener('message', function(event){
        var data = event.data;

        if (data.action === "UpdateUI") {
            updateUI(data);
        }
    });
});

function updateUI(data) {
    if (data.IsActive) {
        if (!UIVisible) {
            $(".container").fadeIn(300);
            UIVisible = true;
        }

        $.each(data.Stock, function(type, stock){
            var parent = $(".hotdogs-stocks").find('[data-stock="'+type+'"]');
            var span = $(parent).find('.stock-amount');
            $(span).html(stock.Current + " / " + (stock.Max[4] || 60));  // Always use max for level 4
        });

        $("#my-level").html('DIKINBAUS CLUB ??');  // Branding footer
    } else {
        $(".container").fadeOut(300);
        UIVisible = false;
    }
}
