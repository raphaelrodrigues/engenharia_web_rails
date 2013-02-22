$(function ()
{ $("#example").popover();
html: true
});


$(function ()
{ $('#example').typeahead()  ;
});


 
  
  $(document).ready(function () {
               $(".fancybox").fancybox();
                $("button").tooltip({
                  'selector': '',
                  'placement': 'bottom'
                });
               $('.carousel').carousel();

              
              });
           


/*TODO O JAVASCRIPT */

$(window).load(function(){

  $(".sortable1").stupidtable();

  $('.btn-blue').click(function(){
      $(this).toggleClass('loading');
  });


  /*Mudar barra pesquisa*/
  $(document).on("click", ".cat li", function(){ 
    
    alert($(this).val());
    $('#btn-input-category_id').val( $(this).val() );

    $(this).siblings().removeClass('active');
    $(this).addClass('active');
    //alert($('active').val());

    /*onClick="alert($(this).val());$('#btn-input-category_id').val( $(this).val() );"*/
  });


  $(document).on("click", ".tipo li", function(){ 
    
    //alert($(this).val());
    $('#btn-input-tipo').val( $(this).val() );
    
    $(this).siblings().removeClass('active');
    $(this).addClass('active');
    //alert($('active').val());

    /*onClick="alert($(this).val());$('#btn-input-category_id').val( $(this).val() );"*/
  });
  
  

  /* comando ctrl + N para inserir novo anuncio */
  $(document).bind('keydown', function(e) {
      if (e.ctrlKey && e.which === 78  ){
        window.location = "http://localhost:3000/anuncios/new";
        event.preventDefault(); 
      }
  });

  

  $(document).on("click", "#sort11 li a", function(){ 
    //$(this).addClass("active");
    //alert("msd");
    $.getScript(this.href);
    return false;
  });
    

  $("#users_search input").keyup(function() {
    $.get($("#users_search").attr("action"), $("#users_search").serialize(), null,     "script");
    return false;
  });



    window.onscroll = function(){
    if(getScrollTop()>100) {
        document.getElementById("search-section").style.position="fixed";
         document.getElementById("search-section").style.marginTop="-80px";
    } else {
        document.getElementById("search-section").style.position="";
        document.getElementById("search-section").style.marginTop="";
    }
}

  function getScrollTop() {
      if (window.onscroll) {
          // Most browsers
          return window.pageYOffset;
      }

      var d = document.documentElement;
      if (d.clientHeight) {
          // IE in standards mode
          return d.scrollTop;
      }

      // IE in quirks mode
      return document.body.scrollTop;
  }


  });







 var subjects = ['Car Rentals', 'Hotels', 'Cruises', 'Vacations', 'Cheap Vacations', 'Cheap Car Rentals', 'Flights', ];   
$('#search').typeahead({source: subjects})  
 


 var subjects = ['Canada', 'United States', 'Cambodia', 'Caribe', 'France', 'Italy', 'United Kingdom',];   
$('#search2').typeahead({source: subjects})  
 




$().ready(function(){

  $('input.prettyCheckable').prettyCheckable({
    labelPosition: 'right'
  });

  $('input[name=colors]').on('change', function(){

    if ($(this).val() === 'yes') {

      $('div#other-colors').slideDown();

    } else {

      $('div#other-colors').slideUp();

    }

  });



});
