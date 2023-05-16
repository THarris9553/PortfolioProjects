Select *
	From [Portfolio Project]..CovidDeaths
	Where continent = NULL
	Order By 3,4

--Select *
--	From [Portfolio Project]..CovidVaccinations
--	Order By 3,4

-- Select data to work with

Select location, date, total_cases,new_cases,total_deaths,population
 From [Portfolio Project]..CovidDeaths
 Order By 1,2

--Fixes for incorrect data types
----alter table coviddeaths
----	alter column total_deaths float

----alter table coviddeaths
----	alter column total_cases float

----alter table coviddeaths
----	alter column date date

----alter table coviddeaths
----	alter column population float



 --Total Cases vs Total Deaths
 --Shows rough estimate of lethality after catching Covid
 Select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 AS death_rate
	From [Portfolio Project].dbo.CovidDeaths
	Where location like	'%states%'
	--^Selects United States data
	Order By 2

--Total Cases vs Population
--Shows percentage of population with Covid

 Select location, date, population, total_cases, (total_cases/NULLIF(population,0))*100 AS percentage_infected
	From [Portfolio Project].dbo.CovidDeaths
	--Where location like	'%states%'
	--^Selects United States data
	Order By 1,2

--Countries with highest infection rate compared to population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/NULLIF(population,0)))*100 AS infection_rate
	From [Portfolio Project].dbo.CovidDeaths
	--Where location like	'%states%'
	--^Selects United States data
	Group By population, location
	Order by infection_rate desc

--Shows countries with highest death count

Select location, MAX(total_deaths) as TotalDeathCount
	From [Portfolio Project].dbo.CovidDeaths
	Group By location
	Order by TotalDeathCount desc

--By continent

Select location, MAX(total_deaths) as TotalDeathCount
	From [Portfolio Project]..CovidDeaths
	Where continent like '' OR continent is null
	Group By location
	Order by TotalDeathCount desc


--Global Numbers

Select date, SUM(CAST(new_cases as int)) as cases, SUM(CAST(new_deaths as int)) as deaths, SUM(CAST(new_deaths as float))/NULLIF(SUM(CAST(new_cases as float)),0)*100 as DeathPercentage
	From [Portfolio Project].dbo.CovidDeaths
	Where continent not like '' OR continent is not null
	Group By date
	Order By 1,2



-- Total Population vs Vaccinations

Select NULLIF(dea.continent,'') as continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	From [Portfolio Project]..CovidDeaths dea
	Join [Portfolio Project]..CovidVaccinations vac
		On dea.location = vac.location
		and dea.date = vac.date
	Where dea.continent is not NULL
	Order By 2,3