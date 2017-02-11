

window.toDos = {};

var ToDo = function( id, selector ){

  this.id = id;
  this.$el = $(selector);
  this.displayHeight = this.$el.height();
  this.editHeight = "20.7rem";
  this.deleteHeight = "5.2rem";
  this.html = $(selector).html();
  window.toDos[id] = this;

};

ToDo.prototype.transitionContent = function( newHTMLContent , setHeight ) {

  _this = this;
  if ( !setHeight ) { setHeight = this.displayHeight };
  this.displayHeight = this.$el.height();
  this.$el.animate( {   
                      height: setHeight 
                     ,queue: false 
                    }
                    , function() { _this.$el.css( { height: "auto" }) }
                  )
  this.$el.children().fadeOut(
    {
      complete: function(){ 
        _this.$el.html( newHTMLContent );
      }
    }
  );

};


ToDo.prototype.cancelEdit = function() {

  this.transitionContent( this.html );

};

ToDo.prototype.insertUpdatedToDo = function( newHTML ) {

  this.transitionContent( newHTML );

};

ToDo.prototype.deleteMe = function() {

  var thisToDo = this
  $.ajax({
    url: "/to_dos/" + this.id ,
    type: "DELETE"
    ,
  success: function() { 
    thisToDo.$el.remove();
    }
  });

};

// ----------------------------------------------------

var deleteToDoConfirm = function(id) {
  
  var storedToDo = new ToDo(id, "div[data_id=" + id + "]");
  deleteConfirmHTML = "<p>Are you sure you want to delete?</p><button onclick='toDos[" + id + "].cancelEdit()'>Cancel</button><button onclick='toDos[" + id + "].deleteMe()'>Yes</button>";
  storedToDo.transitionContent( deleteConfirmHTML, storedToDo.deleteHeight);
  
};

$(document).ready(function() {

   toggleNewToDo();

});

function sortElements(selector, sort_by) {
  
  var el = $(selector)
  var $kids = $(selector).children()

  $kids.sort( function(a,b) {
    var aComparator = a.getAttribute(sort_by);
    var bComparator = b.getAttribute(sort_by);

    if (aComparator < bComparator) { 
      return -1
    } else { 
      return 1
    }
  });

  $kids.detach().appendTo(el);

};

function cancelToDoEdit(toDoID) {
  
  if(toDoID){
    return toDos[toDoID].cancelEdit();
  } else {
   toggleNewToDo();
  }
  
};

function toggleNewToDo() {
  
  $('#add__to_do').children().toggleClass("undisplayed");
  
};

function getLatestToDoTimestamps(){

  $.ajax( {
    url: '/to_dos/latest_timestamps',
    success: function(result) { window.toDoLatestTimestamps = result.timestamps }
  });

};

function getUnsyncedToDos() {

  $.ajax( {
    url: '/to_dos/unsynced_changes',
    data: window.toDoLatestTimestamps
  });

};

function runSyncPolling( bool ) {

  if ( bool ) {
    window.checkSyncInterval = setInterval( getUnsyncedToDos , POLL_INTERVAL )
  } else {
    clearInterval( window.checkSyncInterval )
  };

}