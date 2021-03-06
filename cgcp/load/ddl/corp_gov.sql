-- this db holds the raw data for this project, taken directly from csv files
-- no meaningful manipualtions are caried out before loading this db
use corp_gov;

drop table if exists spx;
drop table if exists sxxp;
drop table if exists eebp;
drop table if exists spx_esg;
drop table if exists spx_emissions;
drop table if exists spx_energy;
drop table if exists spx_actual_new_income_per_employee;
drop table if exists spx_cash_flow_per_employee;
drop table if exists spx_ghg_scope_1;
drop table if exists spx_mscore;
drop table if exists spx_csr;
drop table if exists spx_ceo_comp;

create table spx (
  `Ticker` varchar(100) NOT NULL,
  `Tax` double DEFAULT NULL,
  `Norm NI to NI for Cmn %` double DEFAULT NULL,
  `Interest` double DEFAULT NULL,
  `OPM T12M` double DEFAULT NULL,
  `Asset` double DEFAULT NULL,
  `Fincl  l` double DEFAULT NULL,
  `Oper ROE` double DEFAULT NULL,
  `5Yr Avg Adj ROE` double DEFAULT NULL,
  `Dvd P/O` double DEFAULT NULL,
  `Sust Gr Rt` double DEFAULT NULL,
  `EBITDA/Sh` double DEFAULT NULL,
  `P/E` double DEFAULT NULL,
  `EPS` double DEFAULT NULL,
  `P/B` double DEFAULT NULL,
  `P/EBITDA` double DEFAULT NULL,
  `ROE` double DEFAULT NULL,
  `ROC` double DEFAULT NULL,
  `EV/EBITDA T12M` double DEFAULT NULL,
  `Net Debt to EBITDA` double DEFAULT NULL,
  `Cash Gen/Cash Reqd` double DEFAULT NULL,
  `AZS` double DEFAULT NULL,
  `Dvd Yld` double DEFAULT NULL,
  `Tobins Q` double DEFAULT NULL,
  `Board Size` integer DEFAULT NULL,
  `Unit or 2 Tier Bd Sys` integer DEFAULT NULL,
  `# Empl Reps on Bd` integer DEFAULT NULL,
  `Clssfd Bd Sys` varchar(1) DEFAULT NULL,
  `# Non Exec Dir on Bd` integer DEFAULT NULL,
  `% NonExec Dir on Bd` double DEFAULT NULL,
  `% Indep Directors` double DEFAULT NULL,
  `Indep Directors` integer DEFAULT NULL,
  `CEO Duality` varchar(1) DEFAULT NULL,
  `Indep Chrprsn` varchar(1) DEFAULT NULL,
  `Indep Lead Dir` varchar(1) DEFAULT NULL,
  `Prsdg Dir` varchar(1) DEFAULT NULL,
  `Frmr CEO or its Equiv on Bd` varchar(1) DEFAULT NULL,
  `% Women on Bd` double DEFAULT NULL,
  `# Wmn on Bd` integer DEFAULT NULL,
  `% Feml Execs` double DEFAULT NULL,
  `# Feml Execs` integer DEFAULT NULL,
  `Feml CEO or Equiv` varchar(1) DEFAULT NULL,
  `# Execs / Co Mgrs` integer DEFAULT NULL,
  `Age Young Dir` integer DEFAULT NULL,
  `BOD Age Rng` integer DEFAULT NULL,
  `Age Old Dir` integer DEFAULT NULL,
  `Bd Avg Age` double DEFAULT NULL,
  `Bd Age Limit` integer DEFAULT NULL,
  `Board Duration` integer DEFAULT NULL,
  `Exec Dir Bd Dur` integer DEFAULT NULL,
  `Board Mtgs #` integer DEFAULT NULL,
  `Board Mtg Att %` double DEFAULT NULL,
  `Indep Dir Bd Mtg Att %` double DEFAULT NULL,
  `Sz Aud Cmte` integer DEFAULT NULL,
  `# Indep Dir on Aud Cmte` integer DEFAULT NULL,
  `% Indep Dir on Aud Cmte` double DEFAULT NULL,
  `# Indep Dir on Comp Cmte` integer DEFAULT NULL,
  `% Indep Dir on Comp Cmte` double DEFAULT NULL,
  `% Indep Dir on Nom Cmte` double DEFAULT NULL,
  primary key (Ticker)
);

