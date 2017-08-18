$(document)

//-------------Carga el edit de cada tipo de acuerdo al dar click
    .on('ajax:send', '.agreement-item', function (evt, data, status, xhr) {
        $('#agreement-body').html('')
        $('#preloader-agreement').show();;
    })

    .on('ajax:success', '.agreement-item', function (evt, data, status, xhr) {
        $('#agreement-body').html(data);
    })

    .on('ajax:error', '.agreement-item', function (evt, data, status, xhr) {
        Materialize.toast("Error al cargar acuerdo", 4000)
    })

    .on('ajax:complete', '.agreement-item', function (evt, data, status, xhr) {
        $('#preloader-agreement').hide();
    })

//-------------Carga el new de cada tipo de acuerdo en un modal
    .on('ajax:success', '.agreement-new', function (evt, data, status, xhr) {
        $('#agreement_new .modal-content').html(data);
    })

    .on('ajax:beforeSend', '.agreement-new', function (evt, data, status, xhr) {
        $('#agreement_new .modal-content').html('');
        $('#preloader-new-agreement').show();;
        $('#agreement_new').modal('open');
    })

    .on('ajax:complete', '.agreement-new', function (evt, data, status, xhr) {
        $('#preloader-new-agreement').hide();
    })

    .on('ajax:error', '.agreement-new', function (evt, data, status, xhr) {
        Materialize.toast("Error al crear acuerdo", 4000)
        $('#agreement_new').modal('close');
    })

//-------------función genérica para mostrar alertas
    .on("ajax:success","form.alertas", function(ev,data){
        Materialize.toast(data.message, 4000)
        // se puede acceder al objeto  por ejemplo data.object.id
    })
;


