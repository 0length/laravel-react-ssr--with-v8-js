<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use App\PageModel;

class AdminController extends Controller
{
    public $viewdata = [];
    protected $v8;
    protected $js_path_file;
    protected function getMarkup($component, $props, $js_path) {
        $default_prop = json_encode($props);
        $v8 = $this->v8;
        $js[] = "var global = global || this, self = self || this, window = window || this;";
        $js[] = File::get(public_path($js_path));
        $js[] = "print(ReactDomServer.renderToString(React.createElement(${component}, ${default_prop})));";
        $code = implode(";\n", $js);
        ob_start();
        $v8->executeString($code);
        return ob_get_clean();
    }
    public function __construct()
    {
        $this->page = new PageModel();
        $this->viewdata = $this->page->viewdata();
        $this->v8 = new \V8Js();
        $this->js_path_file = 'vendor/index';
    }
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */


    public function index()
    {
        $ComponentName = 'HomePage';
        $props = [];
        $this->viewdata['isServerRenderingEnabled'] = TRUE;
        $this->viewdata['page_title'] = __('page.index_title');
        $this->viewdata['ComponentName'] = $ComponentName;
        $this->viewdata['markup'] = $this->getMarkup($ComponentName, $props, $this->js_path_file);
        return view('index.index', $this->viewdata);
    }

    public function script($name)
    {
        if(preg_match('/^[0-9a-z.]+$/i', $name)) {
            return response(File::get(public_path('vendor/'.explode(".", $name)[0])))->header('Content-Type',' text/javascript');

          }else{
            // invalid
            $data['title'] = '404';
            $data['name'] = 'Page not found';
            return response()
                ->view('errors.404', $data, 404);
          }
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}
