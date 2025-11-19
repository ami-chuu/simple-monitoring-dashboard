# Simple Monitoring Dashboard
Basic monitoring dashboard using Netdata.
[Roadmap.sh project page](https://roadmap.sh/projects/simple-monitoring-dashboard)
## Installation
```
git clone https://github.com/ami-chuu/simple-monitoring
cd simple-monitoring
chmod +x setup.sh
./setup.sh
```
During installation you can choose:
* Automatic updates
* Nightly or Stable releases
* To send telemetry
* To connect to Netdata Cloud
## Stress-testing
For testing the dashboard use this script <br>
60 sec stressing CPU, Memory and Disk I/O <br>
Dependence: stress-ng
```
cd simple-monitoring
chmod +x test_dashboard.sh
./test_dashboard.sh
```
## Cleaning Up
```
cd simple-monitoring
chmod +x cleanup.sh
./cleanup.sh
```
