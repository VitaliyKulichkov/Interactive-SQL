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

1.4.2
select author, title, price
from book
where price<=(select avg(price) from book)
order by price desc

1.4.3
select author, title, price
from book
where price - (select min(price) from book) <= 150
order by price asc

1.4.4
select author, title, amount
from book
where amount in (select amount from book group by amount having count(amount)=1)

1.4.5
select author, title, price
from book
where price < ANY (
    select MIN(price)
    from book
    group by author
)

1.4.6
select title, author, amount, (select max(amount) from book) - amount as Заказ
from book
having Заказ > 0

1.5.2
create table supply(supply_id INT PRIMARY KEY AUTO_INCREMENT, title VARCHAR(50), author VARCHAR(30), price DECIMAL(8, 2), amount INT)

1.5.3
insert into supply(supply_id, title, author, price, amount) values (1, 'Лирика', 'Пастернак Б.Л.', 518.99, 2);
insert into supply(supply_id, title, author, price, amount) values (2, 'Черный человек', 'Есенин С.А.', 570.20, 6);
insert into supply(supply_id, title, author, price, amount) values (3, 'Белая гвардия', 'Булгаков М.А.', 540.50, 7);
insert into supply(supply_id, title, author, price, amount) values (4, 'Идиот', 'Достоевский Ф.М.', 360.80, 3);

1.5.4
insert into book (title, author, price, amount)
select title, author, price, amount
from supply
where author not in ('Булгаков М.А.', 'Достоевский Ф.М.')

1.5.5
insert into book (title, author, price, amount)
select title, author, price, amount
from supply
where author not in (select distinct author from book)

1.5.6
update book set price = 0.9*price
where amount between 5 and 10

1.5.7
update book set buy = if(buy > amount, amount, buy),
                price = if(buy = 0, price * 0.9, price);

1.5.8
update book, supply set book.amount=supply.amount+book.amount, book.price=(book.price+supply.price)/2
where book.title=supply.title

1.5.9
delete from supply
where author in (
  select author
  from book
  group by author
  having sum(amount) > 10
)

1.5.10
create table ordering as
select author, title, (select avg(amount) from book) as amount
from book
where amount<(select avg(amount) from book);

1.6.2
select name, city, per_diem, date_first, date_last
from trip
where name like '%а %.'
order by date_last desc

1.6.3
select distinct name from trip
where city='Москва'
order by name

1.6.4
select city, count(*) as Количество
from trip
group by city
order by city

1.6.5
select city, count(*) as Количество
from trip
group by city
order by Количество desc
limit 2

1.6.6
select name, city, datediff(date_last, date_first)+1 as Длительность
from trip
where city not in ('Москва', "Санкт-Петербург")
order by Длительность desc, city desc

1.6.7
select name, city, date_first, date_last
from trip
where DATEDIFF(date_last, date_first) = (
    select MIN(DATEDIFF(date_last, date_first))
    from trip
)

1.6.8
select name, city, date_first, date_last
from trip
where month(date_last)=month(date_first)
order by city, name

1.6.9
select MONTHNAME(date_first) as Месяц, count(*) as Количество
from trip
group by Месяц
order by Количество desc, Месяц

1.6.10
select name, city, date_first, per_diem*(datediff(date_last, date_first)+1) as Сумма
from trip
where month(date_first) in (2, 3)
order by name, Сумма desc

1.6.11
select name, sum((datediff(date_last, date_first)+1)*per_diem) as Сумма
from trip
group by name
having count(*) > 3
order by 2 desc

1.7.2
create table fine(fine_id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(30), number_plate VARCHAR(6),
                 violation VARCHAR(50), sum_fine DECIMAL(8,2), date_violation DATE, date_payment DATE)

1.7.3
insert into fine(fine_id, name, number_plate, violation, sum_fine, date_violation, date_payment)
           values(6, "Баранов П.Е.", 'Р523ВТ', 'Превышение скорости(от 40 до 60)', Null, '2020-02-14', Null);
insert into fine(fine_id, name, number_plate, violation, sum_fine, date_violation, date_payment)
           values(7, "Абрамова К.А.", 'О111АВ', 'Проезд на запрещающий сигнал', Null, '2020-02-23', Null);
