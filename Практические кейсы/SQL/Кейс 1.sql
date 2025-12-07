select s.security, s.sector,
case when s.sector = 'Health Care' then 'Health Care'
else 'Insurance'
end as category,
s.sub_industry, split_part(adress, ',', 1) as city from securities s

where split_part(adress, ',', 1) = 'New York' and s.sector in('Health Care','Financials') and (s.sector = 'Health Care' or lower(s.sub_industry) like('%insurance%'))
order by s.sector, s.sub_industry, s.security



