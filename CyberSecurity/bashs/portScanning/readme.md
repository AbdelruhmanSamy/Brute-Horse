### Documentation for Cybersecurity Scripts

#### 1. **Main Script: `scan.sh`**
   This is the main script that orchestrates a full penetration testing workflow on a given target IP address. It runs various tools like `nmap`, `gobuster`, `searchsploit`, and custom scripts to generate a report.

##### **Usage**
```bash
./scan.sh <IP_ADDRESS> [TIME_SPEED] [SCAN_TYPE] [START_PORT] [END_PORT]
```
- `<IP_ADDRESS>`: Target IP to scan.
- `[TIME_SPEED]`: Timing template for scan speed (optional, e.g., `T4` for faster scans).
- `[SCAN_TYPE]`: Type of scan (default: `sS` for TCP SYN scan).
- `[START_PORT]`: Starting port for the scan (default: 1).
- `[END_PORT]`: Ending port for the scan (default: 1000).

##### **Steps Performed**
1. **Nmap Port Scan**: Runs an `nmap` scan using the provided options, writes both console output and XML output, and appends results to the report.
2. **Check Open Web Ports**: Runs a `node` script (`xml_service.js`) to check for open web ports.
3. **Gobuster**: If web ports are open, runs `gobuster` to enumerate directories.
4. **Service Details Extraction**: Uses a `node` script (`xml_service.js`) to extract service details from the XML output.
5. **Searchsploit Search**: Runs `searchsploit` to search for exploits related to the detected services.
6. **NVD Database Search**: Runs a script to check for vulnerabilities in the National Vulnerability Database (NVD).
7. **Report Completion**: A detailed report is saved to a text file.

##### **Output**
- The final report is stored in the `scan_results/scan_report.txt`.

#### 2. **Nmap Script: `nmap.sh`**
   This script handles the `nmap` scan and saves both XML and text output.

##### **Usage**
```bash
./nmap.sh <IP_ADDRESS> [TIME_SPEED] [SCAN_TYPE] [START_PORT] [END_PORT]
```
- **Input Parameters**: Same as the main script (`IP_ADDRESS`, `TIME_SPEED`, `SCAN_TYPE`, `START_PORT`, `END_PORT`).
- **Output**:
  - XML scan results are saved to `scan_results/nmap_scan.xml`.
  - A summary is appended to the main report.

#### 3. **Gobuster Script: `gobuster.sh`**
   This script uses `gobuster` to brute-force directories on open web ports found by `nmap`.

##### **Usage**
```bash
./gobuster.sh <IP_ADDRESS>
```
- **Input**:
  - The `IP_ADDRESS` to target.
  - Reads ports from the file `scan_results/portsOutput.txt`.
- **Output**:
  - For each port, results are saved in `port<PORT>_output.txt`.
  - Gobuster results for each port are appended to the final report.

#### 4. **Searchsploit Script: `searchsploit.sh`**
   This script runs `searchsploit` to search for vulnerabilities related to the services found in the scan.

##### **Usage**
```bash
./searchsploit.sh
```
- **Input**:
  - Reads service names from `scan_results/servicesOutput.txt`.
- **Output**:
  - Results are saved in `scan_results/search_sploit_output.txt`.
  - All search results are appended to the main report.

#### 5. **NVD Vulnerability Search Script: `nvd.sh`**
   This script queries the NVD (National Vulnerability Database) for vulnerabilities based on the services found during the scan.

##### **Usage**
```bash
./nvd.sh
```
- **Input**:
  - Reads services from `scan_results/servicesOutput.txt`.
- **Steps**:
  1. URL-encodes each service name.
  2. Queries the NVD for vulnerabilities.
  3. Extracts `VulnID`, `Description`, and `Link`.
- **Output**:
  - Results are saved to `scan_results/nvd_output.txt`.
  - Vulnerabilities are appended to the main report.

#### 6. **General Workflow**

1. **Initial Setup**: The `scan.sh` script sets up directories and prepares for a penetration test by defining the IP and scanning options.
2. **Running Nmap**: The `nmap.sh` script runs an `nmap` scan on the target IP, outputting results in both XML and text formats.
3. **Service Detection**: Open ports are identified, and services on these ports are extracted.
4. **Gobuster**: If HTTP/HTTPS services are detected, the `gobuster.sh` script brute-forces web directories on the detected web services.
5. **Vulnerability Search**: The `searchsploit.sh` and `nvd.sh` scripts search for known vulnerabilities related to the services found.
6. **Report Generation**: All results are combined into a single readable report stored in `scan_results/scan_report.txt`.

### Dependencies

- **Nmap**: For network scanning.
- **Gobuster**: For directory brute-forcing on web services.
- **Searchsploit**: For searching the Exploit Database for known vulnerabilities.
- **Node.js**: Required for running the `xml_service.js` script for parsing and extracting services from the `nmap` XML output.
- **Curl**: Used in `nvd.sh` to fetch vulnerability data from the NVD website.

### Example Execution
```bash
./scan.sh 192.168.1.1 T4 sS 1 65535
```
This will run a fast SYN scan on all ports (1-65535) on the target IP `192.168.1.1` and generate a penetration testing report in `scan_results/scan_report.txt`.