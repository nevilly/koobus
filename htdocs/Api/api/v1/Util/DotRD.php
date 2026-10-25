<?php


namespace DotRD;

class DotRD
{
    /**
     * The directory where the .env file can be located.
     *
     * @var string
     */
    protected $path;


    public function __construct(string $path)
    {
        if(!file_exists($path)) {
            throw new \InvalidArgumentException(sprintf('%s does not exist', $path));
        }
        $this->path = $path;
    }

    public function load() :void
    {
        if (!is_readable($this->path)) {
            throw new \RuntimeException(sprintf('%s file is not readable', $this->path));
        }

        $lines = file($this->path, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        foreach ($lines as $line) {

            if (strpos(trim($line), '#') === 0) {
                continue;
            }

            list($name, $value) = explode(':', $line, 2);
            $name = trim($name);
            $value = trim($value);

            // KOO_BUS_ADAPT: HATUTUMII putenv() hapa.
            // Apache/Windows hutumia threads; putenv() ni process-wide na
            // inaweza kusababisha getenv() kurudisha tupu kwa request nyingine
            // inayotumika kwa wakati mmoja. Tunahifadhi values kwenye
            // request-level superglobals + KOO_ENV, na koobus_env() ndiyo
            // inayosoma. Hii inaondoa race ya 401 za nasibu.
            if (!array_key_exists($name, $_SERVER) && !array_key_exists($name, $_ENV)) {
                $_ENV[$name] = $value;
                $_SERVER[$name] = $value;
            }
            $GLOBALS['KOO_ENV'][$name] = $value;
        }
    }
}