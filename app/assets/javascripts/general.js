document.addEventListener("turbolinks:load", function() {

    $(".button-collapse").sideNav();


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
        default: 'now',
        twelvehour: true, // change to 12 hour AM/PM clock from 24 hour
        donetext: 'OK',
        darktheme: true,
        autoclose: false,
        formatSubmit: 'HH:i',
        vibrate: true, // vibrate the device when dragging clock hand
        submit:'HH:i'
    });

    $('ul.tabs').tabs('select_tab', 'tab_id');


})

