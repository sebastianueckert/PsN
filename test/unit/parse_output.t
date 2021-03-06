#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use FindBin qw($Bin);
use lib "$Bin/.."; #location of includes.pm
use includes; #file with paths to PsN packages
use output::problem::subproblem;
use output::problem;
use utils::file;

my %hash;
$hash{'+Infinity'}=undef;
$hash{'-Infinity'}=undef;
$hash{'+Inf'}=undef;
$hash{'-Inf'}=undef;
$hash{'+INF'}=undef;
$hash{'-INF'}=undef;
$hash{'INF'}=undef;
$hash{'inf'}=undef;
$hash{'-inf'}=undef;
$hash{'NA'}=undef;
$hash{'NaN'}=undef;
$hash{''}=undef;
$hash{'10000000000'}=undef;
$hash{'1E+00'}=1;
$hash{'1.01E+01'}=10.1;
$hash{'12345'}=12345;

#plan tests => scalar(keys %hash)+7+6+8+9;

foreach my $key (keys %hash){
	is (output::problem::subproblem::_get_value(val => $key),$hash{$key},"_get_value $key");
}

is (output::problem::subproblem::_get_significant_digits('NO. OF SIG. DIGITS IN FINAL EST.:  2.0'),2.0,
	"_get_significant_digits 2.0");
is (output::problem::subproblem::_get_significant_digits('NO. OF SIG. DIGITS IN FINAL EST.:  NaN'),undef,
	"_get_significant_digits NaN");
is (output::problem::subproblem::_get_significant_digits('NO. OF SIG. DIGITS UNREPORTABLE'),undef,
	"_get_significant_digits unreportable");
is (output::problem::subproblem::_get_significant_digits('NO. OF SIG. DIGITS IN FINAL EST.:  *******'),undef,
	"_get_significant_digits asterisks");
is (output::problem::subproblem::_get_significant_digits('NO. OF SIG. DIGITS IN FINAL EST.:  1E+02'),100,
	"_get_significant_digits e notation");


	

my $file = $includes::testfiledir.'/mox_sir_block2.cor';
my @lines = utils::file::slurp_file($file);
my ($success,$matrix_array_ref,$index_order_ref,$header_labels_ref) = 
	output::problem::subproblem::parse_additional_table (covariance_step_run => 1,
														 have_omegas => 1,
														 have_sigmas => 1,
														 method_string => 'First Order Conditional Estimation',
														 keep_labels_hash => { 'THETA1'=> 1,'THETA2'=> 1,'THETA3'=> 1,'THETA4'=> 1,'THETA5'=> 1, 
																			   'OMEGA(1,1)'=> 1,'OMEGA(2,2)'=> 1,'OMEGA(3,2)'=> 1,'OMEGA(3,3)'=> 1},
														 type => 'cor',
														 tableref => \@lines);
is ($success,1,'mox_sir_block2.cor success');
my @column_headers = ();
foreach my $ind (@{$index_order_ref}) {
	push (@column_headers, $header_labels_ref->[$ind]);
}

is_deeply(\@column_headers,['THETA1','THETA2','THETA3','THETA4','THETA5','OMEGA(1,1)','OMEGA(2,2)','OMEGA(3,2)','OMEGA(3,3)'],' header labels ref 1');

#matrix_array_ref is single arr of lower triangular cleaned and sorted matrix
is ($matrix_array_ref->[0],eval(2.48443E+00),'mox_sir_block2.cor element (1,1)');
is ($matrix_array_ref->[11],eval(1.05601E-01),'mox_sir_block2.cor element (5,2)');
is ($matrix_array_ref->[20],eval(6.90044E-02),'mox_sir_block2.cor element (6,6)');
is ($matrix_array_ref->[23],eval(2.32817E-01),'mox_sir_block2.cor element (7,3)');
is ($matrix_array_ref->[34],eval(7.19436E-01),'mox_sir_block2.cor element (8,7)');
is ($matrix_array_ref->[44],eval(4.59835E-02),'mox_sir_block2.cor element (9,9)');

is ($index_order_ref->[0],1,'mox_sir_block2.cor index order 0');
is ($index_order_ref->[4],5,'mox_sir_block2.cor index order 4');
is ($index_order_ref->[5],7,'mox_sir_block2.cor index order 5');
is ($index_order_ref->[6],9,'mox_sir_block2.cor index order 6');
is ($index_order_ref->[7],11,'mox_sir_block2.cor index order 7');
is ($index_order_ref->[8],12,'mox_sir_block2.cor index order 8');

$file = $includes::testfiledir.'/output/nm73/anneal2_V7_30_beta.cor';
my @tmp = utils::file::slurp_file($file);
@lines=();
my $store=0;
foreach my $line (@tmp){
	$store = 1 if ($line =~ /^TABLE NO.     2:/);
	push(@lines,$line) if ($store);
}

