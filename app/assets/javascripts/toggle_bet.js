function toggleblock(betID)
  {
    var shown = document.getElementById("content_"+betID).style.display == "block";
    var summary = document.getElementById("summary_"+betID);
    var content = document.getElementById("content_"+betID);
    if (shown == false) {
      content.style.display = "block";
      summary.style.borderBottomRightRadius = "0";
      summary.style.borderBottomLeftRadius = "0";
    }
    else {
      content.style.display = "none";
      summary.style.borderBottomRightRadius = "10px";
      summary.style.borderBottomLeftRadius = "10px";
    }
  }