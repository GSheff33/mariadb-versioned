#!/usr/bin/perl
use strict;
use warnings;

use DBI

#MariaDB database config
my $dsn="DBI:mysql:perlmysqldb";
my $username = "repluser";
my $password = "replpassword";

# Database Repository config
my $startv="" # starting version number
my $endv="" # ending version number
my $targetdb="" # target database to diff
my $skipped="" # skipped tables, can be specified on a per table basis


# connect to MariaDB database
my %attr = ( PrintError=>0, # turn off error reporting via warn()
	RaiseError=>1 # report error via die()
	);
my $dbh = DBI->connect($dsn,$username,$password,\%attr);

# build a new database based on the old schema
database_build($dbh,$targetdb);

sub database_build{
	# Builds a temporary database based on the $targetdb
	my($dbh)=@_[0];
	my $sql ="CREATE DATABASE new_". @_[1] .";";

	#run mysqldump using the username and password provided
	
	if(system("mysqldump --routines --no_data -u$username -p$password ". @_[1] ." > /data/software/". @_[1] .".sql"))
		print "reeee bitch it failed\n"; #only prints if(1), which only happens if the system command fails

	# load the database DDL back into the new_ database
	# we can just keep reusing @_[1] cause we're cucks xd
	
	if(system("mysql -u$username -p$password new_@_[1] < /data/software/@_[1]"))
		print "reeee bitch it failed\n";
	
	
}
