$(document).ready(function(){
    $(".agreement_list li").click(function(){
    $(".agreement_list li").removeClass("active");
    $(this).addClass("active");
    });
});

$(document).on("ajax:success","form#edit_agreement_1", function(ev,data){
   console.log(data);
   $("#li-agreement"+data.id).text(data.description);
});