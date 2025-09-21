use WebDyne::Constant;
$_={
    'WebDyne::Constant' => {
        WEBDYNE_ERROR_SHOW          => 1,
        WEBDYNE_ERROR_SHOW_EXTENDED => 1,
        #WEBDYNE_HTML_PARAM0          => {
        #    %{ $WebDyne::Constant::WEBDYNE_HTML_PARAM },
        #    style => 'https://cdn.jsdelivr.net/npm/water.css@2/out/water.css'
        #},
        WEBDYNE_HEAD_INSERT         => '<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.classless.min.css"><style>:root { --pico-font-size: 85% } body { margin-top: 10px; margin-left: 10px; }</style>',
    }
}

