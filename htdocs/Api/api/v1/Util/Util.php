<?php

include_once __DIR__ . "/../Controller/CartController.php";

class Util
{
    public static $token;


    /**
     * @param $data
     * @return array|string
     */
    public function clean_input($data){
        $cleaner = array();
        if(is_array($data)){
            foreach ($data as $key => $value){
                return $cleaner[$key] = $this->clean_input($value);
            }
        }else{
            $data = trim(stripcslashes($data));
            $data = strip_tags($data);
            $data = htmlentities($data);
            return trim($data);
        }

        return $cleaner;
    }

    public static function checkIP(){
        return (bool)ip2long($_SERVER['HTTP_HOST']);
    }

    /**
     * @return string
     */
    public static function Url(){
        $page_url   = 'http';
        if(isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on'){
            $page_url .= 's';
        }

        return $page_url.'://'.$_SERVER['SERVER_NAME'];
    }

    /**
     * @param $pass
     * @return bool|string
     */
    public static function Hash($pass) {
        $salt = 'abcdefghijklmnopqrstuvxywz1234567890()-_.$%@!&*\/';
        $sal = substr(sha1(md5("$pass$salt")), 0, 20);
        $hash = hash('sha512',$sal);
        $hash = sha1(substr($hash,0,20));
        $hash = substr($hash,0,25);
        return $hash;
    }

    /**
     * @return string
     * @throws Exception
     */
    public static function generate_key(){
        return  bin2hex(openssl_random_pseudo_bytes(32));
    }

    /**
     * @return mixed
     */
    public function Method(){
        return $this->method = $_SERVER['REQUEST_METHOD'];
    }

    public static function RequestType(){
        $re = apache_request_headers();
        $r = '';
        if(is_array($re) && isset($re['Request-type']))
            $r = $re['Request-type'];
        return $r;
    }


    // PHP has no base64UrlEncode function, so let's define one that
    // does some magic by replacing + with -, / with _ and = with ''.
    // This way we can pass the string within URLs without
    // any URL encoding.
    /**
     * @param $text
     * @return string|string[]
     */
   public static function  base64UrlEncode($text)
    {
        return str_replace(
            array('+', '/', '='),
            array('-', '_', ''),
            base64_encode($text)
        );
    }

    /**
     * @param $user object
     * @return false|string
     */
    public static function generateToken($user,$key){

        if ($user === null && empty($user))
            return false;

        if ($key === null && empty($key))
            return false;

        // Create the token header
        $header = self::base64UrlEncode(json_encode([
            'typ' => 'JWT',
            'alg' => 'HS256'
        ]));

        $issuedAt   = new DateTimeImmutable();
        $expire     = $issuedAt->modify("+1 day")->getTimestamp()
            +  60 * 60 * 24 * 60; //  valid for 60 days (60 seconds * 60 minutes * 24 hours * 60 days)
        $serverName = $_SERVER["SERVER_NAME"];

        // Create the token payload
        $payload = self::base64UrlEncode(json_encode([
            'iat'  => $issuedAt->getTimestamp(),         // Issued at: time when the token was generated
            'iss'  => $serverName,                       // Issuer
            'nbf'  => $issuedAt->getTimestamp(),         // Not before
            'exp'  => $expire,
            'username' => $user->username,
        ]));

        // Create Signature Hash
        $signature = self::base64UrlEncode(hash_hmac('sha256', $header . "." . $payload, $key, true));

        // Create token
       return "$header.$payload.$signature";  /// return token
    }

