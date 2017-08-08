$(document)
    .on('ajax:success', '.agreement-item', function (evt, data, status, xhr) {
        $('#agreement-body').html(data)
    }).on('ajax:error', '.agreement-item', function (evt, data, status, xhr) {
        alert('error');
});


$(document).on("ajax:success","form.alertas", function(ev,data){
    Materialize.toast(data.message, 4000)
    // se puede acceder al objeto  por ejemplo data.object.id
});


