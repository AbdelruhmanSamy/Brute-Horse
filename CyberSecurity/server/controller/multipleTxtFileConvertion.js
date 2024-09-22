const fs = require("fs");
const pdfDocument = require("pdfkit");

function cleanText(text) {
    return text.replace(/[^\x20-\x7E]+/g, '  ').replace(/\s{2,}/g, '   ').trim();
}

function convertMultipleTextToPDF(inputFiles, outputFile,titles, title, callback) {
    const doc = new pdfDocument();
    const writeStream = fs.createWriteStream(outputFile);

    // Pipe the PDF output to the write stream
    doc.pipe(writeStream);

    let filesProcessed = 0; // Track processed files
     // Add title for each file in the PDF
     doc.fontSize(28).text(`${title} `, { align: 'center', margin: "20px" });
     doc.moveDown(); // Add some space before the content
    inputFiles.forEach((inputFile, index) => {
        fs.readFile(inputFile, 'utf8', (err, data) => {
            if (err) {
                console.error('Error reading the text file:', err);
                callback(err); // Pass the error to the callback
                return;
            }

            // Add title for each file in the PDF
            doc.fontSize(24).text(`${titles[index]} `, { align: 'center', margin: "20px" });
            doc.moveDown(); // Add some space before the content

            const lines = data.split('\n');
            lines.forEach(line => {
                const convertedText = cleanText(line);
                doc.fontSize(12).text(convertedText, {
                    align: 'left',
                    continued: false
                });
            });

            // Add a new page after each file's content
            doc.addPage();

            // Delete the text file after reading
            fs.unlink(inputFile, (unlinkErr) => {
                if (unlinkErr) {
                    console.error('Error deleting the text file:', unlinkErr);
                }
                filesProcessed++;

                // Check if all files have been processed
                if (filesProcessed === inputFiles.length) {
                    doc.end(); // Finalize the PDF
                    callback(null); // Indicate success
                }
            });
        });
    });

    // When the write stream is finished, call the callback
    writeStream.on('finish', () => {
        console.log('PDF generated successfully!');
    });
}

module.exports = convertMultipleTextToPDF;
