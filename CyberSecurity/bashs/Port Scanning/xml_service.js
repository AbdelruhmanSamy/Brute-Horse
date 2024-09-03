const fs = require('fs');
const { parseString } = require('xml2js');

// Read the XML file
const xmlFile = './scan_results/nmap_scan.xml'; // Replace with your XML file path
const outputFile = './scan_results/output.txt';

// Parse the XML file
fs.readFile(xmlFile, 'utf8', (err, data) => {
    if (err) {
        console.error('Error reading XML file:', err);
        return;
    }

    parseString(data, (err, result) => {
        if (err) {
            console.error('Error parsing XML:', err);
            return;
        }

        const host = result.nmaprun.host[0];
        const ports = host.ports[0].port;

        let output = '';

        ports.forEach(port => {
            if (port.state[0].$.state==="open")
            {
            const service = port.service[0].$;
            const serviceDetails = `${service.product || 'N/A'} ${service.version || 'N/A'}`;
            output += serviceDetails + '\n';
        }
        });

        // Write the output to a file
        fs.writeFile(outputFile, output, err => {
            if (err) {
                console.error('Error writing output file:', err);
            } 
        });
    });
});
