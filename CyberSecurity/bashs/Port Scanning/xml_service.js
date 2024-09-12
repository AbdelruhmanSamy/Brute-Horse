const fs = require('fs');
const { parseString } = require('xml2js');

// Get the argument from CLI
const mode = process.argv[2];  // -c for checking open ports, -t for extracting service details

// File paths
const xmlFile = './scan_results/nmap_scan.xml';  // Replace with your XML file path
const outputFile = './scan_results/output.txt';

// Function to check if ports 80 or 443 are open
function checkOpenPorts(xmlData) {
    const host = xmlData.nmaprun.host[0];
    const ports = host.ports[0].port;
    let openPorts = [];

    ports.forEach(port => {
        const portNumber = port.$.portid;
        const state = port.state[0].$.state;

        if (state === 'open' && (portNumber === '80' || portNumber === '443')) {
            openPorts.push(portNumber);
        }
    });

    // Output the open ports (80 or 443) to the console
    if (openPorts.length > 0) {
        console.log(openPorts.join(' '));
    } else {
        console.log('none');
    }
}

// Function to extract service details of open ports
function extractServiceDetails(xmlData) {
    const host = xmlData.nmaprun.host[0];
    const ports = host.ports[0].port;
    let output = '';

    ports.forEach(port => {
        if (port.state[0].$.state === 'open') {
            const service = port.service[0].$;
            const serviceProduct = service.product.split(" ")[0] || 'N/A';
            const serviceVersion = service.version || 'N/A';

            output += `${serviceProduct} ${serviceVersion}\n`;
        }
    });

    // Write the output to a file
    fs.writeFile(outputFile, output, err => {
        if (err) {
            console.error('Error writing output file:', err);
        } else {
            console.log('Service details written to output.txt');
        }
    });
}

// Read and parse the XML file
fs.readFile(xmlFile, 'utf8', (err, data) => {
    if (err) {
        console.error('Error reading XML file:', err);
        process.exit(1);
    }

    parseString(data, (err, result) => {
        if (err) {
            console.error('Error parsing XML:', err);
            process.exit(1);
        }

        // Run the desired operation based on the CLI argument
        if (mode === '-c') {
            checkOpenPorts(result);
        } else if (mode === '-t') {
            extractServiceDetails(result);
        } else {
            console.error('Invalid argument. Use -c to check open ports or -t to extract service details.');
            process.exit(1);
        }
    });
});
