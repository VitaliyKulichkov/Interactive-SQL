Глава 1. Основы реляционной модели и SQL
Раздел 1.1
1.1.6
create table book (book_id int primary key auto_increment, title varchar(50), author varchar(30), price decimal(8,2),
amount int);

1.1.7
insert into book (book_id, title, author, price, amount) values (1, "Мастер и Маргарита", "Булгаков М.А.",
                                                                670.99, 3)

1.1.8
insert into book (book_id, title, author, price, amount) values (2, "Белая гвардия", "Булгаков М.А.",
                                                                540.50, 5);
insert into book (book_id, title, author, price, amount) values (3, "Идиот", "Достоевский Ф.М.",
                                                                460.00, 10);
insert into book (book_id, title, author, price, amount) values (4, "Братья Карамазовы", "Достоевский Ф.М.",
                                                                799.01, 2);
Раздел 1.2
1.2.2
select * from book

1.2.3
select author, title, price from book

1.2.4
select title as Название, author as Автор from book

1.2.5
select title, amount, 1.65*amount as pack from book

1.2.6
select title, author, amount, round(price*0.7, 2) as new_price from book

1.2.7
select
  author,
  title,
  round(if(author="Булгаков М.А.", price*1.1, if(author="Есенин С.А.", price*1.05, price)), 2) as new_price
from book

1.2.8
select author, title, price from book
where amount<10

1.2.9
select title, author, price, amount from book
where price < 500 and price*amount >= 5000 or price > 600 and price*amount >= 5000

1.2.10
select title, author from book
where  price between 540.50 and 800 and amount in (2,3,5,7)

1.2.11
select title, author from book where title like "_% _%" and author like "% С.%"

1.2.12
select author, title from book
where amount between 2 and 14
order by author desc, title

1.2.13
select * from book where author like '%Дос%'

Раздел 1.3
1.3.2
select distinct amount from book

1.3.3
select
  author as Автор,
  count(title) as "Различных_книг",
  sum(amount) as "Количество_экземпляров"
from book
group by author

1.3.4
select author, min(price) as Минимальная_цена, max(price) as Максимальная_цена, avg(price) as Средняя_цена
from book
group by author

1.3.5
select
  author,
  sum(price*amount) as Стоимость,
  round(sum(price*amount)*0.18/1.18, 2) as НДС,
  round(sum(price*amount)/1.18, 2) as Стоимость_без_НДС
from book
group by author

1.3.6
select min(price) as Минимальная_цена, max(price) as Максимальная_цена, round(avg(price), 2) as Средняя_цена
from book

1.3.7
select round(avg(price), 2) as Средняя_цена, round(sum(price*amount), 2) as Стоимость
from book
where amount between 5 and 14

1.3.8
select author, sum(price*amount) as Стоимость
from book
where title not in ("Идиот", "Белая гвардия")
group by author
having sum(price*amount) > 5000
order by Стоимость desc

