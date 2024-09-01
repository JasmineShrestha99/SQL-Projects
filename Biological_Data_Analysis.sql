/*
    Author: Jasmine Shrestha
    File: Biological_Data_Analysis.sql
    Purpose: This advanced SQL script is designed to process and analyze complex biological data. It utilizes sophisticated subqueries, intricate joins, and triggers to maintain data integrity and enforce constraints across multiple interrelated tables. This script is aimed at ensuring accurate, consistent, and actionable insights from the biological datasets it operates on.
*/

-- Create foundational tables to store biological data
CREATE TABLE Organism (
    OrganismID INT PRIMARY KEY,
    SpeciesName VARCHAR(255) NOT NULL,
    GenusName VARCHAR(255) NOT NULL,
    FamilyName VARCHAR(255) NOT NULL,
    UNIQUE(SpeciesName, GenusName, FamilyName) -- Ensure no duplicates across these critical biological classifications
);

CREATE TABLE Sample (
    SampleID INT PRIMARY KEY,
    CollectionDate DATE NOT NULL,
    OrganismID INT NOT NULL,
    Location VARCHAR(255) NOT NULL,
    FOREIGN KEY (OrganismID) REFERENCES Organism(OrganismID)
    ON DELETE CASCADE ON UPDATE CASCADE -- Ensure referential integrity with cascading updates and deletions
);

CREATE TABLE Gene (
    GeneID INT PRIMARY KEY,
    GeneName VARCHAR(255) NOT NULL,
    Chromosome VARCHAR(50) NOT NULL,
    OrganismID INT NOT NULL,
    FOREIGN KEY (OrganismID) REFERENCES Organism(OrganismID)
    ON DELETE CASCADE ON UPDATE CASCADE -- Ensure referential integrity with cascading updates and deletions
);

CREATE TABLE Experiment (
    ExperimentID INT PRIMARY KEY,
    ExperimentDate DATE NOT NULL,
    SampleID INT NOT NULL,
    GeneID INT NOT NULL,
    ExpressionLevel FLOAT CHECK(ExpressionLevel >= 0), -- Ensures expression levels are non-negative
    FOREIGN KEY (SampleID) REFERENCES Sample(SampleID)
    ON DELETE CASCADE ON UPDATE CASCADE, -- Maintain integrity across related data in case of updates/deletions
    FOREIGN KEY (GeneID) REFERENCES Gene(GeneID)
    ON DELETE CASCADE ON UPDATE CASCADE  -- Maintain integrity across related data in case of updates/deletions
);

-- Implement advanced subqueries with complex joins
WITH GeneExpressionAvg AS (
    SELECT
        g.GeneID,
        g.GeneName,
        o.SpeciesName,
        AVG(e.ExpressionLevel) AS AvgExpression
    FROM
        Experiment e
    JOIN Gene g ON e.GeneID = g.GeneID
    JOIN Organism o ON g.OrganismID = o.OrganismID
    GROUP BY
        g.GeneID, g.GeneName, o.SpeciesName
),

-- Identify top 10 genes with the highest average expression levels across all species
TopGenes AS (
    SELECT
        GeneID,
        GeneName,
        SpeciesName,
        AvgExpression
    FROM
        GeneExpressionAvg
    WHERE AvgExpression IS NOT NULL  -- Ensure we only consider genes with recorded expression levels
    ORDER BY
        AvgExpression DESC
    LIMIT 10
)

-- Final comprehensive query for detailed reporting
SELECT
    tg.GeneID,
    tg.GeneName,
    tg.SpeciesName,
    tg.AvgExpression,
    s.SampleID,
    s.CollectionDate,
    s.Location,
    CASE
        WHEN tg.AvgExpression > 100 THEN 'High Expression'
        WHEN tg.AvgExpression BETWEEN 50 AND 100 THEN 'Moderate Expression'
        ELSE 'Low Expression'
    END AS ExpressionCategory  -- Categorize genes based on their average expression levels
FROM
    TopGenes tg
JOIN Experiment e ON tg.GeneID = e.GeneID
JOIN Sample s ON e.SampleID = s.SampleID
ORDER BY
    tg.AvgExpression DESC;

-- Triggers for ensuring data integrity and enforcing constraints
-- Trigger to ensure that a sample is associated with an existing organism before insertion
CREATE TRIGGER trg_check_organism_exists
BEFORE INSERT ON Sample
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Organism WHERE OrganismID = NEW.OrganismID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The associated OrganismID does not exist in the Organism table. Insertion aborted.';
    END IF;
END;

-- Trigger to automatically update the ExperimentDate to the current timestamp whenever the expression level is updated
CREATE TRIGGER trg_update_experiment_modified
BEFORE UPDATE ON Experiment
FOR EACH ROW
BEGIN
    IF OLD.ExpressionLevel <> NEW.ExpressionLevel THEN
        SET NEW.ExperimentDate = CURRENT_TIMESTAMP;
    END IF;
END;

-- Trigger to prevent deletion of a gene if it is associated with any experiment
CREATE TRIGGER trg_prevent_gene_deletion
BEFORE DELETE ON Gene
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM Experiment WHERE GeneID = OLD.GeneID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete Gene as it is associated with an existing experiment.';
    END IF;
END;