create table sxxp(
  `Ticker` varchar(100) NOT NULL,
  `Tax` double DEFAULT NULL,
  `Norm NI to NI for Cmn %` double DEFAULT NULL,
  `Interest` double DEFAULT NULL,
  `OPM T12M` double DEFAULT NULL,
  `Asset` double DEFAULT NULL,
  `Fincl  l` double DEFAULT NULL,
  `Oper ROE` double DEFAULT NULL,
  `5Yr Avg Adj ROE` double DEFAULT NULL,
  `Dvd P/O` double DEFAULT NULL,
  `Sust Gr Rt` double DEFAULT NULL,
  `EBITDA/Sh` double DEFAULT NULL,
  `P/E` double DEFAULT NULL,
  `EPS` double DEFAULT NULL,
  `P/B` double DEFAULT NULL,
  `P/EBITDA T12M` double DEFAULT NULL,
  `ROE` double DEFAULT NULL,
  `ROC` double DEFAULT NULL,
  `EV/EBITDA` double DEFAULT NULL,
  `Net Debt to EBITDA` double DEFAULT NULL,
  `Cash Gen/Cash Reqd` double DEFAULT NULL,
  `AZS` double DEFAULT NULL,
  `Dvd Yld` double DEFAULT NULL,
  `Tobins Q` double DEFAULT NULL,
  `Board Size` integer DEFAULT NULL,
  `Unit or 2 Tier Bd Sys` integer DEFAULT NULL,
  `# Empl Reps on Bd` integer DEFAULT NULL,
  `Clssfd Bd Sys` varchar(1) DEFAULT NULL,
  `# Non Exec Dir on Bd` integer DEFAULT NULL,
  `% NonExec Dir on Bd` double DEFAULT NULL,
  `% Indep Directors` double DEFAULT NULL,
  `Indep Directors` integer DEFAULT NULL,
  `CEO Duality` varchar(1) DEFAULT NULL,
  `Indep Chrprsn` varchar(1) DEFAULT NULL,
  `Indep Lead Dir` varchar(1) DEFAULT NULL,
  `Prsdg Dir` varchar(1) DEFAULT NULL,
  `Frmr CEO or its Equiv on Bd` varchar(1) DEFAULT NULL,
  `% Women on Bd` double DEFAULT NULL,
  `# Wmn on Bd` integer DEFAULT NULL,
  `% Feml Execs` double DEFAULT NULL,
  `# Feml Execs` integer DEFAULT NULL,
  `Feml CEO or Equiv` varchar(1) DEFAULT NULL,
  `# Execs / Co Mgrs` integer DEFAULT NULL,
  `Age Young Dir` integer DEFAULT NULL,
  `BOD Age Rng` integer DEFAULT NULL,
  `Age Old Dir` integer DEFAULT NULL,
  `Bd Avg Age` double DEFAULT NULL,
  `Bd Age Limit` integer DEFAULT NULL,
  `Board Duration` integer DEFAULT NULL,
  `Exec Dir Bd Dur` integer DEFAULT NULL,
  `Board Mtgs #` integer DEFAULT NULL,
  `Board Mtg Att %` double DEFAULT NULL,
  `Indep Dir Bd Mtg Att %` double DEFAULT NULL,
  `Sz Aud Cmte` integer DEFAULT NULL,
  `# Indep Dir on Aud Cmte` integer DEFAULT NULL,
  `% Indep Dir on Aud Cmte` double DEFAULT NULL,
  `# Indep Dir on Comp Cmte` integer DEFAULT NULL,
  `% Indep Dir on Comp Cmte` double DEFAULT NULL,
  `% Indep Dir on Nom Cmte` double DEFAULT NULL,
  primary key (Ticker)
);

