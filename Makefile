SHELL		:= /bin/bash
MAKEDIR		:= $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
NAMESPACE	:= default

COLOR_WHITE			= \033[0m
COLOR_LIGHT_BLUE	= \033[1;34m

SUBMODULES 	= free5gc-operator onos-bandwidth-operator bans5gc-operator
BRANCH		?= master

define echo_blue
	@echo -e "${COLOR_LIGHT_BLUE}${1}${COLOR_WHITE}"
endef

.PHONY: submodule install uninstall reset-infra

submodule: ## Install all submodules
	$(call echo_blue,"...... Initialize and Update All Submodules ......")
	git submodule init
	git submodule update

update-submodule: ## Update submodules with specified branch
	$(call echo_blue,"...... Pull Submodule with Branch \'${BRANCH}\' ......")
	-@declare -a submodule_list=(${SUBMODULES}); for submodule in "$${submodule_list[@]}"; \
	do \
		cd $$submodule; \
		git checkout ${BRANCH} && git pull; \
		cd ${MAKEDIR}; \
	done

install: ## Install all operator resources
	$(call echo_blue,"...... Install free5gc Operator ......")
	cd free5gc-operator && make install
	$(call echo_blue,"...... Install ONOS Bandwidth Operator ......")
	cd onos-bandwidth-operator && make install
	$(call echo_blue,"...... Install BANS 5GC Operator ......")
	cd bans5gc-operator && make install
	${SHELL} scripts/wait_pods_running.sh ${NAMESPACE}
	$(call echo_blue,"...... Prepare Transport Network ......")
	cd onos-bandwidth-operator && make transport
	$(call echo_blue,"Installation Completed!")

uninstall: ## Uninstall all operator resources and functions
	$(call echo_blue,"...... Uninstall BANS 5GC Operator ......")
	cd bans5gc-operator && make uninstall
	$(call echo_blue,"...... Uninstall ONOS Bandwidth Operator ......")
	cd onos-bandwidth-operator && make uninstall
	$(call echo_blue,"...... Uninstall ONOS ......")
	cd onos-bandwidth-operator && make reset-onos
	$(call echo_blue,"...... Uninstall free5gc Operator ......")
	cd free5gc-operator && make uninstall
	$(call echo_blue,"...... Uninstall free5gc ......")
	cd free5gc-operator && make reset-free5gc
	$(call echo_blue,"Uninstallation Completed!")

reset-infra:
	$(call echo_blue,"...... Delete BansSlice ......")
	${SHELL} scripts/remove_bansslice.sh
	$(call echo_blue,"...... Uninstall ONOS ......")
	cd onos-bandwidth-operator && make reset-onos
	$(call echo_blue,"...... Uninstall free5gc ......")
	cd free5gc-operator && make reset-free5gc
	$(call echo_blue,"Reset Completed!")
