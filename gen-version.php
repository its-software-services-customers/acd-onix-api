<?php

declare(strict_types=1);

$product = 'ONIX';

$_ENV['BIN_DIR'] = dirname(__FILE__);
chdir($_ENV['BIN_DIR']);

print("Creating build.php ...\n");

$srcRoot = $_ENV['BIN_DIR'];

$fname = "$srcRoot/build.php";
$oh = fopen($fname, "w") or die("Unable to open file [$fname]!");
date_default_timezone_set('Asia/Bangkok');
$dt = date("mdYHis");
$tmp = '$APP_VERSION_LABEL = ' . "'$dt'";
$app_product = '$APP_BUILT_PRODUCT = ' . "'$product'";

$stmt = <<<EOD
<?php
/* 
Purpose : Auto generated built time file (DO NOT MODIFY)
Created By : Seubpong Monsar
*/

$tmp;
$app_product;

?>
EOD;

fwrite($oh, $stmt);
fclose($oh);

?>
