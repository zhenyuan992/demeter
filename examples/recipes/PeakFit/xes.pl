#!/usr/bin/perl

use Demeter qw(:ui=screen :plotwith=gnuplot);

my $xes = Demeter::XES->new(file=>'../XES/7725.11',
			    energy => 2, emission => 3,
			    e1 => 7610, e2 => 7624, e3 => 7664, e4 => 7690,
			   );

my $peak = Demeter::PeakFit->new(screen => 1, yaxis=> 'raw',
				 xmin=>7607, xmax=>7687);

$peak -> data($xes);

$peak -> add('linear', name=>'baseline');
$peak -> add('gaussian', center=>7649.5, name=>'peak 1');
$peak -> add('gaussian', center=>7647.7, name=>'peak 2');
$peak -> add('gaussian', center=>7641.8, name=>'peak 3');

$peak -> fit;

$_  -> plot('raw') foreach ($xes, $peak, @{$peak->lineshapes});
$peak -> pause;


## to do:
##  1. pgplot plotting tmpl files
##  2. snarf in best fit values and uncertainties
##  3. reporting methods
##  4. test with xanes data
##  5. fixing parameters
##  6. test more functions
##  7. deal with fityk param names
##  8. step-like functions
