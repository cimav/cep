$(document).ready(function(){

    $(".button-collapse").sideNav({
        menuWidth: 220, // Default is 300
        edge: 'left', // Choose the horizontal origin
        closeOnClick: true, // Closes side-nav on <a> clicks, useful for Angular/Meteor
        draggable: true, // Choose whether you can drag to open on touch screens,
        onOpen: function(el) {}, // A function to be called when sideNav is opened
      onClose: function(el) { /* Do Stuff */ }, // A function to be called when sideNav is closed
    });


    $('.datepicker').pickadate({
        selectMonths: true, // Creates a dropdown to control month
        selectYears: 9, // Creates a dropdown of 15 years to control year

        // The title label to use for the month nav buttons
        labelMonthNext: 'Mes siguiente',
        labelMonthPrev: 'Mes anterior',

        // The title label to use for the dropdown selectors
        labelMonthSelect: 'Selecciona un mes',
        labelYearSelect: 'Selecciona un año',

        // Months and weekdays
        monthsFull: [ 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre' ],
        monthsShort: [ 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic' ],
        weekdaysFull: [ 'Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado' ],
        weekdaysShort: [ 'Dom', 'Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab' ],

        // Materialize modified
        weekdaysLetter: [ 'D', 'L', 'M', 'X', 'J', 'V', 'S' ],

        // Today and clear
        today: 'Hoy',
        clear: 'Limpiar',
        close: 'Cerrar',

    });

    $('.timepicker').pickatime({
        default: 'now', // Set default time: 'now', '1:30AM', '16:30'
        fromnow: 0,       // set default time to * milliseconds from now (using with default = 'now')
        twelvehour: true, // Use AM/PM or 24-hour format
        donetext: 'OK', // text for done-button
        cleartext: 'Clear', // text for clear-button
        canceltext: 'Cancel', // Text for cancel-button
        autoclose: false, // automatic close timepicker
        ampmclickable: true, // make AM PM clickable
        aftershow: function(){} //Function for after opening timepicker
    });
    $('select').material_select();
    $("select[required]").css({display: "inline", height: 0, padding: 0, width: 0});
    $('.modal').modal();

    $('.dropdown-button').dropdown({
            inDuration: 300,
            outDuration: 225,
            constrainWidth: false, // Does not change width of dropdown to that of the activator
            hover: true, // Activate on hover
            gutter: 0, // Spacing from edge
            belowOrigin: true, // Displays dropdown below the button
            alignment: 'left', // Displays dropdown with edge aligned to the left of button
            stopPropagation: false // Stops event propagation
        }
    );
    $('.collapsible').collapsible();


});

function setHash(hash) {
    window.location.hash = "#!"+hash
}
var actual_url = '';
function checkHash() {
    hash = window.location.hash;
    if (hash.slice(0, 2) == '#!' && hash.length > 3){
        url = "/"+hash.slice(2 - hash.length)
        if (url != actual_url) {
            $.get(url, function (data, status) {
                $('#main-content').html(data);
            });
            actual_url = url
        }
    }else{
        console.log("Error al validar hash");
    }
    if (url != actual_url) {
        if (hash == "#!" || hash == "") {
            goIndex();
            actual_url = url
        }
    }
}
setInterval(checkHash,600);

$(document)

    .on('ajax:beforeSend', '.menu-item', function (evt, data, status, xhr) {
        $('#main-content').html('');
        $('#preloader-agreement').show();
    })

    .on('ajax:success', '.menu-item', function (evt, data, status, xhr) {
        $('#main-content').html(data);
        $(".agreement-list li").removeClass("active");
        setHash($(this).attr("url"));
        $(this).children('li').addClass("active");

    })

    .on('ajax:error', '.menu-item', function (evt, data, status, xhr) {
        Materialize.toast("Error al cargar elemento", 4000)
    })

    .on('ajax:complete', '.menu-item', function (evt, data, status, xhr) {
        $('#preloader-agreement').hide();
    })

;

$(document)

    .on('ajax:beforeSend', '.ajax-item', function (evt, data, status, xhr) {
        $('#preloader-agreement').show();
        $('.tooltipped').tooltip('remove');
    })

    .on('ajax:success', '.ajax-item', function (evt, data, status, xhr) {
        $('#main-content').html(data);
        $(".agreement-list li").removeClass("active");
        setHash($(this).attr("url"));
        $(this).parent().addClass("active");
        $('#preloader-agreement').hide();


    })

    .on('ajax:error', '.ajax-item', function (evt, data, status, xhr) {
        Materialize.toast("Error al cargar elemento", 4000)
        $('#preloader-agreement').hide();

    })

;
$(document)

    .on('ajax:beforeSend', '.ajax-item', function (evt, data, status, xhr) {
        $('#preloader-agreement').show();
        $('.tooltipped').tooltip('remove');
        $('.modal').modal('close');
    })

    .on('ajax:success', '.ajax-item', function (evt, data, status, xhr) {
        $('#main-content').html(data);
        $(".agreement-list li").removeClass("active");
        setHash($(this).attr("url"));
        $(this).parent().addClass("active");
        $('#preloader-agreement').hide();


    })

    .on('ajax:error', '.ajax-item', function (evt, data, status, xhr) {
        Materialize.toast("Error al cargar elemento", 4000)
        $('#preloader-agreement').hide();

    })

;

function goIndex() {
    url = "/dashboard";
    window.location.hash = "#!"
    $.get(url, function (data, status) {
        $('#main-content').html(data);
    });
    refreshMenu();
}

function refreshMenu() {

    url = "/menu-items";
    $.get(url, function (data, status) {
        $('#menu-items').html(data);
    });
}

function refreshFiles(agreement_id) {

    url = "/agreements/"+agreement_id+"/files";
    $.get(url, function (data, status) {
        $('#agreement_files').html(data);
    });
}
