/*
 * Гипотетическая база одного из многих гипотетических госучреждений. 
 * Назначением является накопление и агрегация данных о гипотетических жителях страны, региона, города и т.п. 
 * В любой момент можно получить сведения о месте фактического проживания, возрасте, документах, аккаунтах в соцсетях, 
 * 	банковских счетах, месте регистрации и любой другой всевозможной информации при должном наполнении.
 * В базе присутствуют триггеры для избежания вставки нулевых значений в некоторые таблицы, которые при отсутствии значений не 
 * 	имеют смысла.
 * Есть процедура поиска сообществ в городе искомого гражданина.
 * Представление по "нелояльным" сообществам.
 * Представление по Обычному поиску 
 * В конце есть несколько примеров типовых запросов.
 * 
 * 
 * Ссылка на ERDiagram
 * https://drive.google.com/file/d/15-eTYv-7be898yAgOad9M1PkNuJJSuK-/view?usp=sharing
*/


drop database if exists base_of_citizens;
create database base_of_citizens;
use base_of_citizens;

drop table if exists citizens;
create table citizens(
	id serial primary key,
	lastname varchar(100),
	firstname varchar(100),
	secondname varchar(100),
	birth_date varchar(20),
	created_at datetime default now(),
	updated_at datetime default now() on update current_timestamp,
	index (firstname, secondname, lastname)
);
ALTER TABLE base_of_citizens.citizens MODIFY COLUMN birth_date DATE NULL;


drop table if exists profiles;
create table profiles(
	citizen_id SERIAL primary key,
	gender char(1),
	birth_town varchar(100),
	email varchar(100) unique,
	phone varchar(12) unique,
	created_at datetime default now(),
	updated_at datetime default now(),
	
	
	index (email),
	index (phone)
);

alter table `profiles`
add constraint fk_citizen_id
	foreign key (citizen_id) references citizens(id)
	on update cascade
	on delete restrict
;



drop table if exists passport;
create table passport(
	id serial primary key,
	serial_number varchar(10) unique,
	date_of_issue date,
	issued_by text,
	dep_code varchar(7),
	foreign key (id) references citizens(id) ON UPDATE CASCADE ON DELETE restrict,	
	index (serial_number)
);

drop table if exists reg_address;
create table reg_address (
	citizen_id SERIAL primary key,
	region varchar(255),
	`index` bigint unsigned null,
	city varchar(100),
	street varchar(255),
	home varchar(255),
	apart int(4),
	foreign key (citizen_id) references profiles(citizen_id) ON UPDATE CASCADE ON DELETE restrict,
	created_at datetime default now(),
	updated_at datetime default now(),
	
	index (city)
);
drop table if exists fact_address;
create table fact_address (
	citizen_id SERIAL primary key,
	region varchar(255),
	`index` bigint unsigned null,
	city varchar(100),
	street varchar(255),
	home varchar(255),
	apart int(4),
	foreign key (citizen_id) references profiles(citizen_id) ON UPDATE CASCADE ON DELETE restrict,
	created_at datetime default now(),
	updated_at datetime default now(),
	
	index (city)
);


drop table if exists social_networks;
create table social_networks(
	id SERIAL primary key,
	soc_net_name varchar(255),
		
	index (soc_net_name)

);


drop table if exists communities;
create table communities (
	id SERIAL primary key,
	soc_net_id bigint unsigned not null,
	name varchar(150),
	link_to_community text, 
	loyal_to_authority enum('loyal', 'disloyal', 'unknown'),
	foreign key (soc_net_id) references social_networks(id) ON UPDATE CASCADE ON DELETE restrict,
	
	index (name)
);

drop table if exists citizens_communities;
create table citizens_communities (
	cit_id bigint unsigned not null,
	community_id bigint unsigned default null,
	foreign key (cit_id) references citizens(id) ON UPDATE CASCADE ON DELETE restrict,
	foreign key (community_id) references communities(id) ON UPDATE CASCADE ON DELETE restrict,
	created_at datetime default now(),
	updated_at datetime default now()
	
);