insert into fine(fine_id, name, number_plate, violation, sum_fine, date_violation, date_payment)
           values(8, "Яковлев Г.Р.", 'Т330ТТ', 'Проезд на запрещающий сигнал', Null, '2020-03-03', Null);

1.7.4
Update fine as f, traffic_violation as tv
set f.sum_fine=tv.sum_fine
where f.violation=tv.violation and f.sum_fine is null

1.7.5
select name, number_plate, violation
from fine
group by name, number_plate, violation
having count(*) > 1
order by name

1.7.6
update fine, (select name, number_plate, violation
from fine
group by name, number_plate, violation
having count(*) > 1
order by name) as new_fine
set fine.sum_fine=fine.sum_fine*2
where date_payment is null and
           new_fine.name=fine.name and
           new_fine.number_plate=fine.number_plate and
           new_fine.violation=fine.violation

1.7.7
update fine, payment
set fine.date_payment=payment.date_payment,
fine.sum_fine=if(datediff(payment.date_payment, fine.date_violation) <= 20, fine.sum_fine/2, fine.sum_fine)
where fine.name=payment.name and
fine.number_plate=payment.number_plate and
fine.violation=payment.violation and
fine.date_payment is null

1.7.8
create table back_payment as (select name, number_plate, violation, sum_fine, date_violation from fine
where date_payment is null)

1.7.9
delete from fine
where date_violation < '2020-02-01'

Глава 2. Запросы SQL к связанным таблицам

2.1.6
create table author (author_id INT PRIMARY KEY AUTO_INCREMENT, name_author VARCHAR(50))

2.1.7
insert into author(author_id, name_author)
values
(1, 'Булгаков М.А.'),
(2, 'Достоевский Ф.М.'),
(3, 'Есенин С.А.'),
(4, 'Пастернак Б.Л.')

2.1.8
CREATE TABLE book (
      book_id INT PRIMARY KEY AUTO_INCREMENT,
      title VARCHAR(50),
      author_id INT NOT NULL,
      genre_id INT,
      price DECIMAL(8,2),
      amount INT,
      FOREIGN KEY (author_id)  REFERENCES author (author_id),
      FOREIGN KEY (genre_id)  REFERENCES genre (genre_id)
)

2.1.9
CREATE TABLE book (
      book_id INT PRIMARY KEY AUTO_INCREMENT,
      title VARCHAR(50),
      author_id INT,
    genre_id INT,
      price DECIMAL(8,2),
      amount INT,
      FOREIGN KEY (author_id)  REFERENCES author (author_id) ON DELETE CASCADE,
      FOREIGN KEY (genre_id)  REFERENCES genre (genre_id) ON DELETE set null
)

2.1.11
insert into book (book_id, title, author_id, genre_id, price, amount)
values
    (6, "Стихотворения и поэмы", 3, 2, 650.00, 15),
    (7, "Черный человек", 3, 2, 570.20, 6),
    (8, "Лирика", 4, 2, 518.99, 2)

2.2.2
select title, name_genre, price
from book
inner join genre
on genre.genre_id=book.genre_id
where amount > 8
order by price desc

2.2.3
select name_genre from genre
left join book
on book.genre_id=genre.genre_id
where amount is null

2.2.4
select name_city, name_author, date_add('2020-01-01', interval 'FLOOR(RAND()*365)' day) as Дата
from author
cross join city

2.2.5
select name_genre, title, name_author
from book
inner join author
on book.author_id=author.author_id
inner join genre
on book.genre_id=genre.genre_id
where name_genre='Роман'
order by title

2.2.6
select name_author, sum(amount) as Количество
from author
left join book on author.author_id=book.author_id
group by name_author
having sum(amount) < 10 or Количество is null
order by Количество

2.2.7
SELECT book.title, author.name_author, genre.name_genre, book.price, book.amount
FROM book INNER JOIN author ON book.author_id = author.author_id INNER JOIN genre ON book.genre_id = genre.genre_id
WHERE book.genre_id IN (
    SELECT genre_id
    FROM book
    GROUP BY genre_id
    HAVING SUM(amount) = (
        SELECT MAX(sum_amount)
        FROM (
            SELECT SUM(amount) sum_amount
            FROM book
            GROUP BY genre_id
        ) max_amount
    )
)
ORDER BY book.title;
