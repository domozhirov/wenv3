<?php

/**
 * Class TextController
 * @author: Mikhail Domozhirov <michael@domozhirov.ru>
 * @date: 2017-08-16
 */

namespace Controllers;

use Core\Controller;

class ImageController extends Controller {

	public function getAction($size) : bool {
		$size = explode('x', $size);
		$width = $size[0];
		$height = $size[1];

		ob_start();
		$im = imagecreate($width, $height);
		$background_color = imagecolorallocate($im, 190, 190, 190);
		$text_color = imagecolorallocate($im, 0, 0, 0);
		imagestring($im, 20, 5, 5,  $width . "x" . $height, $text_color);
		imagepng($im);
		imagedestroy($im);
		$data = base64_encode(ob_get_clean());

		echo 'Content-type: image/png';
//		echo 'data:image/png;base64,' . $data;
		echo $data;

		return true;
	}
}