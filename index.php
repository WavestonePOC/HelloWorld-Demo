<?php

echo "Bonjour Tlm!V3\n";

echo getenv("DATABASE_SERVICE_NAME");
echo "\r\n";
echo getenv("DATABASE_NAME");
echo "\r\n";
echo getenv("DATABASE_USER");
echo "\r\n";
echo getenv("DATABASE_PASSWORD");
echo "\r\n";

$connectionstring=getenv("DATABASE_SERVICE_NAME")." ".getenv("DATABASE_NAME")." ".getenv("DATABASE_USER")." ".getenv("DATABASE_PASSWORD");

echo $connectionstring;
echo "\r\n";

echo $dbconn=pg_connect($connectionstring);

echo "\r\n";

try{
  $bdd = new PDO('mysql:host='.getenv("DATABASE_SERVICE_NAME").';dbname=default;charset=utf8', 'wavestoneadmin', 'Azerty123');
}catch (Exception $e){
  die('Erreur : '.$e->getMessage());
}

?>
