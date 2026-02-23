SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
order by 3,4

--SELECT *
--FROM PortfolioProject..CovidVaccination
--order by 3,4

--Select Data taht we are going use

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
order by 1,2

--Looking at Total Cases vs total deaths
--Shows likelihood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%states%'
order by 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got covid 

SELECT location, date, Population, total_cases, (Total_cases/population)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%states%'
order by 1,2

--Looking at Country with Highest Infection rate compared to population

SELECT location, Population, MAX(total_cases) as HighestInfectionCount, MAX((Total_cases/population))*100 as PercentagePopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
Group by Location, Population
order by PercentagePopulationInfected desc

--Showing Countries with highest death count per population

SELECT location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
Group by Location
order by TotalDeathCount desc

--Breaking things down by continent

--Showing contintents with the highest death count per population

SELECT location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
Group by location
order by TotalDeathCount desc

--Global numbers
SELECT date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
Where continent is not null
Group by date
order by 1,2

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
Where continent is not null
--Group by date
order by 1,2

--Looking at total population vs vaccinations

with PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccination vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--Use CTE

with PopvsVac (Continent, Location, Date, Population, RollingPeopleVaccinated)
as 

--Temp Table

Create table #PercentPopulationVaccinated
(
Continent nvarchar(225),
Location nvarchar(225),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccination vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

--Need to make changes on same table

DROP Table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(225),
Location nvarchar(225),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccination vac
	ON dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is not null
--Order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

--Creating a view to store data for later visualizations

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccination vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3

Select *
From PercentPopulationvaccinated


--Covid Dashboard data
1.
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is no null
Order by 1,2

2.
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortolioProject..CovidDeaths
Where continent is null
and location not in ('World', 'European Union', 'International')
Group by location
Order by TotalDeathCount desc

3.
Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by location, Population
Order by PercentPopulationInfected desc

4.
Select Location, Population,date, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population, date
Order by PercentPopulationInfected desc
