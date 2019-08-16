# Cmake Cross-deivce project question

This project doesn't contain any userfull or even workable code
I've created it to understand how to use CMake in that case.


## Structure
    We have embedded-device code, which should be compiled by cross-compiler.
    And we have code for PC for communication with device.
    Also we have some shared code, which used for PC and for device.
  
  - MinGCC - contains data, nessessary to compile device code. Binaries were packed with UPX to reduce size
-  MSVC - containt Microsoft Visual Studio project files
- SRC - here comes source files
    - CommonCode - contains shared code
    - DeviceLib - contains device library code
    - DeviceProject - contains device app code
    - PCProject - contains PC code

  *DeviceLib* and *DeviceProject* contains *.bat-file to compile them

## Question

   Solution in *MSVC* directory contains 3 projects.\
   One of them (*PCAppProject*) uses native MSVC compilers.\
   And other 2 (*DeviceLib* and *DeviceProject*) uses GCC-compiler via *.bat-file.\
   **!** So I can edit code for PC and for device in one IDE and compile them at once by pressing F7 hotkey.

   **?** How do i use CMake to generate similar projects **?**

## Note
    Device code shouldn't use *.bat-files for compile, if it is possible.
