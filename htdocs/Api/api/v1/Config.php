<?php
// KOO_BUS_ADAPT: Usalama wa makosa.
// - Kwenye production hatuonyeshi makosa kwa mtumiaji (yanaweza kuwa na
//   taarifa nyeti: majina ya tables, paths, data).
// - Makosa yanaandikwa kwenye log ya server pekee.
// - Weka APP_ENV=development kwenye .rd/.env kuona makosa wakati wa dev.
include_once __DIR__."/Util/DotRD.php";

include_once __DIR__."/HTTP/http.php";
include_once __DIR__."/Util/Util.php";

use DotRD\DotRD;
(new DotRD(__DIR__ . '/.rd'))->load();

// KOO_BUS_ADAPT: APP_ENV inasomwa BAADA ya .rd kupakiwa, ili
// APP_ENV=production kwenye .rd ifanye kazi.
$appEnv = koobus_env('APP_ENV') ?: 'development';
error_reporting(E_ALL);
ini_set('log_errors', '1');
ini_set('display_errors', $appEnv === 'production' ? '0' : '1');


class Config extends HTTP {
    public $routes = array(); // number of pages captured on the url
    public $route = '';
    public $route1 = '';
    public $route2 = '';
    public $route3 = '';
    public $route4 = '';
    public $route5 = '';
    public $route6 = '';

    public function __construct()
    {
        parent::__construct();

        // KOO_BUS_ADAPT: URL inachambuliwa kwa mpangilio:
        //   /api/v1/{route}/{method}/{param1}/{param2}...
        // Tunaondoa `/api/v1` popote ilipo kwenye path ili API ifanye kazi
        // bila kujali imewekwa kwenye htdocs root au kwenye folder `Api`.
        $path = parse_url(isset($_SERVER["REQUEST_URI"]) ? $_SERVER["REQUEST_URI"] : "/", PHP_URL_PATH);
        $segments = array_values(array_filter(explode("/", (string)$path), function ($part) {
            return $part !== "";
        }));
        $this->routes = $segments;

        $lowerSegments = array_map("strtolower", $segments);
        $apiPos = array_search("api", $lowerSegments, true);
        if ($apiPos !== false) {
            $start = $apiPos + 1;
            if (isset($segments[$start]) && strtolower($segments[$start]) === "v1") {
                $start++;
            }
            $segments = array_slice($segments, $start);
        }

        $routeKey = isset($segments[0]) ? strtolower(rawurldecode($segments[0])) : "";
        $method = isset($segments[1]) ? strtolower(rawurldecode($segments[1])) : "";
        $args = array_slice($segments, 2);
        $args = array_map("rawurldecode", $args);

        $this->route1 = $method;
        $this->route2 = isset($args[0]) ? $args[0] : "";
        $this->route3 = isset($args[1]) ? $args[1] : "";
        $this->route4 = isset($args[2]) ? $args[2] : "";
        $this->route5 = isset($args[3]) ? $args[3] : "";
        $this->route6 = isset($args[4]) ? $args[4] : "";

        // Njia za zamani zinazoingia moja kwa moja (bila jina la route).
        if ($routeKey === "install") {
            $this->route = "Table";
            $method = "install";
        } elseif ($routeKey === "login") {
            $this->route = "Users";
            $method = "login";
        } elseif ($routeKey === "password") {
            $this->route = "Users";
            $method = "pass";
        } elseif ($routeKey === "activate") {
            $this->route = "Users";
            $method = "activate";
        } elseif ($routeKey === "user") {
            $this->route = "Users";
            if ($method === "") $method = "user";
        } elseif ($routeKey === "users") {
            $this->route = "Users";
            if ($method === "") $method = "users";
        } elseif ($routeKey === "search") {
            $this->route = "Search";
            if ($method === "") $method = "search";
        } else {
            // `trip_events`, `trip-events` -> `TripEvents`
            $routeName = str_replace(" ", "", ucwords(str_replace(array("-", "_"), " ", $routeKey)));
            $this->route = preg_replace("/[^A-Za-z0-9]/", "", $routeName);
        }

        $method = preg_replace("/[^a-z0-9_]/", "", str_replace("-", "_", $method));
        $this->route1 = $method;

        if ($this->route === "" || $this->route === null) {
            return print_r(parent::response(array("status" => 403, "payload" => "Unauthorised Access")));
        }

        $params = parent::encode(array(
            'page' => $this->route2,
            'page1' => $this->route3,
            'page2' => $this->route4,
            'page3' => $this->route5,
            'page4' => $this->route6
        ));

        $routeFile = __DIR__ . "/Routes/" . $this->route . ".php";
        if (file_exists($routeFile)) {
            include_once $routeFile;

            if (!class_exists($this->route)) {
                return print_r(parent::response(array("status" => 403, "payload" => "Unauthorised Access")));
            }

            $class = new $this->route();

            if ($method !== "" && is_callable(array($class, $method))) {
                return print_r(parent::response($class->$method($params))); /// This method should only return array data
            }

            return print_r(parent::response(array("status" => 403, "payload" => "Unauthorised Access")));
        }

        // `install`/`Table` iko kwenye root ya api/v1, si kwenye Routes/.
        if (file_exists(__DIR__ . "/" . $this->route . ".php")) {
            return include_once __DIR__ . "/" . $this->route . ".php";
        }

        return print_r(parent::response(array("status" => 403, "payload" => "Unauthorised Access")));
    }

}

new Config();
