Main(); 
function Main() {
  
  var nPage = 0;
  var cBox = "Media";
  var aRect = this.getPageBox(cBox, nPage);
  var width = aRect[2] - aRect[0];
  var height = aRect[1] - aRect[3];
  
  var nJump = 1; // skip pages;
  var nStart = this.numPages - (this.numPages % nJump); // compute starting page from the end;
  //set up a loop to jump thru the document
  for (var i = nStart; i > 0; i = i - nJump) {
    //add the new page after page i+1.
    this.newPage({nPage: i, nWidth: width, nHeight: height});
  }
}
