export PROJECT_NAME:=<file_in>
export THIS_MAKEFILE_PATH:=$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
export PROJECT_PATH:=$(shell cd $(dir $(THIS_MAKEFILE_PATH));pwd)

PHONY+=clean cleanall

APP:=<file_in>
BUILD_REC:=-f $(PROJECT_PATH)/mk.rec

all: $(APP)

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

$(APP): <fill_in>
	@echo "TBD"

clean:
	@echo "TBD"

cleanall:
	@echo "TBD"
	rm -f tags
	rm -f $(APP)

