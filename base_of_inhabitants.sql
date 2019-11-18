drop database if exists base_of_inhabitants;
create database base_of_inhabitants;
use base_of_inhabitants;

drop table if exists users;
create table users(
	id serial primary key,
	lastname varchar(100),
	firstname varchar(100),
	secondname varchar(100),
	birth_date varchar(20),
	created_at datetime default now(),
	updated_at datetime default now() on update current_timestamp,
	index (firstname, secondname, lastname)
);

drop table if exists profiles;
create table profiles(
	user_id SERIAL primary key,
	gender char(1),
	`hometown` varchar(100),
	email varchar(100) unique,
	phone varchar(12),
	photo_id bigint unsigned null,
	created_at datetime default now(),
	updated_at datetime default now()
);

ALTER TABLE base_of_inhabitants.users ADD CONSTRAINT users_fk FOREIGN KEY (id) REFERENCES base_of_inhabitants.profiles(user_id) ON DELETE RESTRICT ON UPDATE CASCADE;

drop table if exists communities;
create table communities (
	id SERIAL primary key,
	name varchar(150),
	link_to_community varchar(300), 
	loyal_to_authority enum('loyal', 'disloyal', 'unknown'),
	
	index (name)
);

drop table if exists users_communities;
create table users_communities (
	user_id bigint unsigned not null,
	community_id bigint unsigned not null,
	
	created_at datetime default now(),
	updated_at datetime default now(),
	
	foreign key (user_id) references users(id),
	foreign key (community_id) references communities(id)
);

drop table if exists passport;
create table passport(
	id serial primary key,
	serial_number bigint unsigned not null,
	date_of_issue datetime,
	issued_by text,
	reg_address text,
	dep_code bigint unsigned not null,
	
	index (serial_number)
);

drop table if exists photos;
create table photos(
	id SERIAL primary key,
	photos_id bigint unsigned not null
	
	-- foreign key (photos_id) references profiles(photo_id)
);

drop table if exists social_networks;
create table social_networks(
	id SERIAL primary key,
	vk_profile text,
	ok_profile text,
	facebook_profile text

);

