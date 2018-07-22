<?php
namespace App;

class Swoole extends \ManaPHP\Rest\Swoole
{
    protected function _beforeRequest()
    {
    //    parent::_beforeRequest();
        //  $this->debugger->start();

        //xdebug_start_trace('/home/mark/manaphp/data/traces/' . date('Ymd_His_') . mt_rand(1000, 9999) . '.trace');
    }

    protected function _afterRequest()
    {
    //    parent::_afterRequest();

        //   xdebug_stop_trace();
    }
}
