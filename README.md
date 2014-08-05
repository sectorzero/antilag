antilag 
=======
simplified and structured c++ build tool setup using cmake and with integrated support for common libraries
(https://www.youtube.com/watch?v=DK3XTvqtNrg)

Motivation : 
I find setting up the build and depedency for c/c++ project extremely painful and arcane (https://www.youtube.com/watch?v=tTDn604ipYY). 
I am not sure how many folks relate to my pain. Finding and linking to third-party dependency is an art in terms of process. If there is a simple structure to it and if something makes everything work predictably it would be great. When I want to write a simple program, I want to do it without any effort spent on trying to weave the build / dependency labrynth. The flow of writing and running simple programs should have zero 'setup overhead'. 
Thankfully I found CMake which makes this manageable. But it will be great if there is simplfied structure setup for quickly getting down to the code without having to experiment with the muck. And it would be wonderful if it came with predictable support for commonly used development libaries and frameworks already baked in.

Goals :
* writing a c/c++ simple package with dependencies should be an easy w.r.t to build tool and dependency setup
* unit-testing framework support should be built in
* Boost support should come out of the box
* it should be painlessly-easy to add third-party dependencies. Eg. protobuf, leveldb etc. all necessary dependencies should be referenced and linked using package local artifacts. dependencies libraries should be easy to build and depend on in a portable, deterministic and easy way.
* should be feasible to run edit-compile-edit cycles via vim or emacs
* clean seperation of source code and built artifacts
* basic build targets - executable, library, test, clean should be available by default
* should take almost no learning effort and less than 5 mins to setup and execute a c/c++ program
* should provide easy way to invoke debuggers and profilers ( stretch goal )

Current Library / Tooling Integration : 
* Uses cmake - the simplest engine with required power
* Testing framework - integrated out of the box with googletest
* Git support
* Designed for vim/emacs compile-edit-compile cycles
* C++11 ( currently probably works only on MacOS )

TODO Library / Tooling Integration : 
* Protobuf
* Testing framework - integrated out of the box with googlemock
* Testing framework - Catch
* Boost support
* logging - easyloggingcpp
* google-breakpad
* leveldb, wiredtiger, sqlite

TODO : 
* profiling support ??
* debugger support ??
* provide example package on showing how to include googleprotobuf as dependency and write an unittest
* Logging Library : this seems to be a good choice, c++11, header-only, good feature set : https://github.com/easylogging/easyloggingpp
