Select *
From [Portfolio Project]..CovidDeaths
Where continent is not NULL
order by 3,4


--Select *
--From [Portfolio Project]..Covidvaccinations
--order by 3,4

Select location,date,total_cases,new_cases,total_deaths,population
From [Portfolio Project]..CovidDeaths
Order by 1,2

Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
where location like '%States%'
and continent is not NULL
Order by 1,2

Select location,date,population,total_cases,(total_cases/population)*100 as PercentagePopulationInfected
From [Portfolio Project]..CovidDeaths
Where location like '%states%'
and continent is not NULL
Order by 1,2

Select location,population,Max(total_cases) as HighesetInfectionCount,MAX((total_cases/population))*100 as PercentagePopulationInfected
From [Portfolio Project]..CovidDeaths
--Where location like '%states%'
Group by location,population
Order by PercentagePopulationInfected desc

Select location,Max(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
--Where location like '%states%'
Where continent is not NULL
Group by location
Order by TotalDeathCount desc

Select continent,Max(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
--Where location like '%states%'
Where continent is not NULL
Group by continent
Order by TotalDeathCount desc

Select Sum(new_cases) as totalcases,sum(cast(new_deaths as int)) as totaldeaths,sum(cast(New_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
--where location like '%States%'
where continent is not NULL
--Group by date
Order by 1,2

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
Sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.Location,
dea.date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..Covidvaccinations vac
    on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 1,2

With PopvsVac (Continent,location,Date,Population,New_vaccinations,RollingPeopleVaccinated)
as
(
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
Sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.Location,
dea.date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..Covidvaccinations vac
    on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *,(RollingPeopleVaccinated/Population)*100
From PopvsVac

Drop table if exists  #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
Sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.Location,
dea.date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..Covidvaccinations vac
    on dea.location = vac.location and dea.date = vac.date
--where dea.continent is not null
--order by 2,3
Select *,(RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

Create view PercentPopulationVaccinated as
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
Sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.Location,
dea.date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..Covidvaccinations vac
    on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated