#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;

print $q->header('text/html; charset=UTF-8');
  my $body = "";
  
  my $user = 'alumno';
  my $password = 'pweb1';
  my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.54";
  my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");;
  
  my $sth = $dbh->prepare("SELECT titulo FROM websites");
  $sth->execute();
    while(my @row = $sth->fetchrow_array ) {
      my $titulo = $row[0];
      $body .= "      <li><a href='view2.pl?titulo=$titulo'>$titulo</a><a> </a><a class='boton' href='delete2.pl?titulo=$titulo'>ELIMINAR</a><a> </a><a class='boton' href='edit2.pl?titulo=$titulo'>EDITAR</a></li>\n";
  }
  $sth->finish;
  $dbh->disconnect;

print <<HTML;
<!DOCTYPE html>
<html lang="es">
  <head>
    <title>Listado de paginas</title>
  </head>
  <body>
    <h1>Lista de paginas Web en la Wikipedia</h1>
    <ul>
      $body
    </ul>
    <a href="../new.html">Nueva Página</a>
    <br>
    <a href="../index.html">Volver al inicio</a>
  </body>
</html>
HTML
