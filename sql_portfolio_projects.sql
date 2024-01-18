--Select *
--From portfolioProject01..covidDeaths
--order by 3,4

--Select *
--from portfolioProject01..covidVaccinations
--order by 3,4

----Total deaths vs populations
--select cd.location, cd.date, total_cases, new_cases, total_deaths, population
--from portfolioProject01..covidDeaths as cd
--inner join portfolioProject01..covidVaccinations as cv 
--on cd.iso_code = cv.iso_code 
--and cd.date = cv.date
--order by 1,2


----likelihood of dying for having covid19 in united states
--select cd.location, cd.date, total_cases, new_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
--from portfolioProject01..covidDeaths as cd
--inner join portfolioProject01..covidVaccinations as cv 
--on cd.iso_code = cv.iso_code 
--and cd.date = cv.date
--where cd.location like '%states%'
--order by 1,2

--select cd.location, cd.date, total_cases, new_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
--from portfolioProject01..covidDeaths as cd
--inner join portfolioProject01..covidVaccinations as cv 
--on cd.iso_code = cv.iso_code 
--and cd.date = cv.date
--order by 1,2

----shows the percentage of poplation got covid
--select cd.location, cd.date, total_cases, new_cases, total_deaths, (total_cases/population) as covid_percentage
--from portfolioProject01..covidDeaths as cd
--inner join portfolioProject01..covidVaccinations as cv 
--on cd.iso_code = cv.iso_code 
--and cd.date = cv.date
--order by 1,2

----Looking at countries with highest infection rate compared to population
--select cd.location, cd.date, max(total_cases) as Total_Infection_Count, population,
--(max(total_cases)/population) * 100 as PercentPopulationInfected
--from portfolioProject01..covidDeaths as cd
--inner join portfolioProject01..covidVaccinations as cv 
--on cd.iso_code = cv.iso_code 
--and cd.date = cv.date
--group by cd.location, cd.date, cv.population
--order by PercentPopulationInfected desc



----show countries with highest death count per population
--select cd.location, max(total_deaths) as Total_death_count, population,
--(max(total_deaths)/population) * 100 as PercentPopulationDeath
--from portfolioProject01..covidDeaths as cd
--inner join portfolioProject01..covidVaccinations as cv 
--on cd.iso_code = cv.iso_code 
--and cd.date = cv.date
--group by cd.location, cv.population
--order by PercentPopulationDeath desc



--Global numbers
--Tried to do sum(max(Total_death_count)) but sql doesn't allow agregate ontop of an aggregate
--Therefore I did a substring to return an aggregate function as a new table
--select cd.date, sum(cx.Total_death_count) as Global_death_count, sum(cx.population) as Global_population
--from (select cd.iso_code, cd.date, cd.location, max(total_deaths) as Total_death_count, cd.population
--	from portfolioProject01..covidDeaths as cv
--	inner join PortfolioProject01..covidVaccinations as cd
--	on cd.date = cv.date
--	and cd.iso_code = cv.iso_code
--	group by cd.location, cd.iso_code, cd.date, cd.population) as cx
--inner join portfolioProject01..covidDeaths as cd
--on cd.date = cx.date
--and cd.iso_code = cx.iso_code
--inner join portfolioProject01..covidVaccinations as cv 
--on cd.iso_code = cv.iso_code 
--and cd.date = cv.date
--where cx.Total_death_count is not null
--group by cd.date, cv.population
--order by 1,2




--Looking for total vaccination vs population by location and date
--there are too many preceding rows to order by location and date 
--therefore need to add command "rows unbounded preceding" 
--to expand the range of windows frame(number of rows) larger than default limitation of 1020 bytes
--Use CTE, because alias does not work like a column
--with PopvsVac(continent, location, date, population, new_vaccinations, Accumulated_Vaccnation)
--as(
--select continent, location, date, population, new_vaccinations, 
--sum(new_vaccinations) 
--over (partition by location order by location, date rows unbounded preceding) as Accumulated_Vaccination--(Accumulated_Vaccination/population) *100
--from PortfolioProject01..covidVaccinations
--where continent is not null
--)
--select *, Accumulated_Vaccnation/population * 100
--from PopvsVac


--temp table
--Drop table if exists #PercentPopulationVaccinated
--Create table #PercentPopulationVaccinated
--(
--Continent varchar(255),
--Location varchar(255),
--Date date,
--Population numeric,
--New_Vaccination numeric,
--Accumulated_Vaccination numeric
--)
--insert into #PercentPopulationVaccinated
--select continent, location, date, population, new_vaccinations, 
--sum(new_vaccinations) 
--over (partition by location order by location, date rows unbounded preceding) as Accumulated_Vaccination--(Accumulated_Vaccination/population) *100
--from PortfolioProject01..covidVaccinations
--where continent is not null
--select *, Accumulated_Vaccination/population * 100
--from #PercentPopulationVaccinated


Create view PercentPopulationVaccinated as
select continent, location, date, population, new_vaccinations, 
sum(new_vaccinations) 
over (partition by location order by location, date rows unbounded preceding) as Accumulated_Vaccination--(Accumulated_Vaccination/population) *100
from PortfolioProject01..covidVaccinations
where continent is not null
