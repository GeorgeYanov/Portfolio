
-- Создаем таблицу
create table prices_stock (
"date" date,
"symbol" varchar(10),
"open" double precision,
"close" double precision,
"low" double precision,
"high" double precision,
"volume" double precision
)
-- переименовываем таблицу, если вдруг накосячили с названием
alter table prices_stock rename to prices_new

-- добавляем новыую колонку, если что-то забыли
alter table prices_new add column in_portfolio boolean

-- добавляем первичный ключ, чтобы в каждой строчке был уникальный элемент, по которому в будущем можно будет соединить таблицы или проще находить в них какую-либо информацию
alter table prices_new add constraint prices_new_pk primary key ("date","symbol")

-- добавляем значения, чтобы наша таблица имела какие-либо данные
insert into prices_new ("date", "symbol", "open", "close", "low", "high", "volume","in_portfolio")
values ('2024-05-05','RUSS',124,125,121,129,4000000,True)

-- обновляем данные, если вдруг накосячили при вводе этих данных
update prices_new
set high = 130
where symbol = 'RUSS' and date ='2024-05-05'

-- добавляем еще данные, чтобы учесть предшествующий период и получить более полную картину
insert into prices_new ("date", "symbol", "open", "close", "low", "high", "volume","in_portfolio")
values ('2024-05-04','RUSS',0,0,0,0,0,True)