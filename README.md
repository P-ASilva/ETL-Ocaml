# ETL-Ocaml

## Objective:

The objective of this ETL project is to process data from a source (a CSV file), apply transformations, and store the result in another resource (a new CSV file). The project is based on two tables that represent a small part of a management software: an orders table and another containing the items of each order. In a real-world scenario, direct access to the database may be impractical for security and performance reasons. Therefore, a daily process extracts the relevant data and generates a copy in a shared file. The ultimate goal is to provide the processed data to the manager, who will use this information to feed an aggregated order visualization dashboard.

### Use Cases:
- BI (Business Intelligence)
- ML Pipeline (Machine Learning Pipelines)
- Data Engineering

## What is ETL?

ETL stands for Extract, Transform, Load. It is a process used to gather data from various sources, including unstructured ones, transform it through conversions, cleaning, and applying rules or calculations, and finally store it in a processed and structured destination.

## Project Structure

### Lib : DataProcessing.ml: Pure Functions for ETL Processing

The `DataProcessing.ml` file contains a set of pure functions designed to process and transform order-related data as part of an ETL (Extract, Transform, Load) pipeline. The module defines three primary record types: `order`, `order_item`, and `order_total`, which store structured information about customer orders, their corresponding items, and computed totals. The functions provided in this module focus on parsing CSV data into structured records, filtering orders based on specific criteria (such as status or origin), and computing total order values, including taxes.

Key pure functions include:
- **`parse_order`** and **`parse_order_item`**: Convert string-based CSV rows into structured `order` and `order_item` records while handling potential parsing failures.
- **Aggregation functions**: `get_order_total` calculates the total amount and taxes for a given order, and `compute_order_totals` processes multiple orders to derive a list of total values.

Since all functions operate on input data without modifying external state, they adhere to functional programming principles, ensuring predictability, testability, and ease of parallel processing.

### Lib : DataReadWrite.ml: File I/O for Orders and Order Items

The `DataReadWrite.ml` file is responsible for reading and writing order-related data, facilitating the ETL process by handling CSV files. Unlike `DataProcessing.ml`, which contains only pure functions, this module interacts with the file system and Csv library.

Key functions include:
- **`read_orders`**: Reads an orders CSV file, parsing its contents into a list of `order` records.
- **`read_order_items`**: Reads an order items CSV file and extracts structured `order_item` records, filtering out invalid rows.
- **`write_order_totals_to_csv`**: Writes computed order totals to a CSV file, including order ID, total amount, and total taxes. It also handles file existence checks and logs messages when overwriting files.

This module bridges the gap between raw CSV data and structured order processing by leveraging the pure functions in `DataProcessing.ml` to ensure data consistency and integrity.

### Main.ml: Program Execution and ETL Pipeline Coordination

The `Main.ml` file serves as the entry point for executing the ETL pipeline. It orchestrates the reading, processing, and writing of order data by integrating the functions from `DataProcessing.ml` and `DataReadWrite.ml`.

Key steps in the program execution:
- Reads order data from `./data/order.csv`.
- Accepts optional command-line arguments to filter orders based on `origin` and `status`.
- Reads order items from `./data/order_item.csv`.
- Computes order totals using `compute_order_totals`, filtering order items accordingly.
- Writes the computed order totals to `./data/order_totals.csv` and logs the completion message.

By structuring the program this way, `Main.ml` ensures a modular and efficient ETL workflow while allowing for flexible filtering through command-line arguments.

## How to Use

To execute the ETL pipeline, ensure that you have an appropriate OCaml environment set up. You can either install OCaml locally or use the provided `.devcontainer` configuration to run it inside a virtualized development environment.

### Running Locally
1. Install OCaml and Dune (if not installed):
   ```sh
   opam install dune csv
   ```
2. Clone the repository and navigate to the project folder:
   ```sh
   git clone <repository-url>
   cd <project-folder>
   ```
3. Build the project:
   ```sh
   dune build
   ```
4. Execute the ETL pipeline with filters (optional):
   ```sh
   dune exec ETL -- <origin> <status>
   ```
   - Replace `<origin>` with the desired order origin (e.g., `"O"` for Online).
   - Replace `<status>` with the desired order status (e.g., `"Complete"`).
   - Example: 
     ```sh
     dune exec ETL -- O Complete
     ```

### Running in a DevContainer (VS Code)
1. Ensure you have **Docker** and **Visual Studio Code** installed.
2. Open the project in VS Code and select **"Reopen in Container"** when prompted.
3. The development environment will set up automatically.
4. Follow the **Running Locally** steps inside the container.

After execution, the processed data will be saved in `./data/order_totals.csv`.

## Documentation

- This project uses docstrings in code and odocs to view it outside of code, run :
   ```sh
   dune build @doc
   ```
- Them navigate to ``` ETL/_build/default/_doc/_html ```

## Disclaimer

This project utilized AI models, including GPT-4, Deepseek and Leo (Brave Browser AI, based on LLaMA 2), to assist with debugging code and drafting initial documentation. All generated content was reviewed and refined to ensure accuracy and coherence. 