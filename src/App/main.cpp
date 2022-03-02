#include <string>
#include "fmt/core.h"
#include "Poco/MD5Engine.h"
#include "Poco/DigestStream.h"
#include "MyApp/Foo.h"
#include "MyLibrary/Foo.h"

using namespace fmt;
using namespace std;

string GeneratePocoMd5Hex()
{
    Poco::MD5Engine md5;
    Poco::DigestOutputStream ds(md5);
    ds << "abcdefghijklmnopqrstuvwxyz";
    ds.close();
    return Poco::DigestEngine::digestToHex(md5.digest());
 }

int main(int argc, char** argv)
{
    print("Hello, World!\n");

    MyApp::Foo myAppFoo;
    print("MyApp::Foo={}\n", myAppFoo.GenerateNumber());

    MyLibrary::Foo myLibraryFoo;
    print("MyLibrary::Foo={}\n", myLibraryFoo.GenerateNumber());

    string md5Hex = GeneratePocoMd5Hex();
    print("Poco::MD5::Hex={}\n", md5Hex);
    return 0;
}
