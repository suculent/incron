<?php

	# load defaults
    require_once("cfg.php");

    # define some corellation id
    $corellationId = microtime(true);

    # todo if file exists, wait a microsecond and get new corellation id :o)

    # save incoming request into an incron queue folder
    file_put_contents("$pfx/in/".$corellationId.".json",
        json_encode($_GET));

    # return response with identifier of the queued operation
    print json_encode(array("rc"=>"ok","date"=>time(),"id"=>$corellationId));

?>