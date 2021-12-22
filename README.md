# JWT Prover in Cairo

This is a WIP implementation of [Project Kreme](https://github.com/torusresearch/kreme) in Cairo.

# Setting up the environment

https://www.cairo-lang.org/docs/quickstart.html

# How to Run

input.json contains a sample JWT and the email id. 

- Compile
        
        cairo-compile main.cairo --output main.json

- Run

        cairo-run --program=main.json --print_output --layout=small --program_input=input.json

# How to use the SHARP prover

- Submit to SHARP

        cairo-sharp submit --source main.cairo --program_input input.json

- Check status

        cairo-sharp status <<JOB_KEY>>

# How to test

- Install pytest

        pip install pytest pytest-asyncio

- Run tests

        pytest
        