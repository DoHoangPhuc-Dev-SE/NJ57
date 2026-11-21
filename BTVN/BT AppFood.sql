create database AppFood;
go
use AppFood;
go
create table [user] (
    user_id int identity(1,1) primary key,
    full_name nvarchar(255),
    email varchar(255),
    [password] varchar(255)
);
create table restaurant (
    res_id int identity(1,1) primary key,
    res_name nvarchar(255),
    [image] varchar(255),
    [desc] nvarchar(255)
);
create table food_type (
    type_id int identity(1,1) primary key,
    type_name nvarchar(255)
);
create table food (
    food_id int identity(1,1) primary key,
    food_name nvarchar(255),
    [image] varchar(255),
    price float,
    [desc] nvarchar(255),
    type_id int foreign key references food_type(type_id)
);
create table sub_food (
    sub_id int identity(1,1) primary key,
    sub_name nvarchar(255),
    sub_price float,
    food_id int foreign key references food(food_id)
);
create table [order] (
    user_id int foreign key references [user](user_id),
    food_id int foreign key references food(food_id),
    amount int,
    code varchar(100),
    arr_sub_id varchar(255)
);
create table rate_res (
    user_id int foreign key references [user](user_id),
    res_id int foreign key references restaurant(res_id),
    amount int,
    date_rate datetime
);
create table like_res (
    user_id int foreign key references [user](user_id),
    res_id int foreign key references restaurant(res_id),
    date_like datetime
);
go
exec sp_help [user];
exec sp_help restaurant;
exec sp_help food_type;
exec sp_help food;
go
insert into [user] (full_name, email, [password]) values
(N'nguyễn văn a', 'a@gmail.com', '123456'),
(N'trần thị b', 'b@gmail.com', '123456'),
(N'lê văn c', 'c@gmail.com', '123456'),
(N'phạm thị d', 'd@gmail.com', '123456'),
(N'hoàng văn e', 'e@gmail.com', '123456'),
(N'võ thị f', 'f@gmail.com', '123456'),
(N'đỗ văn g', 'g@gmail.com', '123456'); 
insert into restaurant (res_name, [image], [desc]) values
(N'nhà hàng cơm tấm', 'comtam.jpg', N'cơm tấm sườn bì chả'),
(N'nhà hàng bún bò', 'bunbo.jpg', N'bún bò huế chuẩn vị'),
(N'nhà hàng lẩu thái', 'lauthai.jpg', N'lẩu thái chua cay'),
(N'nhà hàng gà rán', 'garan.jpg', N'gà rán giòn rụm');
insert into food_type (type_name) values
(N'món chính'),
(N'món nước'),
(N'đồ ăn vặt');
insert into food (food_name, [image], price, [desc], type_id) values
(N'cơm sườn', 'comsuon.jpg', 45000, N'cơm sườn nướng', 1),
(N'bún bò đặc biệt', 'bunbo_db.jpg', 55000, N'đầy đủ topping', 2),
(N'lẩu hải sản', 'lauhs.jpg', 250000, N'nồi lớn 4 người', 2),
(N'gà cay phô mai', 'gacay.jpg', 85000, N'gà sốt cay phủ phô mai', 3);
insert into sub_food (sub_name, sub_price, food_id) values
(N'trứng ốp la', 10000, 1),
(N'chả trứng', 12000, 1),
(N'thêm bò tái', 20000, 2),
(N'khoai tây chiên', 25000, 4);
insert into like_res (user_id, res_id, date_like) values
(1, 1, '2026-11-01 10:00:00'),
(1, 2, '2026-11-02 11:00:00'),
(1, 3, '2026-11-03 12:00:00'),
(1, 4, '2026-11-04 13:00:00'),
(2, 1, '2026-11-01 14:00:00'),
(2, 2, '2026-11-02 15:00:00'),
(2, 3, '2026-11-03 16:00:00'),
(3, 1, '2026-11-01 17:00:00'),
(3, 2, '2026-11-02 18:00:00'),
(4, 1, '2026-11-01 19:00:00'),
(4, 3, '2026-11-02 20:00:00'),
(5, 1, '2026-11-01 21:00:00'),
(6, 2, '2026-11-01 22:00:00');
insert into rate_res (user_id, res_id, amount, date_rate) values
(1, 1, 5, '2026-11-05 10:00:00'),
(2, 2, 4, '2026-11-05 11:00:00'),
(6, 3, 5, '2026-11-05 12:00:00');
insert into [order] (user_id, food_id, amount, code, arr_sub_id) values
(2, 1, 2, 'ord01', '1,2'),
(2, 2, 1, 'ord02', '3'),
(2, 4, 3, 'ord03', '4'),
(1, 1, 1, 'ord04', '1'),
(1, 3, 1, 'ord05', ''),
(3, 2, 2, 'ord06', '3');
go
select top 5 u.user_id, u.full_name, u.email, count(lr.res_id) as so_luot_like
from [user] u
join like_res lr on u.user_id = lr.user_id
group by u.user_id, u.full_name, u.email
order by so_luot_like desc
select top 2 r.res_id, r.res_name, count(lr.user_id) as so_luot_like
from restaurant r
join like_res lr on r.res_id = lr.res_id
group by r.res_id, r.res_name
order by so_luot_like desc;
select top 1 u.user_id, u.full_name, u.email, count(o.food_id) as so_lan_dat, sum(o.amount) as tong_so_mon
from [user] u
join [order] o on u.user_id = o.user_id
group by u.user_id, u.full_name, u.email
order by so_lan_dat desc, tong_so_mon desc;
select u.user_id, u.full_name, u.email
from [user] u
left join [order] o on u.user_id = o.user_id
left join like_res lr on u.user_id = lr.user_id
left join rate_res rr on u.user_id = rr.user_id
where o.user_id is null
  and lr.user_id is null
  and rr.user_id is null;