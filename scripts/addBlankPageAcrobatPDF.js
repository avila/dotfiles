/*
Usage:
  1. copy the whole Main() function
  2. CTRL+J in Adobe Acrobat Pro to open JS-debugger (first time: accept the dialog)
  3. paste the Main() function into the console of the JavaScript-Debugger
  4. CTRL+A to select the whole function in JS-Debugger
  5. CTRL+ENTER to submit the code. 
  6. That is it. Print the file or save, or... whatever
*/


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
