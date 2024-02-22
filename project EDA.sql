


--Firstly Let check if our tables are properly Imported 
 select * from coviddeath
ORDER BY CONTINENT,LOCATION, DATE

select * from covidvaccine

-- show the percentage of people who died after contaction per day
select location, date, total_cases, total_deaths, (CONVERT(FLOAT,total_deaths)/CONVERT(FLOAT,total_cases))*100 AS DEATH_PERCENTAGE
from coviddeath
WHERE LOCATION = 'NIGERIA' AND DATE = '2023-03-29'
ORDER By location, DATE

--show the current percentage of death from contaction per country 
WITH CTE_DEATHPERCENTAGE 
AS
(
SELECT 
LOCATION AS LOCATION,
DATE AS DATE ,
TOTAL_CASES AS INFECTED_PEOPLE,
TOTAL_DEATHS AS TOTAL_DEATH,
ROW_NUMBER() OVER(PARTITION BY LOCATION ORDER BY DATE DESC) AS ROWNUM
FROM coviddeath
WHERE CONTINENT IS NOT NULL
)

SELECT LOCATION,
DATE,
INFECTED_PEOPLE,
TOTAL_DEATH
FROM CTE_DEATHPERCENTAGE
WHERE ROWNUM = 1



--SHOW THE COUNTRY WITH THE HIGHEST INFECTION RATE
SELECT 
LOCATION,
MAX(CONVERT(FLOAT,TOTAL_CASES)) AS INFECTED_PEOPLE,
MAX(CONVERT(FLOAT, POPULATION)) AS POPULATION,
MAX(CONVERT(FLOAT,TOTAL_CASES))/MAX(CONVERT(FLOAT, POPULATION))*100 AS INFECTION_RATE
--INTO #TEMP_TABLE
FROM coviddeath
WHERE CONTINENT IS NOT NULL
GROUP BY LOCATION
ORDER BY INFECTION_RATE DESC

SELECT * FROM #TEMP_TABLE
WHERE INFECTION_RATE IS  NULL
ORDER BY INFECTION_RATE DESC



-- showing the country with highest death rate per population


-- showing the continent with the highest death count



--show the  percentage of dying from 
--contaction IN THE WORLD



--show the  vaccination to population ratio per day

--TEMP TABLE
CREATE TABLE #PercentagePopulationVaccinated
(
location varchar(50),
date datetime,
population numeric,
new_vaccinations numeric,
RollingVaccinatedPeople numeric
)

INSERT INTO #PercentagePopulationVaccinated 
SELECT dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(FLOAT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingVaccinatedPeople
FROM coviddeaths dea
JOIN covidvaccine vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
order by dea.location, dea.date

SELECT *, (RollingVaccinatedPeople/population)*100 PERCENTAGE_POPULATION_VACCINATED
FROM #PercentagePopulationVaccinated
ORDER BY location, date

--CREATING VIEW FOR VISUALIZATION

-- view for country with the highest infection


-- view for continent with the highest infection


-- view for the percentage of death per country


-- view for percentage vaccinated

