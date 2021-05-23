/* 

SQL Queries that used for Tableau Portfolio Project

*/


-- 1. Global Numbers/ DeathPercentage

SELECT SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths AS INT)) AS TotalDeaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS
	DeathPercentage  --, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
-- WHERE location LIKE 'Egypt'
WHERE continent IS NOT Null
--GROUP BY date
ORDER BY 1, 2



-- 2. TotalDeath per each continent

SELECT location, SUM(CAST(new_deaths AS int)) AS TotalDeath
FROM PortfolioProject..CovidDeaths
-- WHERE location LIKE 'Egypt'
WHERE continent IS Null
AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeath DESC



-- 3. Countries with Highest Infection rate compared to Population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS
	PopulationInfectedPercentage
FROM PortfolioProject..CovidDeaths
-- WHERE location LIKE 'Italy'
Where continent IS NOT Null
GROUP BY location, population
ORDER BY PopulationInfectedPercentage DESC



-- 4. Countries with Highest Infection rate compared to Population considering the infection date

SELECT location, population, date, MAX(total_cases) AS HighestInfectionCount, Max((total_cases/population))*100 AS
	PopulationInfectedPercentage
FROM PortfolioProject..CovidDeaths
--Where location like '%states%'
GROUP BY location, population, date
ORDER BY PopulationInfectedPercentage DESC



-- 5. Total Cases vs Total Deaths and showing likelihood of dying if you contract covid in Egypt

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE 'Egypt'
AND continent IS NOT Null
ORDER BY 1, 2



-- 6. Total Population vs Total Vaccinations for each cotinent

WITH PopvsVac (location, continent, date, population, New_Vaccinations, RollingPopulationVaccinated)
as
(
SELECT dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) As RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NULL 
AND dea.location NOT IN ('World', 'European Union', 'International')
-- ORDER BY 2, 3 
)
SELECT *, (RollingPopulationVaccinated/Population)*100 AS PopulationVaccinatedPercentage
FROM PopvsVac



-- 7. Total Population vs Total Vaccinations for each country

WITH PopvsVac (location, continent, date, population, New_Vaccinations, RollingPopulationVaccinated)
as
(
SELECT dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) As RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
AND dea.location NOT IN ('World', 'European Union', 'International')
-- ORDER BY 2, 3 
)
SELECT *, (RollingPopulationVaccinated/population)*100 AS PopulationVaccinatedPercentage
FROM PopvsVac
