alter table `cellphone` add `province_id` tinyint unsigned default 0 after `city`;
alter table `cellphone` add `city_id` tinyint unsigned default 0 after `province_id`;