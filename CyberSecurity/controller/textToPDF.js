const fs = require("fs")
const pdfDocument = require("pdfkit")
function cleanText(text) {
    return text.replace(/[^\x20-\x7E]+/g, '  ').replace(/\s{2,}/g, '   ').trim();
  }
  
function convertTextToPDF(inputFile, outputFile,title) {
    const doc = new pdfDocument()
    doc.pipe(fs.createWriteStream(outputFile))
    fs.readFile(inputFile, 'utf8', (err, data) => {
        if (err) {
            console.error('Error reading the text file:', err);
            return;
        }
        doc.fontSize(24).text(title, { align: 'center',margin:"20px" });//add title

        const lines = data.split('\n');
        lines.forEach(line=>{
            const convertedText=cleanText(line)
            doc.fontSize(12).text(convertedText, {
                align: 'left',
                continued: false
              });
        })
        doc.end()
    })
    
}
module.exports=convertTextToPDF