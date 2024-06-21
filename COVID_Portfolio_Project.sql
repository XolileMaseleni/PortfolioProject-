SELECT *
FROM PortfolioProject..Covid_Deaths 
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..Covid_Vaccinations
--ORDER BY 3,4

 

SELECT location, date, total_cases, total_deaths, new_cases, population
FROM PortfolioProject..Covid_Deaths 
ORDER BY 1,2



SELECT location, date, MAX total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..Covid_Deaths
WHERE location like '%South Africa%'
GROUP BY location, date
ORDER BY 1,2

--Looking at the Total case VS Total Deaths
-- Shows the likelihood of dying if you contract COVID in your country
SELECT 
    location, 
	continent,
    date, 
    total_cases,
	total_deaths,
    CASE 
        WHEN TRY_CAST(total_cases AS float) = 0 THEN 0 
        ELSE (TRY_CAST(total_deaths AS float) / TRY_CAST(total_cases AS float)) * 100 
    END AS DeathPercentage
FROM 
    PortfolioProject..Covid_Deaths
WHERE location like '%South Africa%'
ORDER BY 
    location, date;


	-- Looking at the total case vs Population 

	SELECT 
    location, 
    date, 
    total_cases,
	population,
    CASE 
        WHEN TRY_CAST(total_cases AS float) = 0 THEN 0 
        ELSE (TRY_CAST(total_deaths AS float) / TRY_CAST(total_cases AS float)) * 100 
    END AS DeathPercentage
FROM 
    PortfolioProject..Covid_Deaths
WHERE location like '%South Africa%'
ORDER BY 
    location, date;

	--Looking at countries with Highest infection rate compared to population 

	WITH InfectionRates AS (
    SELECT 
        location, 
        total_cases,
        population,
        CASE 
            WHEN TRY_CAST(total_cases AS float) = 0 THEN 0 
            ELSE (TRY_CAST(total_deaths AS float) / TRY_CAST(total_cases AS float)) * 100 
        END AS DeathPercentage,
        (TRY_CAST(total_cases AS float) / TRY_CAST(population AS float)) * 100 AS InfectionRate
    FROM 
        PortfolioProject..Covid_Deaths
    WHERE 
        location LIKE '%South Africa%'
)
SELECT 
    location, 
    total_cases, 
    population,
    DeathPercentage,
    InfectionRate
FROM 
    InfectionRates
WHERE 
    InfectionRate = (SELECT MAX(InfectionRate) FROM InfectionRates)
ORDER BY 
    location;


	WITH InfectionRates AS (
    SELECT 
        location, 
		continent,
        date, 
        total_cases, 
        population,
        (TRY_CAST(total_cases AS float) / TRY_CAST(population AS float)) * 100 AS InfectionRate,
        CASE 
            WHEN TRY_CAST(total_cases AS float) = 0 THEN 0 
            ELSE (TRY_CAST(total_deaths AS float) / TRY_CAST(total_cases AS float)) * 100 
        END AS DeathPercentage
    FROM 
        PortfolioProject..Covid_Deaths
    --WHERE 
        --location LIKE '%South Africa%'
)
SELECT 
    location, 
	continent,
    date, 
    total_cases, 
    population, 
    DeathPercentage, 
    InfectionRate
FROM 
    InfectionRates
WHERE 
    InfectionRate = (SELECT MAX(InfectionRate) FROM InfectionRates)
ORDER BY 
    location, continent DESC;


	--

	WITH InfectionRates AS (
    SELECT 
        location, 
        date, 
        total_cases, 
        population,
        (TRY_CAST(total_cases AS float) / TRY_CAST(population AS float)) * 100 AS InfectionRate,
        CASE 
            WHEN TRY_CAST(total_cases AS float) = 0 THEN 0 
            ELSE (TRY_CAST(total_deaths AS float) / TRY_CAST(total_cases AS float)) * 100 
        END AS DeathPercentage
    FROM 
        PortfolioProject..Covid_Deaths
    --WHERE 
        --location LIKE '%South Africa%'
)




SELECT 
    location, MAX (cast(total_deaths as int)) as TotalDeathCount
	FROM PortfolioProject..Covid_Deaths
	WHERE continent is not null
	Group by location
	order by TotalDeathCount DESC



	--Looking at continents

	SELECT 
    continent, MAX (cast(total_deaths as int)) as TotalDeathCount
	FROM PortfolioProject..Covid_Deaths
	WHERE continent is not null
	Group by continent
	order by TotalDeathCount DESC;
    
	--Add continet to all selct statements and group by
	
	--Global numbers 

		SELECT 
    date, 
    total_cases,
	total_deaths,
    CASE 
        WHEN TRY_CAST(total_cases AS float) = 0 THEN 0 
        ELSE (TRY_CAST(total_deaths AS float) / TRY_CAST(total_cases AS float)) * 100 
    END AS DeathPercentage