($success,$matrix_array_ref,$index_order_ref,$header_labels_ref) = 
	output::problem::subproblem::parse_additional_table (covariance_step_run => 1,
														 have_omegas => 1,
														 have_sigmas => 1,
														 method_string => 'Objective Function Evaluation by Importance Sampling',
														 keep_labels_hash => {'THETA1'=>1,'THETA2'=>1,'THETA3'=>1,'THETA4'=>1,'SIGMA(1,1)'=>1,
																			  'OMEGA(1,1)'=>1,'OMEGA(2,1)'=>1,'OMEGA(2,2)'=>1,'OMEGA(3,3)'=>1},
														 type => 'cor',
														 tableref => \@lines);
is ($success,1,'anneal2_V7_30_beta.cor success');

@column_headers = ();
foreach my $ind (@{$index_order_ref}) {
	push (@column_headers, $header_labels_ref->[$ind]);
}

is_deeply(\@column_headers,['THETA1','THETA2','THETA3','THETA4','OMEGA(1,1)','OMEGA(2,1)','OMEGA(2,2)','OMEGA(3,3)','SIGMA(1,1)'],' header labels ref 2');


#matrix_array_ref is single arr of lower triangular cleaned and sorted matrix
is ($matrix_array_ref->[0],eval(2.01673E-01),'anneal2_V7_30_beta.cor element (1,1)');
is ($matrix_array_ref->[19],eval(8.53643E-01),'anneal2_V7_30_beta.cor element (6,5)');
is ($matrix_array_ref->[43],eval(-3.75755E-01),'anneal2_V7_30_beta.cor element (9,8)');
is ($matrix_array_ref->[39],eval(1.41960E-01),'anneal2_V7_30_beta.cor element (9,4)');
is ($matrix_array_ref->[40],eval(1.01668E-02),'anneal2_V7_30_beta.cor element (9,5)');
is ($matrix_array_ref->[44],eval(6.99733E-01),'anneal2_V7_30_beta.cor element (9,9)'); #sigma
is ($index_order_ref->[8],5,'anneal2_V7_30_beta.cor index order 8');

$file = $includes::testfiledir.'/mox_sir.cov';
@lines = utils::file::slurp_file($file);
($success,$matrix_array_ref,$index_order_ref,$header_labels_ref) = 
	output::problem::subproblem::parse_additional_table (covariance_step_run => 1,
														 have_omegas => 1,
														 have_sigmas => 1,
														 method_string => ' ',
														 type => 'cov',
														 tableref => \@lines);
is ($success,1,'mox_sir.cov userclean success');


@column_headers = ();
foreach my $ind (@{$index_order_ref}) {
	push (@column_headers, $header_labels_ref->[$ind]);
}

is_deeply(\@column_headers,['THETA1','THETA2','THETA3','THETA4','THETA5','OMEGA(1,1)','OMEGA(2,1)','OMEGA(2,2)','OMEGA(3,1)','OMEGA(3,2)','OMEGA(3,3)','SIGMA(1,1)'],' header labels ref 3');

#matrix_array_ref is single arr of lower triangular uncleaned (since skip labels matrix is empty and have_sigmas and have_omegas) and sorted matrix
is ($matrix_array_ref->[0],eval(6.10693E+00),'mox_sir.cov uncleaned element (1,1)');
is ($matrix_array_ref->[21],eval(0.00E+00),'mox_sir.cov uncleaned element (7,1)');
is ($matrix_array_ref->[28],eval(5.97477E-02),'mox_sir.cov uncleaned element (8,1)');
is ($matrix_array_ref->[66],eval(0.00E+00),'mox_sir.cov uncleaned element (12,1)');
is ($matrix_array_ref->[65],eval(1.69362E-03),'mox_sir.cov uncleaned element (11,11)');

is ($index_order_ref->[0],1,'mox_sir.cov uncleaned index order 0');
is ($index_order_ref->[5],7,'mox_sir.cov uncleaned index order 5');
is ($index_order_ref->[11],6,'mox_sir.cov uncleaned index order 11');

my ($is_time,$sec) = output::problem::is_timestamp(['2011-12-03'],0);
my $sec2;
is($is_time,0,'is_timestamp 1');
($is_time,$sec) = output::problem::is_timestamp(['2011-12-03','12:03'],0);
is($is_time,1,'is_timestamp 2');
($is_time,$sec) = output::problem::is_timestamp(['','09/02/2016 ','13:12'],1);
is($is_time,1,'is_timestamp 3');
($is_time,$sec2) = output::problem::is_timestamp(['Stop Time:',
												  'Tue Feb  9 13:12:00 CET 2016'],1);
is($is_time,1,'is_timestamp 4');
is($sec,$sec2,'is_timestamp 5, same time different format');
($is_time,$sec2) = output::problem::is_timestamp(['','2016-02-09 ','13:12'],1);
is($is_time,1,'is_timestamp 6');
is($sec,$sec2,'is_timestamp 7, same time different format');

done_testing();
