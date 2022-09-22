SELECT location, date, total_cases, new_cases, total_deaths, population 
FROM ProjectPortfolio..['Covid Deaths$']
ORDER BY 1,2

--  let's look at the death rate

SELECT location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathRate
FROM ProjectPortfolio..['Covid Deaths$']
WHERE location = 'kenya'
ORDER BY 1,2

-- exploring the total cases versus the population
-- Here we look at the percentage that got infected

SELECT location, date, total_cases,population, (total_cases/population)*100 as InfectionPercentage
FROM ProjectPortfolio..['Covid Deaths$']
WHERE location = 'kenya'
ORDER BY 1,2

-- Looking at the highest infected

 
 SELECT location ,population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentInfectedHighest
FROM ProjectPortfolio..['Covid Deaths$']
--WHERE location like '%kenya%'
group  by location ,population 
ORDER BY PercentInfectedHighest desc

SELECT continent, MAX(cast(total_cases as int)) as TotalDeaths
FROM ProjectPortfolio..['Covid Deaths$']
WHERE continent is not null
group  by continent  
ORDER BY TotalDeaths desc

-- Now let's join the deaths and vaccination tables using joins

SELECT * FROM ProjectPortfolio..['Covid Deaths$'] deaths
join ProjectPortfolio..['Covid Vaxxed$'] vaxt
on deaths.location = vaxt.location and
deaths.date = vaxt.date


-- Now we can compare the vaccinated ppln vs death.

SELECT deaths.continent, deaths.location, deaths.date, deaths.population,vaxt.new_vaccinations
FROM ProjectPortfolio..['Covid Deaths$'] deaths
join ProjectPortfolio..['Covid Vaxxed$'] vaxt
on deaths.location = vaxt.location and
deaths.date = vaxt.date
where deaths.continent is not null
order by 2,3

-- Lets do a rollingcount or cumulative count after a day in the continent.

SELECT deaths.continent, deaths.location, deaths.date, deaths.population,vaxt.new_vaccinations,
SUM(cast(vaxt.new_vaccinations as int)) OVER (Partition by deaths.location order by deaths.location,deaths.date) as CumulativeCount
FROM ProjectPortfolio..['Covid Deaths$'] deaths
join ProjectPortfolio..['Covid Vaxxed$'] vaxt
on deaths.location = vaxt.location and
deaths.date = vaxt.date
where deaths.continent is not null
order by 2,3

--For now let's stop it at that.

