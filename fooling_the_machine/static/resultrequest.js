function preload(){
  console.log("print");
  setInterval(function(){
    $.ajax({url: "/ask", success: function(response){

        console.log(response.result);
    }});
  }, 3000);
}

function setup(){

}

function draw(){

}
