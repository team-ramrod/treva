######################
#  Compiler options  #
######################
GHDL = ghdl
GHDL_FLAGS += --ieee=synopsys --warn-no-vital-generic
GHDL_SIM_FLAGS +=

WAVEFORM_VIEWER = gtkwave

-include local.mk

#################
#  Directories  #
#################
SRC_DIR = src
BUILD_DIR = build
WAVEFORM_DIR = waves
WORK_LIB = work


#################
#  Testbenches  #
#################
TESTBENCHES += d_flipflop_tb
GHDL_SIM_FLAGS_d_flipflop_tb = --stop-time=500ns


###############
#  Internals  #
###############
SRC_FILES = $(wildcard $(SRC_DIR)/*)

all: $(addprefix $(BUILD_DIR)/,$(TESTBENCHES))

test:
	@make -ks clean $(addprefix test-,$(TESTBENCHES)) clean

clean:
	$(GHDL) --clean --workdir=$(BUILD_DIR)
	-rm -f $(addprefix $(BUILD_DIR)/,$(TESTBENCHES))

$(BUILD_DIR) $(WAVEFORM_DIR):
	@mkdir -p $@

$(BUILD_DIR)/%: tests/%.vhd $(BUILD_DIR)
	$(GHDL) -i $(GHDL_FLAGS) --workdir=$(BUILD_DIR) --work=$(WORK_LIB) $< $(SRC_FILES)
	$(GHDL) -m $(GHDL_FLAGS) --workdir=$(BUILD_DIR) --work=$(WORK_LIB) $*
	@mv $* $@

test-%: $(BUILD_DIR)/%
	@echo
	$< $(GHDL_SIM_FLAGS) $(GHDL_SIM_FLAGS_$*) 2>&1

$(WAVEFORM_DIR)/%.vcdgz: $(BUILD_DIR)/% $(WAVEFORM_DIR)
	$< $(GHDL_SIM_FLAGS) $(GHDL_SIM_FLAGS_$*) --vcdgz=$(WAVEFORM_DIR)/$*.vcdgz

view-%: $(WAVEFORM_DIR)/%.vcdgz
	gunzip --stdout $< | $(WAVEFORM_VIEWER) --vcd

.PRECIOUS: $(WAVEFORM_DIR)/%.vcdgz $(BUILD_DIR)/%
.PHONY: view-% test-% all test clean
