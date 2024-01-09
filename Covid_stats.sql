
select location distinct from covid19deaths 
group by "location"
order by "location";

-- SELECT DATA
select "location", "`date`", total_cases, new_cases, total_deaths, population 
from covid19deaths
order by 2,1;

-- Total Deaths vs Total Cases in each Location
select "location", "`date`", total_cases, total_deaths, population
from covid19deaths
order by "`date`";

-- For Poland
select location, "`date`" , total_cases, total_deaths, population, 
cast(total_deaths as float)/cast(total_cases as float) as rate
from covid19deaths
where location = 'Poland'
order by 1,2;

-- Total Cases vs Population
select location, "`date`" , total_cases, total_deaths, population, 
cast(total_cases as float)/cast(population as float) as rate
from covid19deaths
where location = 'Poland'
order by 1,2;

-- Countries with highest infecion rate
select location, max(total_cases), population, 
cast(max(total_cases) as float)/cast(population as float) as rate
from covid19deaths
group by location, population
order by rate desc;

-- Countries by number of deaths
select location, max(total_deaths) as number_of_deaths
from covid19deaths
where continent is not null 
group by location
order by max(total_deaths) desc;

-- Continents by number of deaths
select continent, max(total_deaths) as number_of_deaths
from covid19deaths
where continent is not null
group by continent
order by max(total_deaths) desc;

-- Death ratio on every day for whole world
select "`date`" as date_, sum(new_cases) as new_cases, sum(new_deaths) as new_deaths, (sum(cast(new_deaths as float))/sum(cast(new_cases as float)))*100 as death_ratio
from covid19deaths
group by "`date`"
having sum(new_cases) != 0 and sum(new_deaths) != 0
order by 4 desc;


--
--ALTER TABLE public.covidvaccinations ALTER COLUMN date_of TYPE date USING to_date(date_of, 'MM-DD-YYYY')

-- COVID VACCINATION AND COVID DEATHS
select *
from covid19deaths cd 
join covidvaccinations c 
on cd.location = c.location
and cd.date_of = c.date_of
;

-- UPDATE public.covidvaccinations SET new_vaccinations=NULL where new_vaccinations='';

-- POPULATION VS VACCINATION
select cd.continent, cd.location, cd.date_of, cd.population, c.new_vaccinations, 
sum(c.new_vaccinations) over (partition by cd.location order by cd.location, cd.date_of) as n_people_vacc
from covid19deaths cd 
join covidvaccinations c 
on cd.location = c.location
and cd.date_of = c.date_of
where cd.continent is not null
order by 2,3
;

-- Creating new table - POPULATION VS VACCINATION
drop table if exists CovidVacInPopulation;
create table CovidVacInPopulation (
	continent varchar(50),
	location varchar(50),
	date_of date,
	population int8,
	new_vaccinations int8,
	number_of_people_vaccinated numeric
);

insert into CovidVacInPopulation (continent, location, date_of, population, new_vaccinations, number_of_people_vaccinated)
select cd.continent, cd.location, cd.date_of, cd.population, c.new_vaccinations, 
sum(c.new_vaccinations) over (partition by cd.location order by cd.location, cd.date_of) as n_people_vacc
from covid19deaths cd 
join covidvaccinations c 
on cd.location = c.location
and cd.date_of = c.date_of
where cd.continent is not null
order by 2,3


-- Percent of people 
select *, (number_of_people_vaccinated/population)*100 as percent_of_people_vaccinated from covidvacinpopulation
order by 2, 3;
;


-- CREATING VIEWS FOR VISUALIZATION
create view percent_of_people_vaccinated
as
select *, (number_of_people_vaccinated/population)*100 as percent_of_people_vaccinated from covidvacinpopulation
order by 2, 3;
;
