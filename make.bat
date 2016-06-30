@echo off

set name="princess"

set path=%path%;..\bin\


..\compiler\bin\cc65 -Oi %name%.c --add-source
..\compiler\bin\ca65 reset.s
..\compiler\bin\ca65 %name%.s
..\compiler\bin\ca65 asm4c.s

..\compiler\bin\ld65 -C nes.cfg -o %name%.nes reset.o %name%.o asm4c.o nes.lib

del *.o

pause

%name%.nes