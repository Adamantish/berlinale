$(document).ready( function() {

  $('#btn--search').addClass('undisplayed');
  $('#container--search-results').addClass('undisplayed');
  
  $('body').css("opacity", "1")
});

function initMap() {

  window.POLL_INTERVAL = 2000
  window.markers = [];
  window.map = new google.maps.Map($('#map-canvas')[0], {} );
  window.map.toDos = $('#map-canvas').data('toDos');
  window.map.latlngbounds = new google.maps.LatLngBounds();

  if ( window.map.toDos.length > 0 ) { resetMarkers() }
  
  initProcesses();
  initEventListeners();

};

function initEventListeners() {

  map.addListener("idle", showToDosInBounds);
  
  window.$body = $('body')
  $body.click( hideGreetingAndUnblur )

  var $searchInput = $('#search')

  $searchInput.blur( function() {
    $('#container--search-results').addClass('undisplayed');
  });

  $searchInput.keyup( function(e){ 
      if( e.keyCode == 13 ) {
        $('#search').blur();
      } else {
        return makeSearch(e);
      };
    } 
  );

  $('#destination__search-opts').on("change", function() {
    var dest_id = $("#destination__search-opts").val();
    showOnlyMarkersFor("destination_id", dest_id);
  });

  $('#select--sort-to_dos').on("change", function(e){
    sortElements("#to_dos", $(e.target).val());
  });

  window.onfocus = function() { runSyncPolling( true ) };
  window.onblur = function() { runSyncPolling( false ) };

};

function initProcesses(){

  getLatestToDoTimestamps();

  runSyncPolling( true );
};

function hideGreetingAndUnblur(){

  $('#greetings').hide();
  $blurContainer = $('#blur-container')
  // Setting this listener here instead of the initialising function to avoid a second jquery selection.
  $blurContainer.on('transitionend webkitTransitionEnd oTransitionEnd', function() {
    $bucket = $('#bucket')
    $bucket.css("top","2px").unwrap();
  })
  $blurContainer.css("-webkit-filter","blur(0px) brightness(1)");


};