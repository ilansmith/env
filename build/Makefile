export PROJECT_NAME:=kunit
export THIS_MAKEFILE_PATH:=$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
export PROJECT_PATH:=$(shell cd $(dir $(THIS_MAKEFILE_PATH));pwd)
export KERNEL_PATH:=$(PROJECT_PATH)/kernel
export RUNTIME_PATH:=$(KERNEL_PATH)/runtime
export UNIT_TEST_PATH:=$(PROJECT_PATH)/ut
export COVERITY_PATH:=$(PROJECT_PATH)/.coverity
export COVERITY_ANALYSIS_PATH:=$(COVERITY_PATH)/analysis
export COVERITY_FORMATTING_PATH:=$(COVERITY_PATH)/formatting

# kernel include paths
export INCLUDES:=$(PROJECT_PATH)/core \
	$(patsubst %,$(KERNEL_PATH)/%, \
		patches/include \
		emu/lnx/include \
		emu/kut/include)

PHONY+=clean cleanall ut vsupp

APP:=kunit
BUILD_REC:=-f $(PROJECT_PATH)/mk.rec

libkernel_path:=kernel/emu
libcore_path:=core

all: $(APP)

include mk.build

define help_print_tool
  @printf "\033[1m%-10s\033[0m - %s.\n" $1 $2
endef

help:
	@printf "Usage:\n"
	@printf "     $$ \033[1mmake [target]\033[0m\n"
	@printf "\n"
	@printf "Where 'target' is one of:\n"
	$(call help_print_tool,"$(APP)","build $(APP) [default target]")
	$(call help_print_tool,"valgrind","run $(APP) with valgrind")
	$(call help_print_tool,"cov","run coverity static analysis")
	$(call help_print_tool,"clean","clean object files and libraries")
	$(call help_print_tool,"cleanall","clean everything")

ut:
	$(MAKE) -C $(UNIT_TEST_PATH) $(BUILD_REC) built-in.o

$(APP): ut libcore libkernel
	$(GCC) $(UNIT_TEST_PATH)/built-in.o $(LDFLAGS) -lcore -lkernel -lm -o $@

vsupp:
	$(MAKE) -C $(UNIT_TEST_PATH) $(BUILD_REC) vsupp

valgrind: $(APP) vsupp
	@valgrind \
		--leak-check=full \
		--show-leak-kinds=definite,indirect,possible,reachable \
		--track-origins=yes \
		$(patsubst %,--suppressions=$(UNIT_TEST_PATH)/%, \
			$(shell cat $(UNIT_TEST_PATH)/built-in.supp)) \
		./$(APP)

cov:
	@echo "executing cov-build..."; \
		cov-build --dir $(COVERITY_ANALYSIS_PATH) make
	@echo "executing cov-analyze..."; \
		cov-analyze --dir $(COVERITY_ANALYSIS_PATH) --all
	@echo "executing cov-format-errors..."; \
		cov-format-errors --dir $(COVERITY_ANALYSIS_PATH) --html-output $(COVERITY_FORMATTING_PATH)
	@echo "\ncreating link to analysis: coverity.html..."; \
		ln -sf $(COVERITY_FORMATTING_PATH)/index.html coverity.html

clean:
	$(MAKE) -C $(libkernel_path) clean
	$(MAKE) -C $(libcore_path) clean
	$(MAKE) -C $(UNIT_TEST_PATH) $(BUILD_REC) clean

cleanall:
	$(MAKE) -C $(libkernel_path) cleanall
	$(MAKE) -C $(libcore_path) cleanall
	$(MAKE) -C $(UNIT_TEST_PATH) $(BUILD_REC) cleanall
	rm -f tags coverity.html
	rm -rf $(COVERITY_PATH)
	rm -f $(APP)

