#include <iostream>
#include "MyApp/Foo.h"
#include "MyLibrary/Foo.h"

int main()
{
    std::cout << "Hello, World!" << std::endl;

    MyApp::Foo myAppFoo;
    std::cout << "MyApp::Foo=" << myAppFoo.GenerateNumber() << std::endl;

    MyLibrary::Foo myLibraryFoo;
    std::cout << "MyLibrary::Foo=" << myLibraryFoo.GenerateNumber() << std::endl;
    return 0;
}
