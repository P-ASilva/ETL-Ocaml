# Project Report

## Project Overview
This report provides a comprehensive guide on how the ETL project was constructed, covering each step required to rebuild the project from scratch. The ETL process focuses on reading data from CSV files, transforming it using functional programming principles, and saving the processed data back to CSV files.

## Project Structure
The project consists of three main modules:
- **DataProcessing.ml**: Handles data transformations and computations.
- **DataReadWrite.ml**: Manages reading from and writing to CSV files.
- **Main.ml**: Orchestrates the ETL pipeline, applying transformations and saving results.

## Development Steps

1. **Setup the Project Environment**
   - Install OCaml, Dune, and the CSV library using OPAM:
     ```bash
     opam install dune csv
     ```
   - (Optional) Install odocs to view documentation:
      ```bash
      opam install odoc
      ```
   - Initialize the project structure using Dune’s conventions.

2. **Implementing Data Processing Steps**
   - Define record types for `order`, `order_item`, and `order_total` containing relevant fields.
   - Create pure functions for parsing, filtering, and aggregating data. (Parsers -> Helper Functions)
   - Use map, reduce and filter in order to aggregate data.
   - *To improve* inner join is another valid aggregation method and could be used to streamline the filtering procces while aggregating data.
   - *Note* filter_map can be necessary for option type returns if used prior in parsers.
   - Ensure functions remain side-effect-free, adhering to functional programming principles.

3. **Implementing Reading and Writing data**
   - Implement functions for reading and writing CSV files, separated from the others, as these have to be impure.
   - *To improve* : Reading can be done from static files hosted online, and writing would work better on a local database. SQLite is recommended.
   - Ensure error handling and logging.
   - *To Improve* :  This project does not check all entries of the Csv files. For instance, to update the code in order to process DateTime fields, validating if the date is reasonable and matches proper formatting would be a necessary step.

4. **Creating Tests for DataReadWrite.ml and DataProcessing.ml**
   - Use OUnit2 for unit testing.
   - Always make sure your code contains unit tests in cases of failure.
   - If your functions depend on specific formats, make tests that fail in case of improper formatting or missing fields.

5. **Orchestrating the ETL Pipeline in Main.ml**
   - Read orders and order items using `DataReadWrite` functions.
   - Use System functions to read Dune arguments in order to use customizable filters.
   - Use simple List Filter functions to apply the argument given restrictions.
   - Apply transformations using `DataProcessing` functions.
   - Write results to CSV files.

6. **Documentation**
   - Use docstrings to document each relevant function to facilitate use and debbuging.
   - *(Optional)* install odocs in order to check documentation in html format.

## Use of Generative AI

Generative AI tools, including GPT-4, were used to support the development of code, debugging, and documentation. All outputs were reviewed and refined to ensure accuracy.

   - Leo (Brave AI, Lhamma-02 based) provided help with dependency installs.
   - Deepseek was used for code debbuging, as gpt-04 proved to be lackluster for Ocaml;
   - Gpt-04 was used to provide the templates for the READEME.md file and this report;


Use AI at your own discretion, documentation and summarization are the advised use cases. 

## Project Requirements
- Functional programming principles must be strictly followed.
- All modules must remain modular and as independent as possible.
- The solution must handle invalid or malformed data.