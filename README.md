ModelCoder
==========

ModelCoder can Automatic generate Objective-C code by JSON string.


##Usage

	
* 1.Installation `objc-run`

	If you have homebrew installed, just run

		brew install objc-run
		
	Otherwise, download the objc-run shell script file and install it in a directory that's in your $PATH. Make sure the executable bit is set like this:

		chmod u+x objc-run

* 2.curl download the `main.m`

		curl -O https://raw.githubusercontent.com/zhuchaowe/ModelCoder/master/main.m
		
* 3.run!!!
		
		objc-run main.m  className  savePath  http://the.json.url.com

##Example

		objc-run main.m Test /Users/huwei/Desktop/objc http://gc.ditu.aliyun.com/regeocoding?l=39.938133,116.395739&type=001