FROM 
    PortfolioProject..Covid_Deaths
--WHERE location like '%South Africa%'
WHERE continent is not null 
ORDER BY 
     date;




	 	SELECT 
    date,
	SUM(new_cases), SUM(new_deaths), SUM(new_cases)/SUM(new_deaths)*100 as DeathPercentage
    --    CASE 
      --  WHEN TRY_CAST(total_cases AS float) = 0 THEN 0 
        --ELSE (TRY_CAST(total_deaths AS float) / TRY_CAST(total_cases AS float)) * 100 
    --END AS DeathPercentage
FROM 
    PortfolioProject..Covid_Deaths
--WHERE location like '%South Africa%'
WHERE continent is not null 
GROUP BY date
ORDER BY 
     date;


	 SELECT 
    date,
    SUM(new_cases) AS TotalNewCases, 
    SUM(new_deaths) AS TotalNewDeaths, 
    CASE 
        WHEN SUM(new_cases) = 0 THEN 0 
        ELSE (SUM(new_deaths) * 100.0 / SUM(new_cases)) 
    END AS DeathPercentage
FROM 
    PortfolioProject..Covid_Deaths
WHERE 
    continent IS NOT NULL 
GROUP BY 
    date
ORDER BY 
    date;

	 


	SELECT 
    SUM(new_cases) AS total_cases, 
    SUM(CAST(new_deaths AS int)) AS total_deaths,
    CASE 
        WHEN SUM(new_cases) = 0 THEN 0 
        ELSE (SUM(CAST(new_deaths AS int)) * 100.0 / SUM(new_cases)) 
    END AS DeathPercentage
FROM 
    PortfolioProject..Covid_Deaths
WHERE 
    continent IS NOT NULL
ORDER BY 
    total_cases, total_deaths;


	--Lookinga at total Population vs Vaccination

	Select*
	from PortfolioProject..Covid_Deaths dea
	join PortfolioProject..Covid_Vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	from PortfolioProject..Covid_Deaths dea
	join PortfolioProject..Covid_Vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	WHERE continent is not null
	ORDER BY dea.continent,dea.location

	SELECT
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations
	FROM
	PortfolioProject..Covid_Deaths dea
	JOIN 
	PortfolioProject..Covid_Vaccinations vac
	ON 
	dea.location = vac.location 
	AND 
	dea.date = vac.date
	WHERE
	dea.continent IS NOT NULL
	ORDER BY
	dea.continent, dea.location; 


SELECT continent, location, date, total_cases, new_cases, total_deaths, population
FROM portfolioproject..Covid_Deaths
WHERE continent is not null
ORDER BY 1,2

--Looking at the Total case VS Total Deaths 
-- Shows the likelihood of dying if you contract COVID in your country
SELECT location, date, total_cases, total_deaths, (total_cases / total_deaths)*100 as DeathPercentage
FROM portfolioproject..Covid_Deaths 
WHERE location like '%South Africa%'
ORDER BY 1,2

--Looking at the total cases VS population
--Shows what percentage of population got COVID
SELECT location, date, population, total_cases, (total_cases / population)*100 as PercentPopulationinfection
FROM portfolioproject..Covid_Deaths 
WHERE location like '%South Africa%'
ORDER BY 1,2

--Looking at countries with highest infection rate compared to population 
SELECT location,population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases / population))*100 as PercentPopulationinfection
FROM portfolioproject..Covid_Deaths 
--WHERE location like '%South Africa%'
GROUP BY location,population
ORDER BY PercentPopulationinfection desc

--Showing countries with the Highest death count per population 
SELECT continent, location,MAX(total_deaths) as TotalDeathCount
FROM portfolioproject..Covid_Deaths 
WHERE continent is not null
GROUP BY continent, location
ORDER BY TotalDeathCount desc

--Lets focus on continents 
--Result not accurate as North America seems not to include Canada.
--Same query however change the continet back to location and where continent is null
--all queries above have to add continent and group by continent for different results 
SELECT continent,MAX(total_deaths) as TotalDeathCount
FROM portfolioproject..Covid_Deaths 
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

--Looking at GLOBAL NUMBERS
SELECT date, SUM(new_cases), SUM(new_deaths), SUM(new_deaths)/SUM(new_cases)
FROM portfolioproject..Covid_Deaths 
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

