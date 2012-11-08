create table t_update_test (
c_primary int unsigned not null AUTO_INCREMENT,
c_secondary int unsigned not null,
value_to_update varchar(32) not null,
PRIMARY KEY (c_primary)
) Engine=InnoDB;

create index sec_idx1 on t_update_test(c_secondary);

create table query_times (
id int unsigned not null AUTO_INCREMENT,
qtype tinyint unsigned not null,
qcondition varchar(96) not null default '',
qtime decimal(12,4),
PRIMARY KEY (id),
KEY (qtype)
) Engine=InnoDB;
