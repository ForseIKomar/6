cd "D:\IU6_71\lab1\"
D:
del lab1.map
del lab1.lst
"C:\Program Files\Atmel\AVR Tools\AvrAssembler\avrasm32.exe" -fI "D:\IU6_71\lab1\lab1.asm" -o "lab1.hex" -d "lab1.obj" -e "lab1.eep" -I "D:\IU6_71\lab1" -I "C:\Program Files\Atmel\AVR Tools\AvrAssembler\AppNotes" -w  -m "lab1.map"