create table eebp(
  `Ticker` varchar(100) NOT NULL,
  `Tax` double DEFAULT NULL,
  `Norm NI to NI for Cmn %` double DEFAULT NULL,
  `Interest` double DEFAULT NULL,
  `OPM T12M` double DEFAULT NULL,
  `Asset` double DEFAULT NULL,
  `Fincl  l` double DEFAULT NULL,
  `Oper ROE` double DEFAULT NULL,
  `5Yr Avg Adj ROE` double DEFAULT NULL,
  `Dvd P/O` double DEFAULT NULL,
  `Sust Gr Rt` double DEFAULT NULL,
  `EBITDA/Sh` double DEFAULT NULL,
  `P/E` double DEFAULT NULL,
  `EPS` double DEFAULT NULL,
  `P/B` double DEFAULT NULL,
  `P/EBITDA` double DEFAULT NULL,
  `ROE` double DEFAULT NULL,
  `ROC` double DEFAULT NULL,
  `EV/EBITDA T12M` double DEFAULT NULL,
  `Net Debt to EBITDA` double DEFAULT NULL,
  `Cash Gen/Cash Reqd` double DEFAULT NULL,
  `AZS` double DEFAULT NULL,
  `Dvd Yld` double DEFAULT NULL,
  `Tobins Q` double DEFAULT NULL,
  `Board Size` integer DEFAULT NULL,
  `Unit or 2 Tier Bd Sys` integer DEFAULT NULL,
  `# Empl Reps on Bd` integer DEFAULT NULL,
  `Clssfd Bd Sys` varchar(1) DEFAULT NULL,
  `# Non Exec Dir on Bd` integer DEFAULT NULL,
  `% NonExec Dir on Bd` double DEFAULT NULL,
  `% Indep Directors` double DEFAULT NULL,
  `Indep Directors` integer DEFAULT NULL,
  `CEO Duality` varchar(1) DEFAULT NULL,
  `Indep Chrprsn` varchar(1) DEFAULT NULL,
  `Indep Lead Dir` varchar(1) DEFAULT NULL,
  `Prsdg Dir` varchar(1) DEFAULT NULL,
  `Frmr CEO or its Equiv on Bd` varchar(1) DEFAULT NULL,
  `% Women on Bd` double DEFAULT NULL,
  `# Wmn on Bd` integer DEFAULT NULL,
  `% Feml Execs` double DEFAULT NULL,
  `# Feml Execs` integer DEFAULT NULL,
  `Feml CEO or Equiv` varchar(1) DEFAULT NULL,
  `# Execs / Co Mgrs` integer DEFAULT NULL,
  `Age Young Dir` integer DEFAULT NULL,
  `BOD Age Rng` integer DEFAULT NULL,
  `Age Old Dir` integer DEFAULT NULL,
  `Bd Avg Age` double DEFAULT NULL,
  `Bd Age Limit` integer DEFAULT NULL,
  `Board Duration` integer DEFAULT NULL,
  `Exec Dir Bd Dur` integer DEFAULT NULL,
  `Board Mtgs #` integer DEFAULT NULL,
  `Board Mtg Att %` double DEFAULT NULL,
  `Indep Dir Bd Mtg Att %` double DEFAULT NULL,
  `Sz Aud Cmte` integer DEFAULT NULL,
  `# Indep Dir on Aud Cmte` integer DEFAULT NULL,
  `% Indep Dir on Aud Cmte` double DEFAULT NULL,
  `# Indep Dir on Comp Cmte` integer DEFAULT NULL,
  `% Indep Dir on Comp Cmte` double DEFAULT NULL,
  `% Indep Dir on Nom Cmte` double DEFAULT NULL,
  primary key (Ticker)
);

