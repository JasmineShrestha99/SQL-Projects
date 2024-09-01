Here’s a comprehensive `README.md` file for your SQL project:

---

# Biological Data Analysis

**Author:** Jasmine Shrestha  
**File:** Biological_Data_Analysis.sql

## Overview

This project involves the creation, management, and analysis of complex biological datasets using SQL. The script is designed to handle advanced operations, including subqueries, intricate joins, and triggers to ensure data integrity and enforce constraints across multiple interrelated tables. The purpose is to process and analyze biological data accurately and consistently, providing actionable insights from the dataset.

## Features

### 1. Table Creation
   - **Organism Table:** Stores key biological classifications (SpeciesName, GenusName, FamilyName). Ensures no duplicates using a unique constraint across these classifications.
   - **Sample Table:** Records data on biological samples collected, including collection date, organism ID, and location. Ensures referential integrity with cascading updates and deletions.
   - **Gene Table:** Contains genetic information, including gene name and chromosome details, linked to the `Organism` table.
   - **Experiment Table:** Tracks experimental data, including expression levels, which must be non-negative. Linked to both the `Sample` and `Gene` tables to maintain data consistency.

### 2. Advanced Data Processing
   - **Subqueries and Joins:** Utilizes complex subqueries and joins to aggregate and analyze gene expression levels across different species.
   - **Gene Expression Analysis:** Identifies the top 10 genes with the highest average expression levels, categorizing them based on their average expression (High, Moderate, Low).

### 3. Triggers for Data Integrity
   - **trg_check_organism_exists:** Prevents the insertion of a sample if the associated organism does not exist in the `Organism` table.
   - **trg_update_experiment_modified:** Automatically updates the `ExperimentDate` to the current timestamp whenever the expression level is modified.
   - **trg_prevent_gene_deletion:** Prevents the deletion of a gene if it is associated with any existing experiments, ensuring no loss of critical data.

## Detailed Operations

### Data Integrity and Constraints
The script ensures that all data remains consistent and accurate through the use of foreign keys, unique constraints, and triggers. This is crucial when working with biological data where relationships between organisms, samples, genes, and experiments must be strictly maintained.

### Complex Query Execution
The script uses advanced SQL techniques, including Common Table Expressions (CTEs), to process and report on gene expression data. The final query provides a detailed report that includes the top genes by expression level, categorized for easier interpretation.

## Usage

To use this SQL script, follow these steps:

1. **Set Up the Database:** Run the script to create the necessary tables (`Organism`, `Sample`, `Gene`, `Experiment`).
2. **Data Insertion:** Insert biological data into the tables, ensuring that all constraints are satisfied.
3. **Run the Analysis:** Execute the final query to retrieve a detailed report on gene expression, including categorized expression levels and associated sample information.
4. **Enforce Data Integrity:** The included triggers will automatically enforce data integrity rules, preventing invalid data operations and ensuring that all updates are accurately tracked.

## Conclusion

The **Biological Data Analysis** project is designed to provide a robust framework for managing and analyzing complex biological datasets. By utilizing advanced SQL techniques and enforcing strict data integrity rules, this project ensures that the biological data remains accurate, consistent, and ready for in-depth analysis.

---

This `README.md` provides a clear and professional overview of your SQL project, detailing its purpose, features, and how it works. It also serves as a guide for anyone who wishes to understand or use the script for biological data analysis.