    /**
     * @param $file
     * @param $dir
     * @return array
     */
    public static function Uploader($file,$dir)
    {
        $dir = $_SERVER["DOCUMENT_ROOT"].$dir;

        // Count total files
        $countfiles = is_array($_FILES["$file"]['name']) ? count($_FILES["$file"]['name'])  : 1;

        $filename = '';
        $message ='';
        // Looping all files
        for($i=0;$i<=$countfiles - 1;$i++){

            $status = false;
            if(is_array($_FILES["$file"]['name'])){

                $fname = $_FILES["$file"]['name'][$i];
                $size = $_FILES["$file"]['size'][$i];
                $error = $_FILES["$file"]['error'][$i];
                $type = $_FILES["$file"]['type'][$i];
                $loc = $_FILES["$file"]['tmp_name'][$i];
            }else{
                $fname = $_FILES["$file"]['name'];
                $size = $_FILES["$file"]['size'];
                $error = $_FILES["$file"]['error'];
                $type = $_FILES["$file"]['type'];
                $loc = $_FILES["$file"]['tmp_name'];
            }

            $dot = explode('.',$fname);
            $ext = end($dot);

            if(!preg_match("/\.(jpg|jpeg|png|gif|pdf|webp|doc|docx)$/i",$fname)) {
                $message = "File(s) not allowed try, jpg,png,gif,webp, pdf, doc, docx \n";
            }else if($error > 0) {
                $message = 'Sorry an error occurred please try again';
            }else if($size >= 6796966) {
                $message = 'File is larger than 6MB. Try less than that';
            }
            else {
                $status = false;
                $newname = $dot[0] = "fr".sha1(microtime()).".$ext,";

                $message = '';
                $filename = preg_replace("#[^a-z0-9._]#i","",$newname);

                if(self::mkpath($dir) && !file_exists($dir. '' .$filename)) {
                    if(move_uploaded_file($loc, $dir. '/' .$filename)) {

                        if(preg_match("/\.(jpg|png|gif)$/i",$filename)){
                            self::rotate("$dir$filename",$ext);
                        }

                        $message .= $countfiles > 0 ? $filename.',' : $filename;
                        $status = true;

                    }else{
                        $status = false;
                        $message = 'Sorry an error occurred please try again!! '.$dir. '' .$filename;
                    }
                }

            }

        }

        return array('status'=>$status,'file'=>chop($message,','),'dir'=>$dir,'ext'=>$ext);
    }

    /**
     * @param $data
     * @return string
     */
    public static function transformData($data){
        $output = '<ul>';
        if(is_string($data)){
            $data = explode('\n', $data);
        }

        foreach($data as $val){
            $extract    = "<li>$val</li>";
            $output    .= $extract . PHP_EOL;
        }

        $output .= "</ul>";

        return $output;
    }

    /**
     * @param $source
     * @param $destination
     * @param $quality
     * @return mixed
     */
    public static function compressImage($source, $destination, $quality) {
        // Get image info
        $imgInfo = getimagesize($source);
        $mime = $imgInfo['mime'];

        // Create a new image from file
        switch($mime){
            case 'image/jpeg':
                $image = @imagecreatefromjpeg($source);
                break;
            case 'image/png':
                $image = @imagecreatefrompng($source);
                break;
            case 'image/gif':
                $image = @imagecreatefromgif($source);
                break;
            default:
                $image = @imagecreatefromjpeg($source);
        }

        // Save image
        @imagejpeg($image, $destination, $quality);

        // Return compressed image
        return $destination;
    }

    /**
     * @param $path
     * @param $ext
     */
    public static function rotate($path,$ext){
        $exif = exif_read_data($path);
        if(isset($exif['Orientation']) && $exif['Orientation'] != "1"){
            $position = $exif['Orientation'];
            $degrees = "";
            if($position == "8"){
                $degrees = "90";
            } else if($position == "3"){
                $degrees = "180";
            } else if($position == "6"){
                $degrees = "-90";
            }

            if($degrees == "90" || $degrees == "180" || $degrees == "-90"){

                if($ext === "gif" || $ext === "GIF"){
                    $source = imagecreatefromgif($path);
                }else if($ext === "png" || $ext === "PNG"){
                    $source = imagecreatefrompng($path);
                }else{
                    $source = imagecreatefromstring(file_get_contents($path));
                }

                list($w_org,$h_org) = getimagesize($path);

                $fbk = imagecreatetruecolor($w_org,$h_org);
                imagecopyresampled($fbk,$source,0,0,0,0,$w_org,$h_org,$w_org,$h_org);

                $rotate = imagerotate($source, $degrees, 0);
                imagejpeg($rotate, realpath($path));

                imagedestroy($source);
                imagedestroy($rotate);
            }

        }
    }