drop table if exists photos;
create table photos(
	id SERIAL primary key,
	photos_id varchar(100) unique,
	
	foreign key (id) references profiles(citizen_id) ON UPDATE CASCADE ON DELETE restrict
	 
);

drop table if exists bank_list;
create table bank_list(
	id serial primary key,
	bank_name varchar(255),
	
	index (bank_name)

)
;

drop table if exists bank_accounts;
create table bank_accounts(
	id serial primary key,
	bank_id bigint unsigned not null,
	account_num varchar(14) unique,
	
	foreign key (id) references profiles(citizen_id) ON UPDATE CASCADE ON DELETE restrict,
	foreign key (bank_id) references bank_list(id) ON UPDATE CASCADE ON DELETE restrict
)
;

	-- Скрипты наполнения базы данных. Все данные и имена являются вымышленными, любые совпадения случайны.

INSERT INTO `citizens` (`lastname`, `firstname`, `secondname`, `birth_date`) VALUES 
('Луначарская', 'Алиса', 'Ивановна', '1999.10.19.'),
('Васильев', 'Дмитрий', 'Валерьевич', '1971.01.24.'),
('Добровольская', 'Екатерина', 'Ивановна', '1956.05.30.'),
('Влади', 'Игорь', 'Игоревич','1963.12.18.'),
('Кашицина', 'Алевтина', 'Николаевна', '2003.05.13.'),
('Николаев', 'Павел', 'Николаевич','1926.11.19.'),
('Туполев', 'Владимир', 'Борисович','1956.05.30.'),
('Кувалдин', 'Петр', 'Алексеевич', '1979.05.13.'),
('Котова', 'Алевтина', 'Станиславовна', '1981.09.13.'),
('Голубева', 'Амалия', 'Алексеевна', '1971.06.02.'),
('Хохлов', 'Виктор', 'Леонидович', '1961.05.25.'),
('Ходорковский', 'Адриан', 'Петрович', '2005.04.28.'),
('Миллер', 'Григорий', 'Михайлович', '1960.01.01.'),
('Высоцкий', 'Глеб', 'Андреевич', '1974.09.13.'),
('Шкурат', 'Людмила', 'Олеговна', '1979.06.15.'),
('Кувалдин', 'Виктор', 'Николаевич', '1981.04.11.'),
('Андреева', 'Алевтина', 'Вячеславовна', '1980.09.23.'),
('Кириллов', 'Юрий', 'Анатольевич', '1976.05.17.'),
('Крайнов', 'Олег', 'Дмитриевич', '1989.05.13'),
('Сергеева', 'Варвара', 'Юрьевна', '1976.02.13.')
;

INSERT INTO `profiles` (`citizen_id`, `gender`, `birth_town`, `email`, phone) values
(1, 'ж', 'Москва', 'luna911@mail.ru', '+79263543212'),
(2, 'м', 'Москва', 'vasil234@mail.ru', '+79266996336'),
(3, 'ж', 'Москва', 'dobroei@gmail.com', '+79201234565'),
(4, 'м', 'Ульяновск', 'vladi1@yahoo.com', '+79263542552'),
(5, 'ж', 'Тобольск', 'alya1981@mail.ru', '+79161338778'),
(6, 'м', 'Владимир', null, '+79050551881'),
(7, 'м', 'Москва', 'tupolev@mail.ru', '+79336769825'),
(8, 'м', 'Благовещенск', 'petya79@mail.ru', '+79031112233'),
(9, 'ж', 'Москва', 'kotya111@bk.ru', '+79253336699'),
(10, 'ж', 'Санкт-Петербург', 'golubeva_amaliya@mail.ru', '+79884554545'),
(11, 'м', 'Иваново', 'xoxlov61@gmail.com', '+79011011010'),
(12, 'м', 'Москва', 'adrianx@yandex.ru', '+79521184575'),
(13, 'м', 'Новосибирск', 'miller2011@mail.ru', '+79082036589'),
(14, 'м', 'Тюмень', 'letchik777@list.ru', '+79091477474'),
(15, 'ж', 'Москва', 'shkurat_l_o@mail.ru', '+79029996556'),
(16, 'м', 'Королев', 'kuvaldin35@mail.com', '+79095699512'),
(17, 'ж', 'Туапсе', 'AVAndreeva1@rambler.ru', '+79218522552'),
(18, 'м', 'Воркута', 'kiruxa75@mail.ru', '+79201123223'),
(19, 'м', 'Ростов-на-Дону', 'oleg56@mail.ru', '+79283543212'),
(20, 'ж', 'Москва', 'barbara123@gmail.com', '+79163543212')
;