--Kept getting a "division by zero: 0 / 0" for the above query until i found out that some of the values in the new_cases column might be zero, causing division by zero when calculating
--To solve this I had to replace the division SUM(new_deaths)/SUM(new_cases) with a CASE statement that checks if the sum of new cases is zero
SELECT continent, location, date, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, 
    CASE WHEN SUM(new_cases) = 0 THEN 0 ELSE SUM(new_deaths)/SUM(new_cases) END AS death_rate
FROM 
    portfolioproject..Covid_Deaths 
WHERE 
    continent IS NOT NULL
GROUP BY 
    continent, location, date
ORDER BY 
    1,2

--To find the global number of total cases and total deaths across the world we just need to remove the date on the same above query and comment out the group by 
SELECT  SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, 
    CASE WHEN SUM(new_cases) = 0 THEN 0 ELSE SUM(new_deaths)/SUM(new_cases) END AS death_rate
FROM 
    portfolioproject..Covid_Deaths 
WHERE 
    continent IS NOT NULL
--GROUP BY 
    --date
ORDER BY 
    1,2


    --looking at the second dataset which is the Vaccination by joining the 2 tables 
    SELECT *
FROM portfolioproject..Covid_Deaths dea
join PortfolioProject..Covid_Vaccinations vac
on dea.location = vac.location
and dea.date = vac.date

--Looking at total population VS Vaccinations
--vaccination are per day 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (partition by dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
-- I want to know the amount of people vaccinated vs the population, I will use the Max function  
FROM portfolioproject..Covid_Deaths dea
join PortfolioProject..Covid_Vaccinations vac
on dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY
2,3

--Above query had an error because the (new_vaccination) folder is of type nvarchar, which is not suitable for arithmetic operations. To fix this i used the CAST as int

SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations, 
    SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.date) as RollingPeopleVaccinated
FROM 
    portfolioproject..Covid_Deaths dea
JOIN 
    portfolioproject..Covid_Vaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL
ORDER BY
    dea.location, 
    dea.date;

	--(new_vaccination) is too large and the result came back not readale, used COALESCE AS BIGINT
	SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations, 
    SUM(CAST(COALESCE(vac.new_vaccinations, 0) AS bigint)) OVER (PARTITION BY dea.location ORDER BY dea.date) as RollingPeopleVaccinated,
	--RollingPeopleVaccinated/population)*100
FROM 
    portfolioproject..Covid_Deaths dea
JOIN 
    portfolioproject..Covid_Vaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL
ORDER BY
    dea.location, 
    dea.date;

	-- USE A CTE


	WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) AS (
    SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        vac.new_vaccinations, 
        SUM(CAST(COALESCE(vac.new_vaccinations, 0) AS bigint)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
    FROM 
        portfolioproject..Covid_Deaths dea
    JOIN 
        portfolioproject..Covid_Vaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE 
        dea.continent IS NOT NULL
)
SELECT 
    continent, 
    location, 
    date, 
    population, 
    new_vaccinations, 
    RollingPeopleVaccinated,
    (RollingPeopleVaccinated / CAST(population AS float)) * 100 AS PercentageVaccinated
FROM 
    PopvsVac
ORDER BY
    location, 
    date;

	SELECT *, ( RollingPeopleVaccinated/population)*100
	FROM PopvsVac


	--TEMP TABLE 
	Create table #PercentPopulatedVaccinated(
	continent nvarchar(255),
	location nvarchar(255),
	Date datetime,
	Population numeric,
	New_vaccination numeric,
	RollingPeopleVaccinated numeric
	)


	SELECT *, ( RollingPeopleVaccinated/population)*100
	FROM #PercentPopulatedVaccinated

	-- Drop the temp table if it exists
DROP TABLE IF EXISTS #PercentPopulatedVaccinated;

-- Create the temp table with the calculated values
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations, 
    SUM(CAST(COALESCE(vac.new_vaccinations, 0) AS bigint)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
INTO 
    #PercentPopulatedVaccinated
FROM 
    portfolioproject..Covid_Deaths dea
JOIN 
    portfolioproject..Covid_Vaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL;



-- Select from the temp table with the percentage calculation
SELECT 
    continent, 
    location, 
    date, 
    population, 
    new_vaccinations, 
    RollingPeopleVaccinated,
    (RollingPeopleVaccinated / CAST(population AS float)) * 100 AS PercentageVaccinated
FROM 
    #PercentPopulatedVaccinated
ORDER BY
    location, 
    date;


	--Creating view for later visualization

	Create view PercentPopulationVaccinated as 
	 SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        vac.new_vaccinations, 
        SUM(CAST(COALESCE(vac.new_vaccinations, 0) AS bigint)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
    FROM 
        portfolioproject..Covid_Deaths dea
    JOIN 
        portfolioproject..Covid_Vaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE 
        dea.continent IS NOT NULL

--Worked view 
	Select * 
	From PercentPopulationVaccinated