#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use Data::Dumper;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use POSIX qw(strftime);
use Switch;
use Time::HiRes qw ( time );

use threads;
use threads::shared;

my $user='root';
my $password='XXXXXX';
my $datadir='/mysql/dev/data';
my @threads;
my $max_rows = 2000000;

my $dbh = DBI->connect("dbi:mysql:knagy;host=localhost;mysql_socket=$datadir/mysql.sock", 'root', $password) or die('Cannot connect');

while (is_insert()) {
	my $secondary = int(rand($max_rows));
	my $stmt;
	$stmt = $dbh->prepare("INSERT INTO t_update_test (c_secondary, value_to_update) VALUES(?, ?)");
	$stmt->execute($secondary, md5_hex(int(rand(65536)) . localtime ));
}
for ( my $count = 1; $count <= 16; $count++) {
        my $t = threads->new(\&slap, $count);
        push(@threads,$t);
}
foreach (@threads) {
        my $num = $_->join;
        print "done with $num \n";
}

sub slap {
	my $tdbh = DBI->connect("dbi:mysql:knagy;host=localhost;mysql_socket=$datadir/mysql.sock", 'root', $password) or die('Cannot connect');
	while (1) {
		my $query = int(rand(2));
		my $condition; 
		switch ($query) {
			my $key = int(rand($max_rows));
			case 0 {$condition = "c_primary = $key";}
			case 1 {$condition = "c_secondary = $key";}
		} 
		my $stmt = $tdbh->prepare("update t_update_test set value_to_update = ? where $condition;");
		my $start = time;
		$stmt->execute(md5_hex(int(rand(65536)) . localtime ));
		my $delta = time - $start;
		log_time($tdbh, $query, $condition, $delta * 10000);
		sleep rand(3) + 1;
	}
}

sub log_time {
	my ($con, $qtype, $cond, $time) = @_;
	my $stmt = $con->prepare('INSERT INTO query_times (qtype, qcondition, qtime) VALUES (?, ?, ?)');
	$stmt->execute($qtype, $cond, $time );
}

sub is_insert {
	my $query = $dbh->prepare("SELECT COUNT(*) from t_update_test;");
	$query->execute(); 
	my ($count) = $query->fetchrow_array();
	return $count < $max_rows;
}