INSERT INTO fact_address (region, `index`, city, street, home, apart, created_at, updated_at) values
('Московская область', '115225', 'Москва', 'Азовская', '3', '74', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Московская область', '115598', 'Москва', 'Кедровая', '17', '55', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Московская область', '144236', 'Москва', 'Лесная', '135', '389', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Ульяновская область', '241328', 'Ульяновск', 'Строителей', '1', '12', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Тюменская область', '692331', 'Тобольск', 'Главная', '6', '26', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Владимирская область', '377111', 'Владимир', 'Моховая', '25', '114', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Московская область', '114908', 'Москва', 'Востряковский пр-д', '11', '1', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Московская область', '111000', 'Москва', 'Липецкая', '7А', '13', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Московская область', '285895', 'Москва', 'Строгинская', '14', '155', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Ленинградская область', '413112', 'Санкт-Петербург', 'Авиастроителей', '100', '28', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Ивановская область', '155332', 'Иваново', 'Текстильщиков пр-т', '17А', '255', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Московская область', '265395', 'Москва', 'Зеленая', '25', '112', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Новосибирская область', '488113', 'Новосибирск', 'Сталеваров', '87', '51', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Тюменская область', '692327', 'Тюмень', 'Таежная', '13', '26', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Московская область', '295511', 'Москва', 'Теплый Стан', '5', '19', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Московская область', '211299', 'Королев', 'Королёва', '1', '32', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Краснодарский край', '378225', 'Туапсе', 'Приморская', '10', '2', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Республика Коми', '169900', 'Воркута', 'Покровского', '18', '8', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Московская область', '295511', 'Москва', 'Теплый Стан', '11', '79', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Московская область', '127000', 'Москва', 'Шипиловская', '125', '35', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
;

INSERT INTO reg_address (region, `index`, city, street, home, apart, created_at, updated_at) values
('Московская область', '115225', 'Москва', 'Азовская', '3', '74', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Московская область', '115598', 'Москва', 'Кедровая', '17', '55', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Московская область', '144236', 'Москва', 'Лесная', '135', '389', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Ульяновская область', '241328', 'Ульяновск', 'Строителей', '1', '12', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Тюменская область', '692331', 'Тобольск', 'Главная', '6', '26', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Владимирская область', '377111', 'Владимир', 'Моховая', '25', '114', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Московская область', '114908', 'Москва', 'Востряковский пр-д', '11', '1', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Амурская область', '635824', 'Благовещенск', 'Ореховая', '90', '40', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Московская область', '285895', 'Москва', 'Строгинская', '14', '155', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Ленинградская область', '413112', 'Санкт-Петербург', 'Авиастроителей', '100', '28', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Ивановская область', '155332', 'Иваново', 'Текстильщиков пр-т', '17А', '255', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Московская область', '265395', 'Москва', 'Зеленая', '25', '112', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Новосибирская область', '488113', 'Новосибирск', 'Сталеваров', '87', '51', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Тюменская область', '692327', 'Тюмень', 'Таежная', '13', '26', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Московская область', '295511', 'Москва', 'Теплый Стан', '5', '19', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Московская область', '211299', 'Королев', 'Королёва', '1', '32', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Краснодарский край', '378225', 'Туапсе', 'Приморская', '10', '2', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Республика Коми', '169900', 'Воркута', 'Покровского', '18', '8', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Ростовская область', '598331', 'Ростов-на-Дону', 'Сельская', '100', '14', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Московская область', '127000', 'Москва', 'Шипиловская', '125', '35', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
;

INSERT INTO passport (serial_number, date_of_issue, issued_by, dep_code) values
(2405147969, '2012-12-26', 'ОВД города Москвы по району Зюзино', '123-321' ),
(2489147158, '2000-12-10', 'ОВД города Москвы по району Гольяново', '321-123'),
(2504965851, '2006-06-06', 'ОВД города Москвы по району Хамовники', '145-521'),
(5689123547, '1999-01-30', 'ОВД Левобережный города Ульяновск', '765-658'),
(3409655454, '2008-03-13', 'ОВД города Тобольск Тобольской области', '525-252'),
(2489978158, '2001-11-10', 'УВД по городу Владимир Владимирской области', '423-986'),
(2403301258, '2000-05-19', 'ОВД города Москвы по району Бирюлево Западное', '128-555'),
(7489877155, '2005-09-22', 'ОВД города Благовещенск Амурского края', '325-923'),
(2089365177, '2014-12-24', 'ОВД города Москвы по району Строгино', '333-333'),
(5231111232, '1998-04-25', 'УмВД по городу Санкт-Петербург по району Автово', '141-797'),
(4508133651, '2015-02-02', 'ОВД города Иваново Ивановской области', '371-731'),
(2365147158, '2013-11-16', 'ОВД города Москвы по району Перово', '565-365'),
(1178955634, '2002-10-29', 'ОВД города Новосибирск', '111-222'),
(8923147787, '2007-11-08', 'ОВД города Тюмени', '425-553'),
(2252364463, '2007-02-18', 'ОВД города Москвы по району Ясенево', '826-354'),
(3526324441, '2001-07-29', 'ОВД города Королев Московской области', '189-368'),
(5601883345, '2013-06-21', 'ОВД города Туапсе Краснодарского края', '155-632'),
(3378955182, '2002-10-05', 'УВД по городу Воркута', '233-677'),
(5578951774, '2002-07-29', 'ОВД города Ростов-на-Дону', '065-011'),
(4705955222, '1998-01-18', 'ОВД города Москвы по району Зябликово', '521-100')
;

insert into social_networks (id, soc_net_name) values
(1, 'Youtube'),
(2, 'Вконтакте'),
(3, 'Одноклассники'),
(4, 'Facebook'),
(5, 'Instagramm')  
;

INSERT INTO `communities` (`soc_net_id`, `name`, `link_to_community`, `loyal_to_authority`) values
(1, 'НавальныйLive', 'https://www.youtube.com/channel/UCgxTPTFbIbCWfTR9I2-5SeQ/featured', 'disloyal'),
(1, 'Bulkin', 'https://www.youtube.com/channel/UCtWY35eYO7jI9LnCRJxBGRQ', 'unknown'),
(1, 'ХВАТИТ МОЛЧАТЬ!', 'https://www.youtube.com/channel/UCGzzQZ7Yh_05VX4soU9_Hzw', 'disloyal'),
(1, 'RT', 'https://www.youtube.com/user/RussiaToday', 'loyal'),
(1, 'Россия 24', 'https://www.youtube.com/user/Russia24TV', 'loyal'),
(1, 'Телеканал Дождь', 'https://www.youtube.com/channel/UCdubelOloxR3wzwJG9x8YqQ', 'disloyal'),
(1, 'Discovery Channel Россия', 'https://www.youtube.com/user/DchRussia', 'unknown'),
(1, 'Рики', 'https://www.youtube.com/user/riki', 'unknown'),
(1, 'kamikadzedead', 'https://www.youtube.com/channel/UCDbsY8C1eQJ5t6KBv9ds-ag', 'disloyal'),
(1, 'Вечер с Владимиром Соловьевым', 'https://www.youtube.com/user/PoedinokTV', 'loyal'),
(2, 'Сатира без позитива', 'https://vk.com/satyrabezsortyra', 'disloyal'),
(2, 'AdMe.ru', 'https://vk.com/adme', 'unknown'),
(2, 'Jove', 'https://vk.com/thejoves', 'unknown'),
(4, 'Новая газета', 'https://www.facebook.com/novgaz/?__tn__=kC-R&eid=ARCq4Vz1ksCLtSxGh2Sh9Aj_UmVFro7ZIhnhwyPF9JRi328iugmElJKHU51yPfp_HujlaFzKEeYuDab1&hc_ref=ARSc0CSWFcjcQbV0rXYlEEL0lROHm9tL1I6uBt255tiwLNwTg6ZH1FZgt0CGfFxajWg&fref=nf&__xts__[0]=68.ARA44JOZSSe6xCXkBmdbyiTGAba_6VvDpqqdTogTNGKN-N7Jcan4emp09kMYpSY9YvHNJBwdDdY4-LW_gOYUwgv3xSyCwDP0vpel79NZ9v_pj9I8jc4B4Jm9A31uAQ5H75dz5_5Jk-y6iWhwiECl3oz8FKAAX-C52er3NeswdxmJan5QoorKdRxjAhPQp9Y9SheFYSjyD9sTdxTil8Rc5E4pNw57VZC0ZfZ-oYq_-4HHWWAvWsmATc-QVCIcgWNr0p-r65N_4SmqGiuwRwZIio2iDK02PG8OoYweWuaGVE2sSvahsOC-AzpuAbP5PFrynDEXuOqhuUGk7ey2CmCdcepwrF6q-1jFePaWR_gcHsZh3ECSy1WpFn88', 'disloyal'),
(4, 'Политическая карикатура. И не только', 'https://www.facebook.com/groups/igor.funt.pictures/', 'disloyal')
;


insert into citizens_communities (`cit_id`, `community_id`) values
('1', '1'),
('1', '3'),
('1', '9'),
('2', '4'),
('2', '5'),
('2', '10'),
('3', '2'),
('3', '13'),
('3', '8'),
('4', null),
('5', '4'),
('5', '5'),
('5', '10'),
('6', '1'),
('6', '3'),
('6', '6'),
('6', '11'),
('6', '14'),
('7', null),
('8', null),
('9', '2'),
('9', '7'),
('9', '8'),
('9', '12'),
('9', '13'),
('10', '4'),
('10', '5'),
('10', '7')
;

insert into bank_list (`id`, `bank_name`) values
(1, 'VTB24'),
(2, 'Home Credit Bank'),
(3, 'TCS Bank'),
(4, 'Сбербанк'),
(5, 'Альфа-Банк')
;

insert into bank_accounts (`id`, `bank_id`, `account_num`) values
(1, 1, '48586984385876'),
(3, 2, '69856900005655'),
(5, 3, '69555222897770'),
(6, 4, '69365923696325'),
(7, 5, '24525841758741')
;

insert into photos (id, photos_id) values
('1', '11.jpg'),
('2', '12.jpg'),
('3', '13.jpg'),
('4', '14.jpg'),
('5', '15.jpg'),
('6', '16.jpg'),
('7', '17.jpg'),
('8', '18.jpg'),
('9', '19.jpg'),
('10', '110.jpg'),
('11', '111.jpg'),
('12', '112.jpg'),
('13', '113.jpg'),
('14', '114.jpg'),
('15', '115.jpg'),
('16', '116.jpg'),
('17', '117.jpg'),
('18', '118.jpg'),
('19', '119.jpg'),
('20', '120.jpg')
;

	-- Создание триггеров для проверки вводимых данных. Обрабатываем исключения при вводе значений NULL.

DELIMITER //
create TRIGGER `check_firstname_insert` BEFORE INSERT ON `citizens` FOR EACH ROW begin -- 
	IF NEW.firstname is null THEN
    	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ИМЯ не может быть NULL';
	end if;  
end;
DELIMITER //

DELIMITER //
CREATE TRIGGER `check_lastname_insert` BEFORE INSERT ON `citizens` FOR EACH ROW begin
	IF NEW.lastname is null THEN
    	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Фамилия не может быть NULL';
	end if;  
end;
DELIMITER //

DELIMITER //
CREATE TRIGGER `checked_birth_date_insert` BEFORE update ON `citizens` FOR EACH ROW begin
	IF NEW.birth_date is null THEN
    	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Не может быть NULL';
	end if;  
end;
DELIMITER //

	-- Создание процедуры, которая выводит общие сообщества в городе жителя.

DELIMITER //
//
CREATE DEFINER=`n1k`@`%` PROCEDURE `base_of_citizens`.`common_communities_in_city`(in for_citizen_id int)
begin
	
	
	select cc2.cit_id as citizen
	from citizens_communities as cc1
	join citizens_communities as cc2 on cc1.community_id = cc2.community_id and cc2.cit_id <> for_citizen_id
	where cc1.cit_id = for_citizen_id
	union
	select c2.citizen_id
	from fact_address c
	join fact_address c2 on c.city = c2.city and c2.citizen_id <> for_citizen_id
	where c.citizen_id = for_citizen_id;

end;


//
DELIMITER //

-- call common_communities_in_city(1); Пример вызова процедуры



	-- Представление для вывода всех "нелояльных" сообществ в базе
create or replace
view `disloyal_communities` as
select
    `communities`.`id` as `id`,
    `communities`.`soc_net_id` as `soc_net_id`,
    `communities`.`name` as `name`,
    `social_networks`.`soc_net_name` as `soc_net_name`
from
    (`communities`
join `social_networks` on
    ((`communities`.`soc_net_id` = `social_networks`.`id`)))
where
    (`communities`.`loyal_to_authority` = 'disloyal')
;


-- select * from disloyal_communities;   Пример обращения к представлению.

	-- Представление для типичного поиска
create or replace
view `regular_sample_by_citizens` as
select
    `citizens`.`id` as `id`,
    `citizens`.`firstname` as `firstname`,
    `citizens`.`secondname` as `secondname`,
    `citizens`.`lastname` as `lastname`,
    `citizens`.`birth_date` as `birth_date`,
    `profiles`.`citizen_id` as `citizen_id`,
    `profiles`.`gender` as `gender`,
    `profiles`.`email` as `email`,
    `profiles`.`phone` as `phone`
from
    (`citizens`
join `profiles`)
where
    (`citizens`.`id` = `profiles`.`citizen_id`)
;

	-- select * from regular_sample_by_citizens
	-- where firstname like '%а';        Пример типичного поиска при обращении к представлению. 

 -- Примеры типичных запросов к базе

	-- Вывод общей информации
	
select id,  concat(firstname,' ',secondname , ' ', lastname) as name, birth_date, gender, email, phone
	from citizens, profiles
	where citizens.id = profiles.citizen_id;


	-- Более полная информация
select id,  concat(firstname,' ',secondname , ' ', lastname) as name, birth_date, gender, email, phone,
	concat(`index`,' ', city, ' ', street, ' ', home, ' ', apart) as living_address
	from citizens
	join profiles on citizens.id = profiles.citizen_id
	join fact_address on profiles.citizen_id = fact_address.citizen_id
	where citizens.id = profiles.citizen_id;

	-- Находим "нелояльные" сообщества
select communities.id, soc_net_id, communities.name, social_networks.soc_net_name
from communities 
	join social_networks on soc_net_id = social_networks.id
where loyal_to_authority = 'disloyal';


	-- Находим граждан моложе 18 лет

select id,  concat(firstname,' ',secondname , ' ', lastname) as name, birth_date
from citizens
where  YEAR(CURDATE()) - YEAR(birth_date) < 18
;