create table spx_esg (
  `Ticker` varchar(100) NOT NULL,
  `Variable` varchar(500) NOT NULL,
  `2011` double DEFAULT NULL,
  `2012` double DEFAULT NULL,
  `2013` double DEFAULT NULL,
  `2014` double DEFAULT NULL,
  `2015` double DEFAULT NULL,
  `2016` double DEFAULT NULL,
  `2017` double DEFAULT NULL
);

create table spx_emissions (
  `Ticker` varchar(100) NOT NULL,
  `Variable` varchar(500) NOT NULL,
  `2011` double DEFAULT NULL,
  `2012` double DEFAULT NULL,
  `2013` double DEFAULT NULL,
  `2014` double DEFAULT NULL,
  `2015` double DEFAULT NULL,
  `2016` double DEFAULT NULL,
  `2017` double DEFAULT NULL
);

create table spx_energy (
  `Ticker` varchar(100) NOT NULL,
  `Variable` varchar(500) NOT NULL,
  `2011` double DEFAULT NULL,
  `2012` double DEFAULT NULL,
  `2013` double DEFAULT NULL,
  `2014` double DEFAULT NULL,
  `2015` double DEFAULT NULL,
  `2016` double DEFAULT NULL,
  `2017` double DEFAULT NULL
);

create table spx_actual_new_income_per_employee (
  `Ticker` varchar(100) NOT NULL,
  `Variable` varchar(500) NOT NULL,
  `2011` double DEFAULT NULL,
  `2012` double DEFAULT NULL,
  `2013` double DEFAULT NULL,
  `2014` double DEFAULT NULL,
  `2015` double DEFAULT NULL,
  `2016` double DEFAULT NULL,
  `2017` double DEFAULT NULL
);

create table spx_cash_flow_per_employee (
  `Ticker` varchar(100) NOT NULL,
  `Variable` varchar(500) NOT NULL,
  `2011` double DEFAULT NULL,
  `2012` double DEFAULT NULL,
  `2013` double DEFAULT NULL,
  `2014` double DEFAULT NULL,
  `2015` double DEFAULT NULL,
  `2016` double DEFAULT NULL,
  `2017` double DEFAULT NULL
);

create table spx_ghg_scope_1 (
  `Ticker` varchar(100) NOT NULL,
  `Variable` varchar(500) NOT NULL,
  `2011` double DEFAULT NULL,
  `2012` double DEFAULT NULL,
  `2013` double DEFAULT NULL,
  `2014` double DEFAULT NULL,
  `2015` double DEFAULT NULL,
  `2016` double DEFAULT NULL,
  `2017` double DEFAULT NULL
);

create table spx_mscore (
  `Ticker` varchar(100) NOT NULL,
  `Variable` varchar(500) NOT NULL,
  `10_2013` double DEFAULT NULL,
  `12_2013` double DEFAULT NULL,
  `10_2014` double DEFAULT NULL,
  `12_2014` double DEFAULT NULL,
  `10_2015` double DEFAULT NULL,
  `12_2015` double DEFAULT NULL,
  `10_2016` double DEFAULT NULL,
  `12_2016` double DEFAULT NULL
);

create table spx_csr (
  `Ticker` varchar(100) NOT NULL,
  `Variable` varchar(500) NOT NULL,
  `2012` double DEFAULT NULL,
  `2013` double DEFAULT NULL,
  `2014` double DEFAULT NULL,
  `2015` double DEFAULT NULL,
  `2016` double DEFAULT NULL
);

create table spx_ceo_comp (
  `Ticker` varchar(100) NOT NULL,
  `Variable` varchar(500) NOT NULL,
  `2010` double DEFAULT NULL,
  `2011` double DEFAULT NULL,
  `2012` double DEFAULT NULL,
  `2013` double DEFAULT NULL,
  `2014` double DEFAULT NULL,
  `2015` double DEFAULT NULL,
  `2016` double DEFAULT NULL,
  `2017` double DEFAULT NULL
);
