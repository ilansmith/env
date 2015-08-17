export PROJECT_NAME:=kunit
export THIS_MAKEFILE_PATH:=$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
export PROJECT_PATH:=$(shell cd $(dir $(THIS_MAKEFILE_PATH));pwd)
export KERNEL_PATH:=$(PROJECT_PATH)/kernel
export RUNTIME_PATH:=$(KERNEL_PATH)/runtime
export UNIT_TEST_PATH:=$(PROJECT_PATH)/ut

# kernel include paths
export INCLUDES=$(PROJECT_PATH)/core \
	$(patsubst %,$(KERNEL_PATH)/%, \
		patches/include \
		emu/lnx/include \
		emu/kut/include)

include Kbuild

LD=gcc

define add_objs
OBJS+=$(patsubst %,$(UNIT_TEST_PATH)/$1/%, $2)
endef

$(foreach d,$(DIRS), \
	$(if $(obj-$d),$(eval $(call add_objs,$d,$(obj-$d)))) \
	$(if $(obj-ut-$d),$(eval $(call add_objs,$d,$(obj-ut-$d)))))

libkernel_path=kernel/emu
libcore_path=core

CFLAGS=-Werror -Wall -g $(INCLUDES:%=-I%)
LDFAGS=$(patsubst %,-L$(PROJECT_PATH)/%, \
       $(libkernel_path) \
       $(libcore_path))

APP=kunit

.PHONY: clean cleanall

all: $(APP)

%.o: %.c
	$(CC) -o $@ $(CFLAGS) -c $<

lib%:
	$(MAKE) -C $($@_path)

define help_print_tool
  @printf "\033[1m%-10s\033[0m - %s.\n" $1 $2
endef

help:
	@printf "Usage:\n"
	@printf "     $$ \033[1mmake [target]\033[0m\n"
	@printf "\n"
	@printf "Where 'target' is one of:\n"
	$(call help_print_tool,"$(APP)","build $(APP) [default target]")
	$(call help_print_tool,"clean","clean object files and libraries")
	$(call help_print_tool,"cleanall","clean everything")

$(APP): $(OBJS) libcore libkernel
	$(LD) $(OBJS) $(LDFAGS) -lcore -lkernel -o $@

clean:
	@echo "removing object files"
	$(MAKE) -C $(libkernel_path) clean
	$(MAKE) -C $(libcore_path) clean
	@rm -f $(OBJS)

cleanall: clean
	$(MAKE) -C $(libkernel_path) cleanall
	$(MAKE) -C $(libcore_path) cleanall
	@echo "removing tag file"
	@rm -rf tags
	@echo "removing $(APP)"
	@rm -f $(APP)

