use WebDyne::Constant;
$_={
    'WebDyne::Constant' => {
        WEBDYNE_ERROR_SHOW          => 1,
        WEBDYNE_ERROR_SHOW_EXTENDED => 1,
        WEBDYNE_HEAD_INSERT         => << 'END'
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.classless.min.css">
<style>
    :root { --pico-font-size: 85% } 
    body { padding-top: 10px; padding-left: 10px; }
    :where(input:not([type=checkbox]):not([type=radio]),
           select,
           textarea,
           progress,
           meter,
           fieldset) {
      max-width: 400px;   /* or whatever you prefer */
      width: 100%;        /* still responsive within that max */
      box-sizing: border-box;
    }
</style>
END
  }
}

