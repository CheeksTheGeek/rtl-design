# Project name variable
PROJECT = odd-even-transposition-sorter

# Directories
SRC_DIR = src
BUILD_DIR = build
DUMP_DIR = dump
CONFIG_DIR = config
GTKWAVE_CONFIG_FILE = $(CONFIG_DIR)/wave.gtkw
VCD_FILE = $(DUMP_DIR)/$(PROJECT).vcd

# Verilog files
SRCS = $(wildcard $(SRC_DIR)/*.v $(SRC_DIR)/*.sv)

# Build output
OUT_FILE = $(BUILD_DIR)/$(PROJECT).out

default: all

# Ensure directories are created
.PHONY: dirs
dirs:
	@mkdir -p $(BUILD_DIR) $(DUMP_DIR) $(CONFIG_DIR)

# Automatically inject $dumpfile and $dumpvars into the top_module
.PHONY: inject_vcd
inject_vcd:
	@for file in $(SRCS); do \
		if grep -q "module top_module" $$file; then \
			sed -i '' '/module top_module/a\'$$'\n''initial begin \$$dumpfile("$(VCD_FILE)"); \$$dumpvars(0, top_module); end'$$'\n    ' $$file; \
		fi; \
	done

# Remove the injected $dumpfile and $dumpvars after running the simulation
.PHONY: remove_vcd_injection
remove_vcd_injection:
	@for file in $(SRCS); do \
		if grep -q "initial begin \$$dumpfile" $$file; then \
			sed -i '' '/initial begin \$$dumpfile/,+d' $$file; \
		fi; \
	done

# Compile with iverilog
$(OUT_FILE): $(SRCS) inject_vcd | dirs
	iverilog -g2012 -Y.sv -y $(SRC_DIR) -I $(SRC_DIR) -o $@ $(SRCS)

# Run simulation with vvp and generate VCD, then remove injected lines
.PHONY: run
run: $(OUT_FILE)
	vvp $(OUT_FILE) -l $(DUMP_DIR)/$(PROJECT).log
	$(MAKE) remove_vcd_injection

# Open the VCD file in gtkwave, with config if it exists
.PHONY: gtkwave
gtkwave: run
	@if [ -f $(GTKWAVE_CONFIG_FILE) ]; then \
		gtkwave $(VCD_FILE) $(GTKWAVE_CONFIG_FILE); \
	else \
		gtkwave $(VCD_FILE); \
	fi

# Clean the build and dump directories
.PHONY: clean
clean:
	rm -rf $(BUILD_DIR) $(DUMP_DIR)

all: gtkwave