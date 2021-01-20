download:
	curl -O http://www.doc.ic.ac.uk/~nd/dac_src/processes.ex

compile: clean
	# Clean and compile Elixir module - note: we can only have one version of the compiled module Processes
	# Compiling a duplicate definition for Processes will overwrite the old version
	elixirc processes.ex

run:
	# Runs the start command from the Processes module
	elixir -e Processes.start

clean:
	# Remove the compiled bytecode
	rm -rf Elixir.Processes.beam