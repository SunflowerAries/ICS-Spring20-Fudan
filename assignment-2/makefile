export VIVADO_PATH=/home/sunflower/Xilinx/Vivado/2019.2/bin/vivado
PROJECT_DIR:=.
SIM:=sim_1
PROJECT_NAME:=Pipeline

test: 
	SIMULATION=${SIM} ${VIVADO_PATH} -mode tcl -source benchtest/run_simulation.tcl ${PROJECT_DIR}/${PROJECT_NAME}.xpr
	
