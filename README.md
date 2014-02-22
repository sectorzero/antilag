turbocharger
============

simple build tooling framework for c++ using cmake and integrated googletest

Motivation : 
I find getting setup with the buildtooling and depedency setup for c/c++ painful. There are ways which are not portable and linking to third-party dependency is an art in terms of process. If there is a simple structure to it and if something makes everything work predictably and without effort so that I can kick off writing simple packages it will great.

Goals :
* writing a c/c++ simple package with dependencies should be an easy w.r.t to build tool and dependency setup
* unit-testing framework support should be built in
* should be feasible to run edit-compile-edit cycles via vim or emacs
* clean seperation of source code and built artifacts
* all necessary dependencies should be referenced and linked using package local artifacts - i.e easily portable
* basic build targets - executable, library, test, clean should be available by default
* should take almost no learning effort and less than 5 mins to setup and execute a c/c++ program

Current Tooling Integration : 
* Uses cmake - the simplest engine with required power
* Testing framework - integrated out of the box with googletest and googlemock
* Git support
* Designed for vim/emacs compile-edit-compile cycles

TODO : 
* profiling support ??
* debugger support ??
* provide example package on showing how to include googleprotobuf as dependency and write an unittest
