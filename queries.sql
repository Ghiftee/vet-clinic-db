/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';

SELECT name FROM animals WHERE EXTRACT(year FROM date_of_birth)BETWEEN 2016 AND 2019;

SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;

SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';

SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

SELECT * FROM animals WHERE neutered = true;

SELECT * FROM animals WHERE name != 'Gabumon';

SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

/* Query and update table */

BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT species FROM animals;
ROLLBACK;
SELECT species FROM animals;

BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
COMMIT;
SELECT species FROM animals;

BEGIN;
DELETE FROM animals;
ROLLBACK;

BEGIN TRANSACTION;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT DELETE_DOB;
UPDATE animals SET weight_kg = (weight_kg * -1);
ROLLBACK TO DELETE_DOB;
UPDATE animals SET weight_kg = (weight_kg * -1) WHERE weight_kg < 0; 
COMMIT TRANSACTION;

SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, MAX(escape_attempts) FROM animals GROUP BY neutered;
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;
SELECT species, AVG(escape_attempts) FROM animals WHERE EXTRACT(year FROM date_of_birth) BETWEEN 1990 AND 2000 GROUP BY species;

/* Query multiple tables */

SELECT animals.name, owners.full_name FROM animals
    JOIN owners
    ON owners.id = animals.owner_id
    AND owners.full_name = 'Melody Pond';

SELECT animals.name, species.name FROM animals
    JOIN species
    ON species.id = animals.species_id
    AND species.name = 'Pokemon';

SELECT owners.full_name, animals.name FROM owners
    LEFT JOIN animals
    ON owners.id = animals.owner_id;

SELECT species.name, COUNT(*) FROM animals
    FULL OUTER JOIN species
    ON species.id = animals.species_id
    GROUP BY species.id;

SELECT animals.name, species.name FROM animals
    JOIN owners ON owners.id = animals.owner_id
    JOIN species ON species.id = animals.species_id
    WHERE owners.full_name = 'Jennifer Orwell'
    AND species.name = 'Digimon';

SELECT animals.name, animals.escape_attempts FROM animals
    JOIN owners ON owners.id = animals.owner_id
    WHERE owners.full_name = 'Dean Winchester'
    AND animals.escape_attempts = 0;

SELECT owners.full_name, COUNT(animals.owner_id) FROM animals 
    FULL OUTER JOIN owners 
    ON animals.owner_id = owners.id
    GROUP BY owners.id;

/* Add join table for visits */

SELECT animal_id, visits.date_of_visit FROM visits
    JOIN animals ON animal_id = visits.animal_id
    WHERE vet_id = 1
    ORDER BY date_of_visit DESC LIMIT 1;

SELECT COUNT(DISTINCT visits.animal_id) FROM visits
    JOIN vets ON vets.id = visits.vet_id
    WHERE vets.name = 'Stephanie Mendez';

SELECT vets.name, species.name FROM vets 
    LEFT JOIN specializations ON specializations.vet_id = vets.id
    LEFT JOIN species ON species.id = specializations.species_id;

SELECT animals.name, visits.date_of_visit FROM visits
    JOIN vets ON vets.id = visits.vet_id
    JOIN animals ON animals.id = visits.animal_id
    WHERE vets.name = 'Stephanie Mendez'
    AND visits.date_of_visit BETWEEN 'Apr 1, 2020' AND 'Aug 30, 2020';

SELECT animals.name, COUNT(visits.animal_id) FROM visits
    JOIN vets ON vets.id = visits.vet_id
    JOIN animals ON animals.id = visits.animal_id
    GROUP BY animals.name, visits.animal_id
    ORDER BY COUNT(visits.animal_id) DESC LIMIT 1;

SELECT animals.name, visits.date_of_visit FROM visits
    JOIN vets ON vets.id = visits.vet_id
    JOIN animals ON animals.id = visits.animal_id
    WHERE vets.name = 'Maisy Smith'
    GROUP BY animals.name, visits.date_of_visit
    ORDER BY visits.date_of_visit LIMIT 1;

SELECT * FROM visits
    JOIN animals ON animals.id = visits.animal_id
    JOIN vets ON vets.id = visits.vet_id
    ORDER BY visits.date_of_visit DESC LIMIT 1;

SELECT COUNT(visits.animal_id) FROM visits
    JOIN vets ON vets.id = visits.vet_id
    JOIN animals ON animals.id = visits.animal_id
    JOIN specializations ON specializations.vet_id = vets.id
    WHERE specializations.species_id <> animals.species_id;

SELECT species.name, COUNT(visits.animal_id) FROM visits
    JOIN vets ON vets.id = visits.vet_id
    JOIN animals ON animals.id = visits.animal_id
    JOIN species ON species.id = animals.species_id
    WHERE vets.name = 'Maisy Smith'
    GROUP BY species.name
    ORDER BY COUNT(visits.animal_id) DESC LIMIT 1;