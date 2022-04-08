function zegarekHeader() {
    var today = new Date();

    var h = today.getHours();
    var m = today.getMinutes();
    var s = today.getSeconds();

    m = checkTime(m);
    s = checkTime(s);

    document.getElementById('txt').innerHTML = h + ":" + m + ":" + s;

    var t = setTimeout(zegarekHeader, 500);
}

function checkTime(i) {
  if (i < 10)
  {
      i = "0" + i
  };
return i;
}

function myMove() {
  var elem = document.getElementById("anim");   
  var pos = 0;

    if(x==0) {
        var id = setInterval(frame, 10);
      function frame() {
        if (pos == -18) {
          document.getElementById("wolnePokojeWynik").style.background = "lightgray";
          x=1;
          clearInterval(id);
        }
        else {
          pos--; 
          elem.style.top = pos + "vh"; 
      }
    }
  }
}