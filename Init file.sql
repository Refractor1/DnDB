#View All Tables
SELECT * FROM itemType;
SELECT * FROM location;
SELECT * FROM npc;
SELECT * FROM locationItemInstance;
SELECT * FROM npcItemInstance;

DROP table locationiteminstance;
DROP table npciteminstance;
DROP table itemType;
DROP table npc;
drop table location;

# Table Creations
-- itemType Table
create table itemType( 
	itemType_id int,
	is_unique boolean not null,
	item_name varchar(30) not null,
    price int,
    weight int,
    type enum('Adventuring Gear', 'Armor', 'Shield', 'Trinket', 'Weapon', 'Magic Armor', 'Magic Shield', 
    'Magic Weapon', 'Firearm', 'Explosive', 'Wondrous Item', 'Poison', 'Tools', 'Siege Equipment'),
    rarity enum('Common', 'Uncommon', 'Rare', 'Very Rare', 'Legendary', 'Artifact','Unique', 'Unknown'),
    description varchar(10000)
);

-- location Table
CREATE Table location (
	location_id int Primary Key,
    l_name varchar(20) NOT NULL,
    l_description varchar(1000),
    parent_id int
);

-- npc Table
create table npc (
    npc_id int not null,
    location_id int not null,
    npc_name varchar(20) not null,
    job varchar(20),
    note varchar(1000)
);

create table roads(
road_id int primary key,
road_name varchar(20),
road_start int not null,
road_end int not null,
monster_list varchar(200),
foreign key (road_start) REFERENCES location(location_id),
foreign key (road_end) REFERENCES location(location_id)
);

-- locationItemInstance Table
create table locationItemInstance(
	location_id int,
    itemType_id int,
    qty int not null,
    note varchar(500)
);

-- npcItemInstance
create table npcItemInstance (
    npc_id int not null,
    itemType_id int not null,
    qty int not null
);

alter table itemType
   add constraint itemType_pk
   primary key (itemType_id);

ALTER TABLE location
	ADD FOREIGN KEY (parent_id) REFERENCES location(location_id);
    
alter table npc
    add primary key (npc_id);
    
alter table npc
    add constraint fk_location foreign key (location_id)
        references location(location_id);

alter table locationItemInstance
	add constraint lii_pk
    primary key (location_id, itemType_id);

alter table locationItemInstance
	add constraint lii_fk
    foreign key (location_id)
    references location(location_id);

alter table locationItemInstance
	add constraint lii_fk2
    foreign key (itemType_id)
    references itemType(itemType_id);

alter table npcItemInstance
    add primary key (npc_id, itemType_id);

alter table npcItemInstance
    add constraint fk_npc_id foreign key (npc_id)
        references npc(npc_id);

alter table npcItemInstance
    add constraint fk_itemType_id foreign key (itemType_id)
        references itemType(itemType_id);

-- itemType Information
insert into itemType (itemType_id, is_unique, item_name, price, weight, type, rarity, description) values 
(1, False, "Book", 25, 5, "Adventuring Gear", null, "Book description.");

-- loation Information
insert into location (location_id, l_name, l_description, parent_id)
VALUES (1, "Ocura", "Ocura is a large continent holding magic and more", NULL);

-- npc Information
insert into npc (npc_id, location_id, npc_name, job, note) values
(1, 1, 'Sir Galdor', 'Knight', 'A knight sworn to protect the realm');

-- locationItemInstance Information
insert into locationItemInstance (location_id, itemType_id, qty, note) values 
(1,1,100, 'On a book shelf');

-- npcItemInstance Information
insert into npcItemInstance (npc_id, itemType_id, qty) values
(1, 1, 2);