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
		
		objc-run main.m  className  savePath  http://the.json.url.com keyPath[optional]

##Example

* 1.read from json url

		objc-run main.m Test /Users/easyios/Desktop/objc http://t.cn/RPjToNg
		
* 2.read from json file

		objc-run main.m Test /Users/easyios/Desktop/objc /Users/easyios/Desktop/objc/EasyIOS.json
		
* 3.read from json for keypath

		objc-run main.m Test /Users/easyios/Desktop/objc http://t.cn/RPjToNg subspecs/xcconfig


