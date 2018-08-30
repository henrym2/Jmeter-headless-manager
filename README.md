# Jmeter-Headless-manager

[![N|Solid](https://bit.ly/2PjZaMu)](https://nodesource.com/products/nsolid)

A simple Apache Jmeter CLI app which trivialises the running of pre-written test scripts and the recoreding of their associated results.

Written to be used particularly by those with little programming or command line experience.  

  - Retrieves a list of finished, repeatable .jmx tests.
  - Can be called to run all tests in a sequence. 
  - Provides a timestamp on each output file and compiled results folder. 
  - Configurable directly from the CLI or from the associated config.txt.

# Planned features

  - Semi-parallel testing if the machine is capable.
  - Optional binary instead of a .bat file (GO/Python/C++)
  - Additional configuration options within the CLI.
  - Potential room for running tests off of a machine pool (To be investigated)

### Installation

Aquire a copy of the bat-file.  
Setup locations for the script/output folders.  
Setup directions to the Jmeter bin folder (default is **C:\apache-jemter-4.0\bin**)  

```cmd
C:\> cd <Jmeter-Headless-manager filepath>"jemter testing.bat"
```
