<?php

echo "Bonjour Tlm!V2\n";

echo getenv("DATABASE_SERVICE_NAME");
echo "\r\n";
echo getenv("DATABASE_NAME");
echo "\r\n";
echo getenv("DATABASE_ENGINE");
echo "\r\n";
echo getenv("DATABASE_USER");
echo "\r\n";
echo getenv("DATABASE_PASSWORD");
echo "\r\n";


try{
  $bdd = new PDO('mysql:host=pgsql;dbname=default;charset=utf8', 'wavestoneadmin', 'Azerty123');
}catch (Exception $e){
  die('Erreur : '.$e->getMessage());
}



?>
