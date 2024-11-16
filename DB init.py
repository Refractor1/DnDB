import sqlite3

# Connect to an SQLite database (or create it if it doesn't exist)
conn = sqlite3.connect('DnD.db')

# Create a cursor object to interact with the database
cursor = conn.cursor()

cursor.executescript('''DROP table locationiteminstance;
DROP table npciteminstance;
DROP table itemType;
DROP table npc;
drop table location;''')
               
cursor.executescript('''
create table itemType( 
	itemType_id integer primary key,
	is_unique boolean not null,
	item_name varchar(30) not null,
    price integer,
    weight integer,
    type TEXT CHECK(type IN ('Adventuring Gear', 'Armor', 'Shield', 'Trinket', 'Weapon', 'Magic Armor', 'Magic Shield', 'Magic Weapon', 'Firearm', 'Explosive', 'Wondrous Item', 'Poison', 'Tools', 'Siege Equipment')),
    rarity TEXT CHECK(type IN (null, 'Common', 'Uncommon', 'Rare', 'Very Rare', 'Legendary', 'Artifact','Unique', 'Unknown')),
    description varchar(10000)
);
                     
-- location Table
CREATE Table location (
	location_id integer Primary Key,
    l_name varchar(20) NOT NULL,
    l_description varchar(1000),
    parent_id integer,
    foreign key (parent_id) REFERENCES location(location_id)
);

-- npc Table
create table npc (
    npc_id integer primary key,
    location_id integer not null,
    npc_name varchar(20) not null,
    job varchar(20),
    note varchar(1000),
    foreign key (location_id) references location(location_id)
);

-- locationItemInstance Table
create table locationItemInstance(
	location_id integer,
    itemType_id integer,
    qty integer not null,
    note varchar(500),
    primary key (location_id, itemType_id),
    foreign key (location_id) references location(location_id),
    foreign key (itemType_id) references itemType(itemType_id)
);

-- npcItemInstance
create table npcItemInstance (
    npc_id integer not null,
    itemType_id integer not null,
    qty integer not null,
    primary key (npc_id, itemType_id),
    foreign key (npc_id) references npc(npc_id),
    foreign key (itemType_id) references itemType(itemType_id)
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
''')

# Commit the changes
conn.commit()

# Query the database
cursor.execute('SELECT item_name FROM itemType')
rows = cursor.fetchall()

# Print the results
for row in rows:
    print(row)

# Close the connection
conn.close()