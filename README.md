# Advanced Encryption Standard in VHDL
This project is an implementation of the AES algorithm for fpga. For imformation about the algorith visit: https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.197-upd1.pdf

## How to use
Each encryption has 10 rounds each taking 4 clock cycles.
The 128bit key is defined in hex, to change it from the default value simply modify line 8 of AES_top.vhdl