    /**
     * @param $base64
     * @param $output_file
     * @return mixed
     */
    public static function base64_to_PNG( $base64, $output_file){
        $data = preg_replace("#^data:image/\w+;base64,#i",
            '', $base64);

        $data = str_replace(' ', '+', $data);

        $file = "fr".sha1(microtime()).".jpg";
        $outputname = $_SERVER['DOCUMENT_ROOT'].$output_file.$file;
        self::mkpath($output_file);
        file_put_contents($outputname,
            base64_decode($data));

        chmod($output_file, 0777);

//        self::compressImage($outputname,$outputname,20);
//        self::rotate($outputname,'jpg');

        return $file;
    }

    /**
     * @param $path
     * @return bool
     */
    public static function delete_file($path){
        if (is_dir($path) === true)
        {
            $files = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($path), RecursiveIteratorIterator::CHILD_FIRST);

            foreach ($files as $file)
            {
                if (in_array($file->getBasename(), array('.', '..')) !== true)
                {
                    if ($file->isDir() === true)
                    {
                        rmdir($file->getPathName());
                    }

                    else if (($file->isFile() === true) || ($file->isLink() === true))
                    {
                        unlink($file->getPathname());
                    }
                }
            }

            return rmdir($path);
        }

        else if ((is_file($path) === true) || (is_link($path) === true))
        {
            return unlink($path);
        }

