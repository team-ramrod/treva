# Assembler files
APPS = dm_count count blink ghost hello echo led_buttons

# The VHDL project for Quartus
QPROJ=altde2-70
QPROJ=dspio

all: $(addsuffix .vhd,$(addprefix vhdl/generated/,$(APPS)))

tools:
	java -classpath lib/antlr-3.3-complete.jar org.antlr.Tool -fo java/tools/src/leros/asm/generated java/tools/src/grammar/Leros.g
	javac -classpath lib/antlr-3.3-complete.jar -d java/tools/classes java/tools/src/leros/asm/generated/*.java java/tools/src/leros/asm/*.java
	javac -d java/tools/classes -sourcepath java/tools/src java/tools/src/leros/sim/*.java
	cd java/tools/classes && jar cf ../lib/leros-tools.jar *

vhdl/generated/%.vhd: asm/%.asm
#	java -cp java/tools/lib/leros-tools.jar:lib/antlr-3.3-complete.jar leros.asm.LerosAsm -s asm -d vhdl/generated $*.asm
#	@mv vhdl/generated/leros_rom.vhd vhdl/generated/$*-leros.vhd
	bash -c '../bin/as $< >( ../bin/vhdliser > $@ ) || rm $@'

clean:
	rm -f $(addsuffix .vhd,$(addprefix vhdl/generated/,$(APPS)))
