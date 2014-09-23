export PROJECT_NAME:=android_jb_octa_samsung
export PROJECT_PATH:=`pwd`

LOG_PATH:=$(PROJECT_PATH)/log
KERNEL_PATH:=$(PROJECT_PATH)/kernel/
U_BOOT_PATH:=$(PROJECT_PATH)/u-boot/
IMG_PATH=$(PROJECT_PATH)/img
TOOLCHAIN_PATH=/usr/local/sandisk/toolchain/arm-eabi-4.6/bin
USE_CCACHE:=1

export PATH:=$(TOOLCHAIN_PATH):$(PATH)
export MORLA_MODULE_PATH=../../../dev/kernel/morla/morla-module/

.PHONY: sd flash

# valid compilation flags
FLAG_CONFIG:=config
FLAG_DISTCLEAN:=distclean

# valid =y flags
VALID_CONFIG_OPTS:=$(FLAG_CONFIG) $(FLAG_DISTCLEAN)

# filter out invalid %=y flags (and anything else that is not of the form %=y)
CMD_LINE_OPTS=$(strip $(patsubst %=y,%,$(MAKEFLAGS)))
INVALID_OPTS=$(filter-out $(VALID_CONFIG_OPTS),$(CMD_LINE_OPTS))

# default
DO_DISTCLEAN=
DO_CONFIG=
DO_BUILD=y

DEFAULT_TARGETS=ker

define space2comma
`echo "$1" | sed -e 's/[ \t]\+/, /g'`
endef

all: $(DEFAULT_TARGETS)

help:
	@printf "Usage:\n"
	@printf "     $$ \033[1mmake [targets] $(FLAG_DISTCLEAN)=y\033[0m          [clean targets]\n"
	@printf "\n"
	@printf "     $$ \033[1mmake [targets] $(FLAG_CONFIG)=y\033[0m             [configure targets]\n"
	@printf "\n"
	@printf "     $$ \033[1mmake [targets]\033[0m                      [build targets]\n"
	@printf "\n"
	@printf "Where 'targets' is any combination of:\n"
	@printf "\033[1mker\033[0m - kernel (Android kernel for Samsung Exynos platforms).\n"
	@printf "Specifying no targets is equivilent to specifying the targets: $(call space2comma,$(DEFAULT_TARGETS)).\n"
	@printf "\n     or\n\n"
	@printf "     $$ \033[1mmake flash PART=<partition>\033[0m         [flash images to fastboot partitions]\n"
	@printf "\n"
	@printf "Where 'partitions' is one of:\n"
	@printf "\033[1mkernel\033[0m     - kernel image.\n"
	@printf "\033[1mall\033[0m        - all of the above images.\n"
	@printf "Before flashing:\n"
	@printf "* Make sure the platform is correctly DIP switched for flashing either eMMC or SD/MMC\n"
	@printf "* Connect to the platform via USB and put its bootloader in fastboot mode\n"
	@printf "\n     or\n\n"
	@printf "     $$ \033[1msudo make sd DEV=/dev/sd<X> \033[0m        [Make an SD card bootable for loading u-boot]\n"
	@printf "\n"
	@printf "Before issuing:\n"
	@printf "* Use a card reader to insert the SD card into this development machine\n"
	@printf "\n"
	@printf "\033[7mSetup a new eMMC device\033[0m\n"
	@printf "1. Insert prepared micro SD card into the Exynos Octa SD slot\n"
	@printf "2. Insert eMMC device to be set up into Exynos Octa eMMC vDaptor\n"
	@printf "3. Set the boot option DIP switch to “SD boot”\n"
	@printf "\n"
	@printf "   SW1-1,2 | 1st Boot media\n"
	@printf "   --------+---------------\n"
	@printf "   ON  ON  |  eMMC 5.0     \n"
	@printf "   ON  OFF |  eMMC 4.4     \n"
	@printf "\033[1m   OFF ON  |  MicroSD card \033[0m\n"
	@printf "   OFF OFF |  Reserved     \n"
	@printf "\n"
	@printf "4. Plug in the DC power and wait about 1-2 minutes of installation\n"
	@printf "   See that installation is finished in the UART terminal\n"
	@printf "\n"
	@printf "\033[7mBoot from the eMMC device\033[0m\n"
	@printf "1. Unplug the DC power and remove the SD card\n"
	@printf "2. Change the boot option to eMMC (eMMC 5.0 in case of Whale)\n"
	@printf "\n"
	@printf "   SW1-1,2 | 1st Boot media\n"
	@printf "   --------+---------------\n"
	@printf "\033[1m   ON  ON  |  eMMC 5.0     \033[0m\n"
	@printf "   ON  OFF |  eMMC 4.4     \n"
	@printf "   OFF ON  |  MicroSD card \n"
	@printf "   OFF OFF |  Reserved     \n"
	@printf "\n"
	@printf "3. Plug in the DC power\n"

