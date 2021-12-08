#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
my $titulo = $q->param('titulo');

eliminar($titulo);

sub eliminar{
  my $titulo = $_[0];

  my $user = 'alumno';
  my $password = 'pweb1';
  my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.54";
  my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");
  my $sth = $dbh->prepare("DELETE FROM websites WHERE titulo = ?");
  $sth->execute($titulo);
  my $texto = $sth->fetchrow_array;
  $sth->finish;
  $dbh->disconnect;
}

print $q->header('text/html;charset=UTF-8');

print <<"HTML";
<!DOCTYPE html>
<html lang="es">
  <head>
    <title>Eliminar pagina</title>
  </head>
  <body>
    <h1>$titulo</h1>
    <br>
    <h2>Página eliminada <a href='list2.pl'>Listado de Páginas</a><h2>
  </body>
</html>
HTML

