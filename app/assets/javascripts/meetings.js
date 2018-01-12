$(document)

//---------------------------------------------------
//Carga el show de cada tipo de acuerdo al dar click
//---------------------------------------------------


//------------------------------------------------
//Carga los documentos de acuerdo en un modal
//------------------------------------------------
    .on('ajax:success', '#documentos-trigger', function (evt, data, status, xhr) {
        $('#modalDocumentos #agreement_files').html(data);
    })

    .on('ajax:beforeSend', '#documentos-trigger', function (evt, data, status, xhr) {
        $('#modalDocumentos #agreement_files').html('');
        $('#preloader-documentos').show();
        $('.tooltipped').tooltip('remove');
        $('#modalDocumentos').modal('open');
    })

    .on('ajax:complete', '#documentos-trigger', function (evt, data, status, xhr) {
        $('#preloader-documentos').hide();
    })

    .on('ajax:error', '#documentos-trigger', function (evt, data, status, xhr) {
        Materialize.toast("Error al mostrar documentos", 4000)
        $('#modalDocumentos').modal('close');
    })


//------------------------------------------------
//Carga el expediente del estudiante en un modal
//------------------------------------------------
    .on('ajax:success', '.expediente-trigger', function (evt, data, status, xhr) {
        $('#modalExpediente #expediente').html(data);
    })

    .on('ajax:beforeSend', '.expediente-trigger', function (evt, data, status, xhr) {
        $('#modalExpediente #expediente').html('');
        $('#preloader-expediente').show();
        $('.tooltipped').tooltip('remove');
        $('#modalExpediente').modal('open');
    })

    .on('ajax:complete', '.expediente-trigger', function (evt, data, status, xhr) {
        $('#preloader-expediente').hide();
    })

    .on('ajax:error', '.expediente-trigger', function (evt, data, status, xhr) {
        Materialize.toast("Error al cargar expediente", 4000)
        $('#modalExpediente').modal('close');
    })



//-------------------------------------
//función al eliminar sesiones o acuerdos
//-------------------------------------
    .on("ajax:success","a.eliminar", function(ev,data){
        if (data.redirect_url == 'home')
            goIndex();
        else
        {
            setHash(data.redirect_url);
            refreshMenu();
        }
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


function setAgreementsDivHeight(){
    var a = $("#agreements-div").height();
    var b = $("#graph-div").height();
    var c = $("#agreements-table").height();
    document.getElementById("agreements-table").style.maxHeight = b - (a-c)+ "px";
}