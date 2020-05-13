<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class PageModel extends Model
{
    public function __construct() 
    {

    }

    public function viewdata()
    {
        return [
            'site_name' => config('app.name')
        ];
    }
}
