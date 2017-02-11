"use strict";

function resetMarkers(){

    clearMarkers();
    addMarkers(window.map.toDos);

};

function addMarker(lat, lng, title, id) {

  var myLatLng = new google.maps.LatLng(lat, lng);
  var marker = new google.maps.Marker({

    position: myLatLng,
    title: title,
    id: id,
    map: window.map

  });

  markers.push(marker);
  window.map.latlngbounds.extend(myLatLng);
  // marker.addListener("click", function() { showModal(toDo)});
  fitMapToMarkers();

};

function addMarkers(newToDos) {

    _(newToDos).each(function(toDo) {
      addMarker(toDo.lat, toDo.lng, toDo.description, toDo.id);
    });

}

function fitMapToMarkers() {

  map.fitBounds(map.latlngbounds);

  if ( map.zoom > 12 ){ map.setZoom(12); }

  map.setCenter(map.latlngbounds.getCenter())   ;

};

function clearMarkers() {

  for (var i = 0; i < markers.length; i++) {
    markers[i].setMap(null);
  }
  map.latlngbounds = new google.maps.LatLngBounds()
  markers = [];

};

function showOnlyMarkersFor(criteriaType, criteria){

  clearMarkers();

  var filteredToDos = map.toDos.filter(function(toDo) {
    if ( criteriaType == "destination_id" ) {
      return toDo.destination_id == criteria;
    } else if ( criteriaType == "toDo_ids") {
      return criteria[toDo.id]
    };
  });

  addMarkers(filteredToDos);
  showToDosInBounds();

};

function showToDosInBounds() {

  map.toDos.forEach(function(toDo) {
    var $foundItem = $("div[data_id=" + toDo.id + "]")
    var marker = markers.filter( function (marker) {
      return marker.id == toDo.id;
    })[0];

    $foundItem.addClass("undisplayed");

    if ( !marker ) { return }

    var inBounds = map.getBounds().contains(marker.getPosition())
    
    if ( inBounds ){
      $foundItem.removeClass("undisplayed");
    }

  });
};