        return false;
    }


    /**
     * @param $path
     * @return bool
     */
    public static function mkpath($path)
    {
        if(@mkdir($path) || @file_exists($path)) return true;

        return (self::mkpath(dirname($path)) and @mkdir($path));
    }

    /**
     * @return false
     * @throws Exception
     */
    public static function tokenValidate($token = ''){

      // get the local secret key
        $secret = getenv('SECRET');

        $token = !empty($token) ? $token : Util::getToken();

        // check key/secret
        if(empty($secret) || empty($token))
           return false;

        // check token if exist
        if($token === null)
           return false;

        // get vaules
        $toke = explode('.', $token);
        $header = $toke[0];
        $payload = $toke[1];
        $signature = $toke[2];

        // check expire time
        $date = new DateTime();
        $exp = $date->setTimestamp(json_decode(base64_decode($payload))->exp);
        $exp = new DateTime(date("Y-m-d H:i:s",$exp->getTimestamp()));
        $date = new DateTime();
        $now = new DateTime(date("Y-m-d H:i:s",$date->getTimestamp()));

        $dif = $exp->diff($now);
        $days = $dif->days;
        $minutes = $dif->m;
        $hours = $dif->h;
        $secs = $dif->s;

        $isNotExpired = $days > 0 || $hours > 0 || $minutes > 0 || $secs > 0;

        // generate signature
        $sig = Util::base64UrlEncode(hash_hmac('sha256', $header . "." . $payload, $secret, true));

        // verify signature
        $isValidSignature = ($signature === $sig);

        $status = false;
        // validate
        if($isValidSignature && $isNotExpired) {
            $status = true;
            self::$token = self::encrypt_decrypt($token);
        }

        return $status;
    }


    /**
     * Get header Authorization
     * */
    public static function getAuthorizationHeader(){
        $headers = null;
        if (isset($_SERVER['Authorization'])) {
            $headers = trim($_SERVER["Authorization"]);
        }
        else if (isset($_SERVER['HTTP_AUTHORIZATION'])) { //Nginx or fast CGI
            $headers = trim($_SERVER["HTTP_AUTHORIZATION"]);
        } elseif (function_exists('apache_request_headers')) {
            $requestHeaders = apache_request_headers();
            // Server-side fix for bug in old Android versions (a nice side-effect of this fix means we don't care about capitalization for Authorization)
            $requestHeaders = array_combine(array_map('ucwords', array_keys($requestHeaders)), array_values($requestHeaders));
            //print_r($requestHeaders);
            if (isset($requestHeaders['Authorization']))
                $headers = trim($requestHeaders['Authorization']);
        }

        return $headers;
    }

    /**
     * get access token from header
     * */
    public static function getToken() {
        $headers = self::getAuthorizationHeader();
        $token = null;

        // HEADER: Get the access token from the header
        if (!empty($headers)) {
            if (preg_match('/Owesis\s(\S+)/', $headers, $matches)) {

                $token = self::encrypt_decrypt($matches[1], 'decrypt');

            }
        }
        return $token;
    }

    public static function valid_email(string $email){

        // SET INITIAL RETURN VARIABLE
        // ENSURE -> EMAIL ISN'T EMPTY | AN @ SYMBOL IS PRESENT

        $emailIsValid = FALSE;

        if (
            !empty($email) &&
            strpos($email, '@') !== FALSE
        ) {

            // GET EMAIL PARTS

            $email  = explode('@', $email);
            $user   = $email[0];
            $domain = $email[1];

            // VALIDATE EMAIL ADDRESS

            if (
                count($email) === 2 &&
                !empty($user) &&
                !empty($domain) &&
                checkdnsrr($domain)
            ) {
                $emailIsValid = TRUE;
            }
        }

        // RETURN RESULT

        return $emailIsValid;
    }

    /**
     * @return array|false|string
     */
    public static function app(){
        return getenv('app_name');
    }

    /**
     * @param $from
     * @param $email
     * @param $subject
     * @param $message
     * @param string $username
     * @param string $file
     * @param string $filename
     * @param false $ccc
     * @return string
     */
    public static function Mailer($from,$email,$subject,$message,$username = '',
                           $file ='',$filename = "fr.pdf",$ccc = false){

        $appName = getenv('APP_NAME');
        include_once __DIR__.'/../PHPMailer/src/Exception.php';
        include_once __DIR__.'/../PHPMailer/src/PHPMailer.php';
        include_once __DIR__.'/../PHPMailer/src/SMTP.php';

// Instantiation and passing `true` enables exceptions
        $mail = new PHPMailer(true);

        try {
            //Server settings
//            $mail->SMTPDebug = 2;                                       // Enable verbose debug output
//            $mail->isSMTP();                                            // Set mailer to use SMTP
//            $mail->Host       = 'smtp.nictanzania.co.tz;smtp.nictanzania.co.tz';  // Specify main and backup SMTP servers
//            $mail->SMTPAuth   = true;                                   // Enable SMTP authentication
//            $mail->Username   = 'info@nictanzania.co.tz';                     // SMTP username
//            $mail->Password   = 'secret';                               // SMTP password
//            $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;         // Enable TLS encryption, `PHPMailer::ENCRYPTION_SMTPS` also accepted
//            $mail->Port       = 587;                                    // TCP port to connect to
//echo $email;
            //Recipients
            $mail->setFrom($from, $appName);
            $mail->addAddress($email, $username);     // Add a recipient
//            $mail->addAddress('ellen@example.com');               // Name is optional
            $mail->addReplyTo($from, $username);
            $mail->addBCC('frankgalos@hotmail.com');
            if($ccc){
                $cc = explode(',',$ccc);
                for($i =0; $i <= count($cc); $i++){
                    $mail->addCC("'".$cc[$i]."'");
                }
            }

            // Attachments    // Add attachments  // Optional name
            if (!empty($file)){
                $mail->addAttachment($file, $filename);
            }

            // Content
            $mail->isHTML(true);                                  // Set email format to HTML
            $mail->Subject = $subject;
            $mail->Body    = $message;
//            $mail->AltBody = 'This is the body in plain text for non-HTML mail clients';

            $mail->send();
            return 'Email has been sent';
        } catch (Exception $e) {
            return "Email could not be sent. Mailer Error: {$mail->ErrorInfo}";
        }
    }

    /**
     * @param $time
     * @param string $prefix
     * @return string
     */
    public static function ago( $time, $prefix = 's' )
    {
        $time = date(strtotime($time));
        $time_difference = time() - $time;

        if( $time_difference < 1 ) { return 'less than 1 second ago'; }
        $condition = array(
            12 * 30 * 24 * 60 * 60 =>  $prefix === 'l' ? 'year' :'yr',
            30 * 24 * 60 * 60       =>  $prefix === 'l' ? 'month' :'mon',
            24 * 60 * 60            =>  $prefix === 'l' ? 'day' :'d',
            60 * 60                 =>  $prefix === 'l' ? 'hour':'hr',
            60                      =>  $prefix === 'l' ? 'minute':'min',
            1                       =>  $prefix === 'l' ? 'second':'sec'
        );

        foreach( $condition as $secs => $str )
        {
            $d = $time_difference / $secs;

            if( $d >= 1 )
            {
                $t = round( $d );
                return $t . '' . $str . ( $t > 1 ? 's' : '' ) . ' ago';
            }
        }
    }

    /**
     * @param $n
     * @param int $precision
     * @return string
     */
    public static function short_number( $n, $precision = 1 ) {
        if ($n < 900) {
            // 0 - 900
            $n_format = number_format($n, $precision);
            $suffix = '';
        } else if ($n < 900000) {
            // 0.9k-850k
            $n_format = number_format($n / 1000, $precision);
            $suffix = 'K';
        } else if ($n < 900000000) {
            // 0.9m-850m
            $n_format = number_format($n / 1000000, $precision);
            $suffix = 'M';
        } else if ($n < 900000000000) {
            // 0.9b-850b
            $n_format = number_format($n / 1000000000, $precision);
            $suffix = 'B';
        } else {
            // 0.9t+
            $n_format = number_format($n / 1000000000000, $precision);
            $suffix = 'T';
        }

        // Remove unecessary zeroes after decimal. "1.0" -> "1"; "1.00" -> "1"
        // Intentionally does not affect partials, eg "1.50" -> "1.50"
        if ( $precision > 0 ) {
            $dotzero = '.' . str_repeat( '0', $precision );
            $n_format = str_replace( $dotzero, '', $n_format );
        }

        return $n_format . $suffix;
    }

    /**
     * @param $string
     * @param string $action
     * @return false|string
     */
    public static function encrypt_decrypt($string,$action = 'encrypt') {
        $output = false;

        $encrypt_method = "AES-256-CBC";
        $secret_key = '90dsu32id392mzc3h82';
        $secret_iv = '238932ojldsf0';

        // hash
        $key = hash('sha256', $secret_key);

        // iv - encrypt method AES-256-CBC expects 16 bytes - else you will get a warning
        $iv = substr(hash('sha256', $secret_iv), 0, 16);

        if ( $action == 'encrypt' ) {
            $output = openssl_encrypt($string, $encrypt_method, $key, 0, $iv);
            $output = base64_encode($output);
        } else if( $action == 'decrypt' ) {
            $output = openssl_decrypt(base64_decode($string), $encrypt_method, $key, 0, $iv);
        }
        return $output;
    }

    /**
     * @return string
     */
    public static function get_site_url(){
        return self::Url().'/';
    }

    public static function staticUrl(){
        return self::Url().'/public/';
    }

    public static  function root(){
        return $_SERVER["DOCUMENT_ROOT"].'/';
    }


       public static  function CartNotification(){
         $notification = new CartController(); 
       	return $notification->get(); 
        
    }
       public static  function searchList(){
         $notification = new CartController(); 
        return $notification->get_search(); 
        
    }

}