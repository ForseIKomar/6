cd "D:\IU6_71\lab2\"
D:
del lab2.map
del lab2.lst
"C:\Program Files\Atmel\AVR Tools\AvrAssembler\avrasm32.exe" -fI "D:\IU6_71\lab2\lab2.asm" -o "lab2.hex" -d "lab2.obj" -e "lab2.eep" -I "D:\IU6_71\lab2" -I "C:\Program Files\Atmel\AVR Tools\AvrAssembler\AppNotes" -w  -m "lab2.map"
