@php
$isServerRenderingEnabled = true;
$markup = '';
if ($isServerRenderingEnabled) {
    require_once dirname(__FILE__) . './../../../vendor/autoload.php';

    function getMarkup($component, $props) {
      $default_prop = json_encode($props);
      $v8 = new V8Js();
      $js[] = "var global = global || this, self = self || this, window = window || this;";
      $js[] = File::get(public_path('dist/index.0.js'));
      $js[] = "print(ReactDomServer.renderToString(React.createElement(${component}, ${default_prop})));";
      $code = implode(";\n", $js);
      ob_start();
      $v8->executeString($code);
      return ob_get_clean();
    }

    $component = 'App';
    $props = [];
    $markup = getMarkup($component, $props);
}
@endphp

<!DOCTYPE html>
<html>
  <head>
    <title>React page</title>
  </head>
  <body>
    <div id="app">@php echo $markup; @endphp</div>
    <script src="{{asset('dist/index.0.js')}}"></script>

    <script>
        document.onreadystatechange = function () {
          if (document.readyState === 'complete') {
            ReactDom.render(
              React.createElement(App, {}),
              document.getElementById('app')
            );
          }
        }
    </script>
  </body>
</html>