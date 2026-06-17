
#include "Foo.h"

// NOLINTNEXTLINE(readability-convert-member-functions-to-static) -- intentionally an instance method to contrast with MyLibrary::Foo's static method
int MyApp::Foo::GenerateNumber() const
{
    return 2;
}