define do_error
  $(error $1 (see: make help))
endef

# set distclean
ifeq ($($(FLAG_DISTCLEAN)),y)
  ifneq ($($(FLAG_CONFIG)),)
    $(call do_error,Bad make flags combination)
  endif

  DO_DISTCLEAN=y
  DO_BUILD=
endif

# set config
ifeq ($($(FLAG_CONFIG)),y)
  ifneq ($($(FLAG_DISTCLEAN)),)
    $(call do_error,Bad make flags combination)
  endif

  DO_CONFIG=y
  DO_BUILD=
endif

# usage: do_make_single <$1=path> <$2=target> <$3=log_file>
define do_make_single
  $(MAKE) -C $1 $2 2>&1 | tee $(LOG_PATH)/$3.log
endef

define verify_valid_options
$(if $(INVALID_OPTS)$,$(call do_error,Unrecognized make flags/options: $(INVALID_OPTS)))
endef

# usage: do_make <$1=path> <$2=distclean_target> <$3=config_target> <$4=build_target>
define do_make
$(call verify_valid_options)
$(shell [ ! -d $(LOG_PATH) ] && mkdir -p $(LOG_PATH))
$(if $(DO_DISTCLEAN),$(if $2,$(call do_make_single,$1,$2,$@_distclean),@echo "\033[1m$@\033[0m: No clean target, skipping..."))
$(if $(DO_CONFIG),$(if $3,$(call do_make_single,$1,$3,$@_config),@echo "\033[1m$@\033[0m: Nothing to configure, skipping..."))
$(if $(DO_BUILD),$(call do_make_single,$1,$4,$@_build))
endef

COMMON_BUILD_FLAGS:=PATH=$(PATH) ARCH=arm CCACHE_DIR=$(PROJECT_PATH)/.ccache CROSS_COMPILE='$(shell which ccache) arm-eabi-'

KER_COMMON_BUILD_FLAGS:=$(COMMON_BUILD_FLAGS) MORLA_MODULE_PATH=$(MORLA_MODULE_PATH) PWD=$(KERNEL_PATH)

ker:
	$(call do_make,$(KERNEL_PATH),$(KER_COMMON_BUILD_FLAGS) distclean,$(KER_COMMON_BUILD_FLAGS) odroidxu3_defconfig,$(KER_COMMON_BUILD_FLAGS))

UBT_COMMON_BUILD_FLAGS:=$(COMMON_BUILD_FLAGS)

ubt:
	$(call do_make,$(U_BOOT_PATH),$(UBT_COMMON_BUILD_FLAGS) distclean,$(UBT_COMMON_BUILD_FLAGS) smdk5410_config,$(UBT_COMMON_BUILD_FLAGS))

### flashing ###

define flash_internal
  @fastboot flash $1 $(IMG_PATH)/$2
  @echo
  @if [ "$3" -eq "1" ]; then \
    fastboot reboot; \
  fi
endef

define flash_kernel
  @echo "Flashing kernel..."
  $(call flash_internal,kernel,zImage-dtb,$1)
endef

define flash_all

  $(call flash_kernel,0)
  @fastboot reboot;
endef

sd:
	@echo "Making a bootable SD card for Octa..."; \
	if [ -z "$(DEV)" ] || [ ! -b "$(DEV)" ] ; then \
		echo "Error: please specify a device with DEV=/dev/sd<X>"; \
		return; \
	fi; \
	echo "Are you sure you want to overwrite $(DEV)? [y/N]..."; \
	read do_sd; \
	if [ "$$do_sd" = "y" ]; then \
		sudo dd bs=1M if=$(IMG_PATH)/sd2emmc_installer.img of=$(DEV); \
		[ $$? -ne 0 ] && return; \
		[ -b "$(DEV)" ] && eject $(DEV); \
		sync; \
	else \
	  echo "aborting..."; \
	fi

flash:
	$(if $(PART),$(call flash_$(PART),1))

# create/remove a symbolic link
# $1: destination path for the symbolic link
# $2: symbolic link's name
# $3: target's full path
define do_link
  $(if $(DO_BUILD),
    @mkdir -p $1; \
    ln -s $3 $1/$2; \
    echo "$2 can be found in $1")
  $(if $(DO_DISTCLEAN),
    $(shell [ -L $1/$2 ] && rm -rf $1/$2) \
    $(shell [ -d $1 ] && [ ! -L $1/* ] && rmdir $1))
endef

