ModelCoder
==========

ModelCoder can Automatic generate Objective-C code by JSON string.

####json一键转换为EasyIOS中Model类的工具。

##Usage

* 1.Installation `Homebrew`

	If you have `homebrew` installed, just jump to the second step

  		ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
	
* 2.Installation `objc-run`
	
	If you have `objc-run` installed, just jump to the third step

		brew install objc-run
		
	find the objc-run path and Make sure the executable bit is set like this:

		chmod u+x objc-run

* 3.curl download the `main.m`
	
	If you have download the `main.m`, just jump to the fourth step

		curl -O https://raw.githubusercontent.com/zhuchaowe/ModelCoder/master/main.m
		
* 4.run!!!
		
		objc-run main.m  className  savePath  http://the.json.url.com

##Example

		objc-run main.m Test /Users/huwei/Desktop/objc http://gc.ditu.aliyun.com/regeocoding?l=39.938133,116.395739&type=001