ALTER TABLE base_of_inhabitants.passport ADD CONSTRAINT passport_fk FOREIGN KEY (id) REFERENCES base_of_inhabitants.users(id) ON DELETE restrict ON UPDATE CASCADE;
ALTER TABLE base_of_inhabitants.passport ADD CONSTRAINT passport_fk1 FOREIGN KEY (serial_number) REFERENCES base_of_inhabitants.users(id) ON DELETE restrict ON UPDATE CASCADE;
ALTER TABLE base_of_inhabitants.social_networks ADD CONSTRAINT social_networks_fk FOREIGN KEY (id) REFERENCES base_of_inhabitants.profiles(user_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE base_of_inhabitants.photos ADD CONSTRAINT photos_fk FOREIGN KEY (id) REFERENCES base_of_inhabitants.users(id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE base_of_inhabitants.photos ADD CONSTRAINT photos_fk_1 FOREIGN KEY (photos_id) REFERENCES base_of_inhabitants.profiles(user_id) ON DELETE RESTRICT ON UPDATE CASCADE;

/*
drop table if exists messages;
create table messages(
	id SERIAL primary key,
	from_user_id bigint unsigned null,
	to_user_id bigint unsigned null,
	body text,
	created_at datetime default now(),
	
	foreign key (from_user_id) references users(id),
	foreign key (to_user_id) references users(id),
	index (from_user_id),
	index (to_user_id)
	
);

drop table if exists friend_requests;
create table friend_requests(
	initiator_user_id bigint unsigned not null,
	target_user_id bigint unsigned not null,
	status enum('requested', 'approved', 'declined', 'unfriended'),
	
	created_at datetime default now(),
	updated_at datetime default now(),
	
	primary key (initiator_user_id, target_user_id),
	index(initiator_user_id),
	index(target_user_id),
	foreign key (initiator_user_id) references users(id),
	foreign key (target_user_id) references users(id)
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP

);

drop table if exists media;
create table media(
	id SERIAL primary key,
	media_type_id bigint unsigned not null,
	user_id bigint unsigned not null,
	body text,
	filename varchar(255),
	`size` int,
	metadata JSON,
	created_at datetime default now(),
	updated_at datetime default now() on update current_timestamp,
	
	foreign key (user_id) references users(id),
	foreign key (media_type_id) references media_types(id),
	index (user_id)
);

drop table if exists photo_albums;
create table photo_albums(
	id SERIAL,
	user_id bigint unsigned not null,
	name varchar(150),
	
	primary key(id),
	foreign key (user_id) references users(id)
);

drop table if exists photos;
create table photos(
	id SERIAL,
	album_id bigint unsigned not null,
	media_id bigint unsigned not null,
	
	primary key(id),
	foreign key (album_id) references photo_albums(id),
	foreign key (media_id) references media(id)
);
*/
-- alter table db_rus_people.users add is_deleted bit default 0 not null;

INSERT INTO `users` (`lastname`, `firstname`, `secondname`, `birth_date`) VALUES 
('Луначарская', 'Алиса', 'Ивановна', '19.10.1980'),
('Васильев', 'Дмитрий', 'Валерьевич', '24.01.1971'),
('Добровольская', 'Екатерина', 'Ивановна', '30.05.1956'),
('Влади', 'Игорь', 'Игоревич','18.12.1963'),
('Кашицина', 'Алевтина', 'Николаевна', '13.05.1981'),
('Николаев', 'Павел', 'Николаевич','19.11.1926'),
('Туполев', 'Владимир', 'Борисович','30.05.1956'),
('Кувалдин', 'Петр', 'Алексеевич', '13.05.1979'),
('Котова', 'Алевтина', 'Станиславовна', '13.05.1981'),
('Голубева', 'Амалия', 'Алексеевна', '02.06.1971'),
('Хохлов', 'Виктор', 'Леонидович', '25.05.1961'),
('Ходорковский', 'Адриан', 'Петрович', '18.05.1981'),
('Миллер', 'Григорий', 'Михайлович', '01.01.1960'),
('Высоцкий', 'Глеб', 'Андреевич', '13.09.1974'),
('Шкурат', 'Людмила', 'Олеговна', '15.06.1979'),
('Кувалдин', 'Виктор', 'Николаевич', '11.04.1981'),
('Андреева', 'Алевтина', 'Вячеславовна', '23.09.1980'),
('Кириллов', 'Юрий', 'Анатольевич', '17.05.1976'),
('Крайнов', 'Олег', 'Дмитриевич', '13.05.1981'),
('Сергеева', 'Варвара', 'Юрьевна', '13.02.1976')
;

INSERT INTO `profiles` (`user_id`, `gender`, `hometown`, `email`, phone, photo_id) values
('1', 'ж', 'Москва', 'luna911@mail.ru', '+79263543212', NULL),
('2', 'м', 'Москва', 'vasil234@mail.ru', '+79266996336', NULL),
('3', 'ж', 'Москва', 'dobroei@gmail.com', '+79201234565', NULL),
('4', 'м', 'Ульяновск', 'vladi1@yahoo.com', '+79263542552', NULL),
('5', 'ж', 'Тобольск', 'alya1981@mail.ru', '+79161338778', NULL),
('6', 'м', 'Владимир', null, '+79050551881', NULL),
('7', 'м', 'Москва', 'tupolev@mail.ru', '+79336769825', NULL),
('8', 'м', 'Благовещенск', 'petya79@mail.ru', '+79031112233', NULL),
('9', 'ж', 'Москва', 'kotya111@bk.ru', '+79253336699', NULL),
('10', 'ж', 'Санкт-Петербург', 'golubeva_amaliya@mail.ru', '+79884554545', NULL),
('11', 'м', 'Иваново', 'xoxlov61@gmail.com', '+79011011010', NULL),
('12', 'м', 'Москва', 'adrianx@yandex.ru', '+79521184575', NULL),
('13', 'м', 'Новосибирск', 'miller2011@mail.ru', '+79082036589', NULL),
('14', 'м', 'Тюмень', 'letchik777@list.ru', '+79091477474', NULL),
('15', 'ж', 'Москва', 'shkurat_l_o@mail.ru', '+79029996556', NULL),
('16', 'м', 'Королев', 'kuvaldin35@mail.com', '+79095699512', NULL),
('17', 'ж', 'Туапсе', 'AVAndreeva1@rambler.ru', '+79218522552', null),
('18', 'м', 'Воркута', 'kiruxa75@mail.ru', '+79201123223', NULL),
('19', 'м', 'Ростов-на-Дону', 'oleg56@mail.ru', '+79283543212', NULL),
('20', 'ж', 'Москва', 'barbara123@gmail.com', '+79163543212', NULL)
;

INSERT INTO `communities` (`name`, `link_to_community`, `loyal_to_authority`) values
('НавальныйLive', 'https://www.youtube.com/channel/UCgxTPTFbIbCWfTR9I2-5SeQ/featured', 'disloyal'),
('Bulkin', 'https://www.youtube.com/channel/UCtWY35eYO7jI9LnCRJxBGRQ', 'unknown'),
('ХВАТИТ МОЛЧАТЬ!', 'https://www.youtube.com/channel/UCGzzQZ7Yh_05VX4soU9_Hzw', 'disloyal'),
('RT', 'https://www.youtube.com/user/RussiaToday', 'loyal'),
('Россия 24', 'https://www.youtube.com/user/Russia24TV', 'loyal'),
('Телеканал Дождь', 'https://www.youtube.com/channel/UCdubelOloxR3wzwJG9x8YqQ', 'disloyal'),
('Discovery Channel Россия', 'https://www.youtube.com/user/DchRussia', 'unknown'),
('Рики', 'https://www.youtube.com/user/riki', 'unknown'),
('kamikadzedead', 'https://www.youtube.com/channel/UCDbsY8C1eQJ5t6KBv9ds-ag', 'disloyal'),
('Вечер с Владимиром Соловьевым', 'https://www.youtube.com/user/PoedinokTV', 'loyal')
;

/*
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('2', 'M', '1995-07-01', NULL, '2007-12-14 22:31:56', 'Port');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('3', 'M', '2010-12-17', NULL, '2017-02-21 20:18:01', 'North');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('4', 'M', '1971-06-30', NULL, '1974-10-27 11:33:33', 'East');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('5', 'D', '2004-08-13', NULL, '1988-05-21 12:09:50', 'West');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('6', 'D', '1971-11-19', NULL, '1976-09-16 14:51:49', 'Port');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('7', 'P', '1993-06-14', NULL, '2011-01-01 16:58:27', 'South');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('8', 'D', '2001-04-15', NULL, '1988-07-01 16:40:55', 'Port');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('9', 'D', '1986-10-21', NULL, '2000-10-02 23:25:18', 'Port');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('10', 'P', '2019-06-26', NULL, '2010-11-18 18:15:52', 'North');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('11', 'D', '1996-04-26', NULL, '1971-11-22 22:28:05', 'North');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('12', 'M', '1973-06-06', NULL, '1971-12-15 07:56:35', 'South');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('13', 'P', '1991-09-22', NULL, '1992-09-20 02:29:51', 'North');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('14', 'P', '1977-07-03', NULL, '2018-11-09 09:21:39', 'South');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('15', 'M', '2012-06-30', NULL, '1986-09-05 10:19:43', 'East');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('16', 'D', '1982-09-28', NULL, '1993-05-30 20:39:26', 'West');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('17', 'D', '1974-09-27', NULL, '1980-01-02 23:13:23', 'Port');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('18', 'D', '2002-02-04', NULL, '2016-07-24 04:46:52', 'Port');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('19', 'P', '2011-02-21', NULL, '1989-02-08 15:52:17', 'Port');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('20', 'P', '1991-07-31', NULL, '1990-02-05 06:26:23', 'New');

/*
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('21', 'P', '1987-09-17', NULL, '1973-07-10 05:03:58', 'South');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('22', 'D', '1987-09-05', NULL, '2003-05-30 02:10:30', 'West');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('23', 'D', '2012-12-14', NULL, '1980-09-09 09:29:23', 'East');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('24', 'M', '1993-01-12', NULL, '1971-02-23 19:47:34', 'East');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('25', 'D', '1973-09-28', NULL, '2004-04-09 20:31:33', 'North');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('26', 'M', '1987-06-15', NULL, '2019-07-01 06:20:08', 'New');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('27', 'D', '1970-10-19', NULL, '1996-04-15 02:53:09', 'South');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('28', 'P', '1999-07-12', NULL, '2009-07-07 06:13:28', 'West');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('29', 'P', '2008-07-16', NULL, '2003-10-05 23:40:35', 'New');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('30', 'P', '2017-05-11', NULL, '1988-09-25 18:36:17', 'Port');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('31', 'M', '1991-07-22', NULL, '2003-01-15 18:37:48', 'Lake');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('32', 'M', '1990-04-15', NULL, '1983-05-28 19:25:24', 'South');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('33', 'D', '1989-10-01', NULL, '2007-01-17 17:19:42', 'South');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('34', 'P', '2017-07-23', NULL, '1995-08-24 01:35:53', 'West');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('35', 'P', '1977-03-18', NULL, '1993-11-04 04:33:52', 'East');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('36', 'D', '1976-01-19', NULL, '1999-03-26 13:26:43', 'South');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('37', 'P', '1974-11-23', NULL, '1996-05-09 17:56:58', 'Port');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('38', 'D', '1999-08-08', NULL, '1987-06-15 18:17:48', 'West');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('39', 'M', '1979-06-05', NULL, '1980-02-06 10:30:38', 'West');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('40', 'M', '1989-03-29', NULL, '2006-03-27 10:38:46', 'Port');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('41', 'M', '2008-12-03', NULL, '1971-09-14 04:51:03', 'Lake');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('42', 'M', '1990-08-27', NULL, '1980-01-12 09:10:29', 'Port');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('43', 'M', '2003-02-24', NULL, '1976-10-27 12:13:16', 'South');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('44', 'M', '1977-08-17', NULL, '2008-02-08 23:42:53', 'East');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('45', 'D', '1970-08-17', NULL, '1993-06-04 19:01:52', 'New');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('46', 'M', '1995-05-15', NULL, '1979-05-19 22:32:28', 'New');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('47', 'P', '2006-12-14', NULL, '1973-05-28 07:59:50', 'West');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('48', 'M', '1995-01-06', NULL, '1984-08-02 14:37:10', 'Port');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('49', 'D', '1984-05-01', NULL, '2006-02-25 16:17:17', 'Port');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('50', 'M', '2002-06-10', NULL, '1997-09-23 08:39:02', 'West');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('51', 'M', '1983-12-02', NULL, '1995-04-22 13:07:49', 'New');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('52', 'M', '1993-05-30', NULL, '1973-01-20 10:11:16', 'Lake');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('53', 'M', '2000-09-18', NULL, '1998-12-02 12:07:22', 'North');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('54', 'P', '2018-06-21', NULL, '1980-03-31 00:34:20', 'East');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('55', 'D', '1998-11-14', NULL, '1975-12-15 16:45:13', 'Port');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('56', 'P', '2019-11-06', NULL, '1995-07-22 18:59:34', 'New');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('57', 'D', '2003-01-16', NULL, '2008-08-27 01:50:59', 'Port');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('58', 'M', '1981-02-03', NULL, '1970-05-12 14:50:58', 'North');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('59', 'M', '1990-06-24', NULL, '1997-09-28 22:28:31', 'West');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('60', 'M', '1982-01-11', NULL, '2017-03-26 13:52:18', 'Lake');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('61', 'M', '1976-01-25', NULL, '2011-03-24 21:44:22', 'North');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('62', 'M', '2007-03-24', NULL, '1988-10-07 18:03:33', 'East');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('63', 'M', '1980-07-04', NULL, '1976-07-16 09:41:28', 'North');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('64', 'M', '2002-06-22', NULL, '1975-12-12 14:40:34', 'North');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('65', 'M', '2008-07-20', NULL, '1986-06-20 13:43:46', 'East');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('66', 'M', '1975-04-08', NULL, '1975-02-08 02:38:15', 'South');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('67', 'P', '1983-02-24', NULL, '1994-04-18 14:22:44', 'North');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('68', 'M', '1999-07-16', NULL, '2017-12-11 01:31:13', 'West');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('69', 'M', '2011-04-30', NULL, '2018-11-21 07:57:11', 'Port');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('70', 'M', '1987-07-23', NULL, '2007-06-03 14:22:22', 'Lake');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('71', 'P', '1983-12-30', NULL, '1998-09-24 05:26:02', 'Port');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('72', 'P', '1986-10-24', NULL, '1979-06-03 07:08:24', 'New');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('73', 'P', '1993-04-12', NULL, '1971-06-16 19:08:34', 'North');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('74', 'P', '2000-02-24', NULL, '2018-10-04 13:35:02', 'North');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('75', 'D', '2002-03-25', NULL, '1979-05-08 10:17:16', 'Port');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('76', 'M', '1972-06-04', NULL, '1997-01-13 07:54:11', 'North');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('77', 'M', '2015-02-09', NULL, '1998-07-04 15:49:10', 'Port');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('78', 'D', '2005-05-16', NULL, '2014-03-15 01:03:02', 'South');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('79', 'M', '2017-06-21', NULL, '2010-03-04 02:16:16', 'East');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('80', 'D', '2000-12-08', NULL, '1978-01-23 13:21:50', 'West');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('81', 'M', '1981-12-09', NULL, '1979-12-17 18:05:27', 'Port');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('82', 'D', '1999-09-18', NULL, '1970-08-10 01:38:09', 'West');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('83', 'M', '2011-08-09', NULL, '2003-10-11 04:09:00', 'West');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('84', 'D', '1973-07-27', NULL, '1983-06-12 08:21:17', 'North');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('85', 'M', '1990-02-10', NULL, '2013-01-19 02:36:32', 'New');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('86', 'M', '2003-07-18', NULL, '2009-03-02 02:03:12', 'Lake');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('87', 'P', '2002-05-18', NULL, '2007-08-22 06:01:29', 'East');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('88', 'P', '2014-06-19', NULL, '1976-07-18 10:53:05', 'New');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('89', 'M', '1979-03-07', NULL, '1971-05-17 20:42:41', 'Port');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('90', 'D', '2018-08-14', NULL, '1970-04-26 19:02:19', 'Lake');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('91', 'M', '2011-10-09', NULL, '1971-08-03 02:32:17', 'Port');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('92', 'M', '1976-07-07', NULL, '1984-08-17 09:41:17', 'North');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('93', 'M', '1975-05-22', NULL, '1998-03-27 15:58:53', 'Lake');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('94', 'M', '1997-11-03', NULL, '1985-09-21 04:33:51', 'New');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('95', 'M', '2015-07-04', NULL, '1974-04-16 15:16:21', 'New');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('96', 'P', '1999-06-24', NULL, '1971-10-18 03:43:20', 'New');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('97', 'D', '2000-06-16', NULL, '2009-01-04 21:56:59', 'South');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('98', 'M', '2001-08-08', NULL, '2013-10-06 12:28:17', 'North');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('99', 'M', '2010-04-05', NULL, '2012-09-12 12:49:05', 'East');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) VALUES ('100', 'M', '1988-07-23', NULL, '2017-11-06 14:05:06', 'Port');
*/
