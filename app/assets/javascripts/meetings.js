$(document)

//---------------------------------------------------
//Carga el show de cada tipo de acuerdo al dar click
//---------------------------------------------------


//------------------------------------------------
//Carga el new de cada tipo de acuerdo en un modal
//------------------------------------------------
    .on('ajax:success', '.agreement-new', function (evt, data, status, xhr) {
        $('#agreement_new .modal-content').html(data);
    })

    .on('ajax:beforeSend', '.agreement-new', function (evt, data, status, xhr) {
        $('#agreement_new .modal-content').html('');
        $('#preloader-new-agreement').show();
        $('#agreement_new').modal('open');
    })

    .on('ajax:complete', '.agreement-new', function (evt, data, status, xhr) {
        $('#preloader-new-agreement').hide();
    })

    .on('ajax:error', '.agreement-new', function (evt, data, status, xhr) {
        Materialize.toast("Error al crear acuerdo", 4000)
        $('#agreement_new').modal('close');
    })

//-------------------------------------
//función genérica para mostrar alertas
//-------------------------------------
    .on("ajax:success","form.alertas", function(ev,data){
        if($(this).hasClass("redirect")){
            setHash(data.redirect_url)
        }
        if($(this).hasClass("refresh")){
            location.reload();
        }
            refreshMenu();


        Materialize.toast(data.message, 4000);
        for (i = 0; i<data.errors.length;i++) {
            Materialize.toast(data.errors[i], 4000);
        }
        // se puede acceder al objeto  por ejemplo data.object.id
    })



//-------------------------------------
//función para mostrar alertas al eliminar archivos
//-------------------------------------
    .on("ajax:success",".delete_file", function(ev,data){

        url = "/agreements/"+$(this).attr("agreement_id")+"/files";
        $.get(url, function (data, status) {
            $('#agreement_files').html(data);
        });

        Materialize.toast(data.message, 4000);
        for (i = 0; i<data.errors.length; i++) {
            Materialize.toast(data.errors[i], 4000);
        }
        // se puede acceder al objeto  por ejemplo data.object.id
    })



;



